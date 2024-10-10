

/*
  I2C SLAVE
  (I2C SPI Bridge) 
  by John Rufino Macasaet
  
  Note on I2C SCL Clock Freq:
  The I2C spec supports multiple data transfer rates:
     Standard       - 100 Kbit/s  = 100 KHz
     Fast mode      - 400 Kbit/s  = 400 KHz
     Fast mode plus - 1 Mbit/s    = 1 MHz     (max supported in this design)
     High-speed     - 3.4 Mbit/s  = 3.4 MHz   (not supported in this design)
*/

module I2CSLAVE#(
  parameter DATA_WIDTH = 8,
  parameter ADR_WIDTH = 8,                                // RW Address
  parameter COUNT_WIDTH  = $clog2(DATA_WIDTH),            // Counter width
  parameter I2CSLAVE_ADR = 7'b1010101                     // (0x55)
)(
  input CLK,                                              // I2C slave internal clock (operating at 5MHz)
  input RST_N,                                            // Synchronous reset
  input SCL, SDA_in,                                      // I2C Signals; SCL max freq is 1MHz
  input FINISH_SPI,
  input [DATA_WIDTH-1:0] RDATA_REG, RDATA_SPI,
  output reg SDA_out,                                         // SDA output enable on top block (0 = input, 1 = output)
  output reg REQ_REG, RW_FLAG, REQ_SPI, ERROR_SUSPEND,
  output [DATA_WIDTH-1:0] WDATA,
  output [ADR_WIDTH-3:0] ADR
);
  // ====== Top block declarations ======
  reg SCL_DFF0, SCL_DFF1;                                 // Cascaded DFFs to oversample and sample SCL and SDA at diff clock cycles
  reg SDA_in_DFF0, SDA_in_DFF1;                           // Also used to check start/stop
  
  reg EN_ShiftReg, EN_DataReg, EN_AdrReg;                 // Register Enable
  reg DIR, LOAD, RL_SEL, INCR;                            // Control Signals to register block

  // ====== Control Logic Declarations ======
  
  reg [2:0] state;                                          // Control FSM current state
  reg [2:0] next_state;                                     // Next FSM state (combinational)
  wire start, stop, in_cycle, off_cycle;                    // Used for determining the start and stop conditions
  reg FINISH_SPI_reg;                                       
  reg [COUNT_WIDTH:0] count;                                // Counter for serial data
  reg ACK;                                                  // For sending ack bit
  reg SDA_en;                                               // SDA 
  reg REPEATED_START;                                       // For indicating repeated start condition

  // FSM State Declaration
  localparam S_IDLE     = 0;                                // IDLE
  localparam S_IC_ADR   = 1;                                // Receive I2C device address  
  localparam S_RW_ADR   = 2;                                // Check received address and send ACK if match
  localparam S_WR_DATA  = 3;                                // Write Data (to specified address)
  localparam S_RD_DATA  = 4;                                // Read Data (from specified address)

  
  // ====== Shift Register Declarations ======
  wire LR_IN;
  wire [DATA_WIDTH-1:0] LR_OUT,RL_IN;
  reg [DATA_WIDTH-1:0] shift_reg;
  
  // ====== Address Register Declarations ======
  wire [DATA_WIDTH-1:0] DATA_IN_AdrReg;
  reg  [DATA_WIDTH-1:0] adr_reg;
  
  // ====== Data Register Declarations ======
  wire [DATA_WIDTH-1:0] DATA_IN_DataReg;
  reg  [DATA_WIDTH-1:0] data_reg;
  
  // =========================================
  //                SDA/SCL DFFs
  // =========================================
  
  // DFF to oversample SCL
  // Propagation: SCL -> DFF0 -> DFF1 -> DFF2
  always@(posedge CLK) begin
    if(!RST_N) begin  
      SCL_DFF0 <= 0;
      SCL_DFF1 <= 0;
    end
    else begin
      SCL_DFF0 <= SCL;
      SCL_DFF1 <= SCL_DFF0;
    end
  end
  
  // DFF to oversample SDA_in
  // Propagation: SDA_in -> DFF0 -> DFF1 -> DFF2
  always@(posedge CLK) begin
    if(!RST_N) begin  
      SDA_in_DFF0 <= 0;
      SDA_in_DFF1 <= 0;
    end
    else begin
      SDA_in_DFF0 <= SDA_in;
      SDA_in_DFF1 <= SDA_in_DFF0;
    end
  end
  
  // =========================================
  //                  CONTROL
  // =========================================
  
  // Determining the start and stop condition
  // Start condition when SDA 1->0 while SCL=1 
  assign start = (SDA_in_DFF0 == 0 && SDA_in_DFF1 == 1 && SCL_DFF0==1 && SCL_DFF1 == 1) ? 1 : 0;
  // Stop condition when SDA 0->1 while SCL=1 
  assign stop = (SDA_in_DFF0 == 1 && SDA_in_DFF1 == 0 && SCL_DFF0==1 && SCL_DFF1 == 1) ? 1 : 0;
  
  // Determining if in-cycle (i.e. SCL transitions to HIGH)
  assign in_cycle = (SCL_DFF0 == 1 && SCL_DFF1 == 0) ? 1 : 0;
  // Determining if off-cycle (i.e. SCL transitions to LOW)
  assign off_cycle = (SCL_DFF0 == 0 && SCL_DFF1 == 1) ? 1 : 0;
  
  // Next FSM State Assignment
  always@(*) begin
    case(state) 
      S_IDLE: begin                                            // IDLE State
        if(start && SCL_DFF1 == 1 && SCL_DFF0 == 1)            // start condition
          next_state = S_IC_ADR;
        else      
          next_state = S_IDLE; 
      end
      
      S_IC_ADR: begin                                          // Receive I2C Device Address
        if(stop && SCL_DFF1 == 1 && SCL_DFF0==1)               // checking stop condition
          next_state = S_IDLE;
        else if(count==8 && in_cycle)       
          if(shift_reg[DATA_WIDTH-1:1]==I2CSLAVE_ADR)          // If I2C Address matches, proceed to received ADR/RW bit
            next_state = shift_reg[0] ? S_RD_DATA : S_RW_ADR;  // If RW=1, S_RD_DATA; Else, S_RW_ADR
          else                                                 // If not match, back to IDLE
            next_state = S_IDLE;
        else                                
          next_state = S_IC_ADR;
      end
      
      S_RW_ADR: begin                                  // If I2C Address Match, set address for read/write
        if(stop && SCL_DFF1 == 1 && SCL_DFF0==1)       // checking stop condition
          next_state = S_IDLE;
        else if(start)                                 // Handling Repeated Start condition
          next_state = S_IC_ADR;      
        else if(count==8 && in_cycle)                  // Once all bits received, go to S_WR_DATA
          next_state = S_WR_DATA;
        else
          next_state = S_RW_ADR;
      end
      
      S_WR_DATA: begin                                 // Write Data operation to address set at S_RW_ADDR
        if(stop && SCL_DFF1 == 1 && SCL_DFF0==1)       // checking stop condition
          next_state = S_IDLE;
        else if(start && SCL_DFF1 == 1 && SCL_DFF0==1) // Handling Repeated Start condition
          next_state = S_IC_ADR;
        else
          next_state = S_WR_DATA;
      end
      
      S_RD_DATA: begin                                 // Read Data operation to address set at S_RW_ADDR
        if(stop && SCL_DFF1 == 1 && SCL_DFF0==1)       // checking stop condition
          next_state = S_IDLE;
        else if(start && SCL_DFF1 == 1 && SCL_DFF0==1) // Handling Repeated Start condition
          next_state = S_IC_ADR;
        else
          next_state = S_RD_DATA;
      end
      
      //default: begin
      //  next_state = S_IDLE;
      //end
      
    endcase
  end
  
  // FSM State Change
  always@(posedge CLK) begin
    if(!RST_N)  state <= S_IDLE;
    else        state <= next_state;
  end
  
  // Counter
  always@(posedge CLK) begin
    if(!RST_N)  
            count <= 0;
    else
      case(state)
        S_IDLE: begin
            count <= '1;
        end
        
        S_IC_ADR: begin
          if(next_state==S_IC_ADR && in_cycle)
            count <= count + 1;
          else if((next_state==S_RW_ADR||next_state==S_RD_DATA) && in_cycle)
            count <= 0;
          else
            count <= count;
        end
        
        S_RW_ADR: begin
          if(next_state==S_RW_ADR && in_cycle)
            count <= count + 1;
          else if(next_state == S_WR_DATA && in_cycle)
            count <= 0;
          else
            count <= count;
        end
        
        S_WR_DATA: begin
          if(next_state==S_IC_ADR)
            count <= 4'hF;
          else if(next_state==S_WR_DATA && count<8 && in_cycle)
            count <= count + 1;
          else if(next_state==S_WR_DATA && count==8 && in_cycle)
            count <= 0;
          else
            count <= count;
        end
        
        S_RD_DATA: begin
          if(next_state==S_IC_ADR)
            count <= 4'hF;
          else if(next_state==S_RD_DATA && count==0 && ((adr_reg[DATA_WIDTH-1:DATA_WIDTH-2]==2'b00 && ~FINISH_SPI_reg) || FINISH_SPI_reg) && in_cycle)
            count <= 1;
          else if(next_state==S_RD_DATA && (count!=0 && count<8) && in_cycle)
            count <= count + 1;
          else if(next_state==S_RD_DATA && count==8 && in_cycle)
            count <= 0;
          else
            count <= count;
        end
        
      endcase
  end
  
  // Repeated Start Register
  always@(posedge CLK) begin
    if(!RST_N)
      REPEATED_START <= 0;
    else
      if(~(state==S_IDLE) && start && SCL_DFF1 == 1 && SCL_DFF0==1)
        REPEATED_START <= 1;
      else if(state==S_IDLE)
        REPEATED_START <= 0;
      else
        REPEATED_START <= REPEATED_START;
  end
  
  // ShiftReg Control Signals
  always@(posedge CLK) begin
    if(!RST_N) begin
      EN_ShiftReg <= 0;  
      DIR <= 0; 
      LOAD <= 0; 
      RL_SEL <= 0; 
    end else begin
      case(state) 
        S_IDLE: begin                         
          DIR <= 0;
          LOAD <= 0;
          RL_SEL <= 0;
        end
        
        S_IC_ADR: begin
          // Pulsed (i.e. 1 clk)                       
          if(REPEATED_START && count==4'd8 && in_cycle)
            LOAD <= 1;
          else
            LOAD <= 0;
          
          // Hold for SCL high
          if(REPEATED_START && count==4'd8 && in_cycle) begin
            RL_SEL <= (adr_reg[DATA_WIDTH-1:DATA_WIDTH-2]==2'b00) ? 1 : 0;
            DIR <= 1;
          end else if(in_cycle) begin
            RL_SEL <= 0;
            DIR <= 0;
          end else begin
            RL_SEL <= RL_SEL;
            DIR <= DIR;
          end
          
          if((count < 7 || count==4'hF || count==4'd8) && in_cycle )
            EN_ShiftReg <= 1;
          else
            EN_ShiftReg <= 0;
        end
        
        S_RW_ADR: begin                       
          DIR <= 0;
          LOAD <= 0;
          RL_SEL <= 0;
          if((count < 7 || count==4'd8) && in_cycle)
            EN_ShiftReg <= 1;
          else
            EN_ShiftReg <= 0;
        end
        
        S_WR_DATA: begin                      
          DIR <= 0;
          LOAD <= 0;
          RL_SEL <= 0;
          if((count < 7 || count==4'd8) && in_cycle)
            EN_ShiftReg <= 1;
          else
            EN_ShiftReg <= 0;
        end
        
        S_RD_DATA: begin                      
          DIR <= 1;
          if(count==4'd8 && ((adr_reg[DATA_WIDTH-1:DATA_WIDTH-2]==2'b00 && ~FINISH_SPI) || FINISH_SPI) && in_cycle)
            LOAD <= 1;
          else
            LOAD <= 0;
            
          if((count < 7 || count==4'd8) && in_cycle)
            EN_ShiftReg <= 1;
          else
            EN_ShiftReg <= 0;

          RL_SEL <= (adr_reg[DATA_WIDTH-1:DATA_WIDTH-2]==2'b00) ? 1 : 0;

        end
        
        default: begin
        
        end
      
      endcase
    end
       
  end
  
  // DataReg Control Signals
  always@(posedge CLK) begin
    if(!RST_N) begin
        EN_DataReg <= 0;
    end else begin
      if(state==S_WR_DATA && count == 7 && in_cycle)
        EN_DataReg <= 1;
      else
        EN_DataReg <= 0;
    end
      
  end
  
  // AdrReg Control Signals
  always@(posedge CLK) begin
    if(!RST_N) begin
      EN_AdrReg <= 0;
      INCR <= 0;
    end else begin
      // Enable writing ADR during S_RW_ADR state
      if(state==S_RW_ADR && count == 7 && in_cycle) begin
        EN_AdrReg <= 1;
        INCR <= 0;
      // Increment ADR register after RS to ready for sequential reading
      end else if(state==S_IC_ADR && REPEATED_START && count == 8 && in_cycle) begin
        EN_AdrReg <= 1;
        INCR <= 1;
      // Increment as usual after last bit of WR/RD states
      end else if( (state==S_WR_DATA || state==S_RD_DATA) && in_cycle && count==8) begin
        EN_AdrReg <= 1;
        INCR <= 1;
      end else begin
        EN_AdrReg <= 0;
        INCR <= 0;
      end
    end     
  end
  
  // ACK bit
  always@(posedge CLK) begin
    if(!RST_N)
      ACK <= 0;
    else
      if(state==S_IC_ADR && count==7 && off_cycle && shift_reg[DATA_WIDTH-1:1]==I2CSLAVE_ADR)       
        ACK <= 1;
      else if( (state==S_RW_ADR || state==S_WR_DATA) && count==7 && off_cycle)
        ACK <= 1;
      else if(off_cycle)
        ACK <= 0;
      else
        ACK <= ACK;    
  end
  
  // SDA enable
  always@(posedge CLK) begin
    if(!RST_N)
      SDA_en <= 0;
    else 
      if(off_cycle)
        if( (state==S_IC_ADR && shift_reg[0]==1'b1 && shift_reg[DATA_WIDTH-1:1]==I2CSLAVE_ADR) && RW_FLAG && count == 8)
          SDA_en <= (adr_reg[DATA_WIDTH-1:DATA_WIDTH-2]==2'b00) ? ~RDATA_REG[DATA_WIDTH-1] : ~RDATA_SPI[DATA_WIDTH-1];
        else if(state==S_RD_DATA && RW_FLAG && count==8)
          if(SDA_in_DFF0==1'b0)
            SDA_en <= (adr_reg[DATA_WIDTH-1:DATA_WIDTH-2]==2'b00) ? ~RDATA_REG[DATA_WIDTH-1] : ~RDATA_SPI[DATA_WIDTH-1];
          else
            SDA_en <= 0;        
        else if(state==S_RD_DATA && count < 7)
          SDA_en <= ~shift_reg[DATA_WIDTH-2];
        else if(state==S_RD_DATA && count == 7)
          SDA_en <= 0;
        else
          SDA_en <= 0;
      else
        SDA_en <= SDA_en;  
  end
  
  // SDA output enable
  always@(*) begin
    SDA_out = (ACK || SDA_en);
  end
  
  // FINISH SPI
  always@(posedge CLK) begin
    if(!RST_N)  FINISH_SPI_reg <= 0;
    else if(FINISH_SPI || in_cycle)
      FINISH_SPI_reg <= FINISH_SPI;
    else
      FINISH_SPI_reg <= FINISH_SPI_reg;
  end
  
  // Control signals external to I2C slave
  always@(posedge CLK) begin
    if(!RST_N) begin
      REQ_REG<=0; 
      RW_FLAG<=0; 
      REQ_SPI<=0; 
    end else
      case(state)
        S_IDLE: begin                         
          REQ_REG <= 0;
          RW_FLAG <= 0;
          REQ_SPI <= 0;
        end
        
        S_IC_ADR: begin  
          if(count==4'hF && REPEATED_START && off_cycle) begin
            REQ_SPI <= (adr_reg[DATA_WIDTH-1:DATA_WIDTH-2]==2'b00) ? 0 : 1;
            REQ_REG <= (adr_reg[DATA_WIDTH-1:DATA_WIDTH-2]==2'b00) ? 1 : 0;
          end else begin
            REQ_SPI <= 0;
            REQ_REG <= 0;
          end
                 
          if(next_state==S_RW_ADR)
            RW_FLAG <= 0;
          else if(count==4'hF && REPEATED_START && off_cycle)
            RW_FLAG <= 1;                   // Preemptive read on RS
          else if(count == 4'd6 && in_cycle)
            RW_FLAG <= SDA_in_DFF1;         // the last bit of the first byte sent contains RW flag  
          else
            RW_FLAG <= RW_FLAG;
        end
        
        S_RW_ADR: begin                       
          RW_FLAG <= 0;
          REQ_REG <= 0;
          REQ_SPI <= 0;
        end
        
        S_WR_DATA: begin                      
          RW_FLAG <= 0;
          // REQ_SPI/REQ_REG is asserted after EN_DataReg
          if(EN_DataReg && count==8) begin
            REQ_SPI <= (adr_reg[DATA_WIDTH-1:DATA_WIDTH-2]==2'b00) ? 0 : 1;
            REQ_REG <= (adr_reg[DATA_WIDTH-1:DATA_WIDTH-2]==2'b00) ? 1 : 0;
          end else begin
            REQ_REG <= 0;
            REQ_SPI <= 0;
          end
        end
        
        S_RD_DATA: begin                      
          RW_FLAG <= 1;
          if(off_cycle && count==0) begin
            REQ_SPI <= (adr_reg[DATA_WIDTH-1:DATA_WIDTH-2]==2'b00) ? 0 : 1;
            REQ_REG <= (adr_reg[DATA_WIDTH-1:DATA_WIDTH-2]==2'b00) ? 1 : 0;
          end else begin
            REQ_REG <= 0;
            REQ_SPI <= 0;
          end
        end  
       endcase
  end
  
  // ERROR_SUSPEND signal is sent to SPI Master to stop transactions
  // when I2C stop condition is detected
  always@(posedge CLK) begin
    if(!RST_N)
      ERROR_SUSPEND <= 0;
    else
      if(stop)
        ERROR_SUSPEND <= 1;
      else
        ERROR_SUSPEND <= 0;
  end
  
  // =========================================
  //             SHIFT REGISTER
  // =========================================
  assign LR_IN = SDA_in;
  assign RL_IN = RL_SEL ? RDATA_REG : RDATA_SPI;
  assign LR_OUT = shift_reg;
  
  always@(posedge CLK) begin
    if(!RST_N) begin
                      shift_reg <= 0;
    end else begin
      if(EN_ShiftReg)
        case(DIR)
          1'b0: // Shift Data from Left to Right (SDA_in to Adr/Data Reg)
                      shift_reg <= {shift_reg[DATA_WIDTH-2:0],LR_IN};
          1'b1: // Shift Data from Right to Left (Regs to SDA_out)
            if(LOAD)  shift_reg <= RL_IN;
            else      shift_reg <= (shift_reg << 1);
        endcase
      else            shift_reg <= shift_reg;               
    end
  end
  
  // =========================================
  //             ADDRESS REGISTER
  // =========================================
  assign DATA_IN_AdrReg = LR_OUT;
  
  always@(posedge CLK) begin
    if(!RST_N)
                    adr_reg <= 0;
    else
      case(EN_AdrReg)
        1: begin
          if(INCR)  adr_reg <= adr_reg + 1;      // Increment Address for Sequential RD/WR
          else      adr_reg <= DATA_IN_AdrReg;   // Initialize to designated address
        end    
        0:          adr_reg <= adr_reg;          // No change if not enabled
      endcase
  end
  
  assign ADR = adr_reg[ADR_WIDTH-3:0];
  
  // =========================================
  //                DATA REGISTER
  // =========================================

  assign DATA_IN_DataReg = LR_OUT;
  
  always@(posedge CLK) begin
    if(!RST_N)
          data_reg <= 0;
    else
      case(EN_DataReg)
        1: data_reg <= DATA_IN_DataReg;
        0: data_reg <= data_reg;
      endcase
  end
  
  assign WDATA = data_reg;
  

endmodule
