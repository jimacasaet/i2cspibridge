
/*
  SPI Master Block
  (as part of I2C SPI Bridge)
  by John Rufino Macasaet
  
  Note: SPI Master can only transfer or receive data at a time (i.e. cannot TX and RX at the same time)
  
  Command Byte Format:
  -------------------------------------
  | Bit 7  | Bit 6 to Bit 1 |  Bit 0  |
  -------------------------------------
  | Unused | ADR (6 bits)   | RW flag |
  -------------------------------------
  
*/

module SPIMaster#(
  parameter DATA_WIDTH = 8,
  parameter ADR_WIDTH = 6                                 // RW Address
  )(
  // Clock and reset
  input CLK,                                              // I2C slave internal clock (operating at 5MHz)
  input RST_N,                                            // Synchronous reset
  // Signals from I2C Slave
  input [ADR_WIDTH-1:0] ADR,                              
  input [DATA_WIDTH-1:0] WDATA,                           
  input REQ_SPI, RW_FLAG,                                     
  input ERROR_SUSPEND,
  output reg[DATA_WIDTH-1:0] RDATA_SPI,                   // receive (from miso) register to i2c slave
  output reg FINISH_SPI,
  // Signals from RegMap
  input SPI_CLK,                                          // Controls SCLK frequency
  input [1:0] SPI_MODE,                                   // CPOL and CPHA 
  input SPI_ADR0, SPI_ADR1, SPI_ADR2,                     // Slave select
  // Signals from/to SPI Slaves
  input MISO,                                             // Master Input Slave Output
  output reg SCLK,                                        // SPI CLK
  output reg MOSI,                                        // Master Output Slave Input
  output reg SS0, SS1, SS2                                // Slave select
);
 
  // Define FSM reg and states  
  localparam S_IDLE    = 3'd0,
             S_TX_CMD  = 3'd1,
             S_TX_DATA = 3'd2,
             S_RX_DATA = 3'd3;
             
  reg [1:0] state, next_state;                            // FSM State
  reg RW_FLAG_reg;                                        // Reg for RW FLAG
  reg [DATA_WIDTH-1:0] TX_reg;                            // transmit register
  reg [DATA_WIDTH-1:0] WDATA_reg;                         // Store WDATA
  reg [$clog2(DATA_WIDTH)-1:0] TX_count, RX_count;        // Bit count for transmit/receive
  reg [1:0] SPI_CLK_Counter;                              // Counter
  reg REQ_SPI_reg;                                        // REQ_SPI Delay 1 clock cycle
  reg SS_en;                                              // Slave select enable
  wire [2:0] DIV;                                         // For assigning divider value
  wire CPOL, CPHA;                                        // For assigning SPI operating modes
  reg Leading_Edge, Trailing_Edge;                       // For determining leading and trailing edge of clock
  
  // ========================== SPI Clock-Related ==========================
  //
  // SPI_MODE = {CPOL, CPHA}
  //
  //---------------------------- Clock Polarity ----------------------------
  // CPOL = 0 : Clock idle state is 0. Leading edge is rising edge.
  // CPOL = 1 : Clock idle state is 1. Leading edge is falling edge.
  //
  //----------------------------   Clock Phase  ----------------------------
  // CPHA = 0 : Samples data on leading edge of the clock; changes data on trailing edge of the clock.
  // CPHA = 1 : Samples data oñ the trailing edge of the clock; changes data on leading edge of the clock.
  //
  assign CPOL = SPI_MODE[1];    // bit 1 of SPI_MODE
  assign CPHA = SPI_MODE[0];    // bit 0 

  // ========================= Clock Divider for SCLK =========================
  // SPI_CLK = 1, divide by 4     
  // SPI_CLK = 0, divide by 2
  assign DIV = SPI_CLK ? 3'd4 : 3'd2;
  
  // ========================= Slave Select Assignment =========================
  // Note: Slave is selected when slave select SS = 0
  //       When not selected, drive high-z.
  //       Determined by contents of config register.
  assign SS0 = (SPI_ADR0 && SS_en) ? 1'b0 : 1'bz;
  assign SS1 = (SPI_ADR1 && SS_en) ? 1'b0 : 1'bz;
  assign SS2 = (SPI_ADR2 && SS_en) ? 1'b0 : 1'bz;

  
  /*always@(posedge CLK) begin
    if(!RST_N)  
      CLK_Counter <= 0;
    else if(CLK_Counter == DIV-1)
      CLK_Counter <= 0;
    else 
      CLK_Counter <= CLK_Counter + 1;
  end*/
  
  // ========================== State Machine ==========================
  always@(*) begin
    if(!RST_N)
      next_state = S_IDLE;
    else
      case(state)
        S_IDLE: begin
          if(REQ_SPI_reg)
            next_state = S_TX_CMD;
          else
            next_state = S_IDLE;
        end
        
        S_TX_CMD: begin
          if(ERROR_SUSPEND)
            next_state = S_IDLE;
          else if(TX_count>0 && SPI_CLK_Counter<DIV)
            next_state = S_TX_CMD;
          else if(TX_count==0 && (SPI_CLK_Counter==(DIV-1)))
            next_state = RW_FLAG_reg ? S_RX_DATA : S_TX_DATA;
          else
            next_state = S_TX_CMD; 
        end
        
        S_TX_DATA: begin
          if(ERROR_SUSPEND)
            next_state = S_IDLE;
          else if(TX_count>0 && SPI_CLK_Counter<DIV)
            next_state = S_TX_DATA;
          else if(TX_count==0 && (SPI_CLK_Counter==(DIV-1)))
            next_state = S_IDLE;
          else
            next_state = S_TX_DATA;           
        end
        
        S_RX_DATA: begin
          if(ERROR_SUSPEND)
            next_state = S_IDLE;
          else if(RX_count>0 && SPI_CLK_Counter<DIV)
            next_state = S_RX_DATA;
          else if(RX_count==0 && (SPI_CLK_Counter==(DIV-1)))
         // else if(RX_count==0 && ((Leading_Edge && ~CPHA) || (Trailing_Edge && CPHA)))
            next_state = S_IDLE;
          else
            next_state = S_RX_DATA;
        end

      endcase
  end
  
  always@(posedge CLK)
    if(!RST_N)
      state <= S_IDLE;
    else
      state <= next_state;
  
  // ================ Finish SPI ==============
  always@(posedge CLK) begin
    if(!RST_N)
        FINISH_SPI <= 0;
    else
      if(state==S_RX_DATA && ((Leading_Edge & ~CPHA) || (Trailing_Edge & CPHA)) && RX_count==0)
        FINISH_SPI <= 1;
      else if(state==S_IDLE && REQ_SPI)
        FINISH_SPI <= 0;
      else
        FINISH_SPI <= FINISH_SPI;
  end
  
  // ================ REQ SPI Reg ==============
  always@(posedge CLK)
    if(!RST_N)
      REQ_SPI_reg <= 0;
    else
      REQ_SPI_reg <= REQ_SPI;
      
  // ================ WDATA and ADR Reg ==============
  always@(posedge CLK)
    if(!RST_N) begin
      WDATA_reg <= 0;
    end else
      if( (state==S_IDLE) && REQ_SPI_reg ) begin
        WDATA_reg <= WDATA;
      end else begin
        WDATA_reg <= WDATA_reg;
      end
  
  // ================ RW Flag Reg ==============
  always@(posedge CLK)
    if(!RST_N)
      RW_FLAG_reg <= 0;
    else
      if( (state==S_IDLE) && REQ_SPI )
        RW_FLAG_reg <= RW_FLAG;
      else
        RW_FLAG_reg <= RW_FLAG_reg;
        
  // ================ Slave Select Enable ==============
  always@(posedge CLK) begin
    if(!RST_N)
      SS_en <= 0;
    else
      case(state)
        S_IDLE: begin
          if(next_state==S_TX_CMD)
            SS_en <= 1;
          else
            SS_en <= 0;
        end
        
        S_TX_CMD: begin
          if(ERROR_SUSPEND)
            SS_en <= 0;
          else
            SS_en <= 1;
        end
        
        S_TX_DATA: begin
          if(ERROR_SUSPEND)
            SS_en <= 0;
          else if(next_state==S_TX_DATA)
            SS_en <= 1;
          else
            SS_en <= 0;  
        end
        
        S_RX_DATA: begin
          if(ERROR_SUSPEND)
            SS_en <= 0;
          else if(next_state==S_RX_DATA)
            SS_en <= 1;
          else 
            SS_en <= 0;  
        end
        
      endcase
  end
  
  // ================ Setting Data to Transmit Reg ==============
  always@(posedge CLK) begin
    if(!RST_N)
      TX_reg <= 0;
    else
      if((state==S_IDLE) && REQ_SPI)
        TX_reg <= {1'b0, ADR, RW_FLAG};               // Command Byte
      else if(next_state==S_TX_DATA && TX_count == 0)
        TX_reg <= WDATA_reg;
      else
        TX_reg <= TX_reg;
  end
  
  // ==================== SPI Clock Gen =====================
  
  // SCLK
  always@(posedge CLK) begin
    if(!RST_N)
        SCLK <= 0;      // autocheck throws stuck-at warning if reset to CPOL value, so set to 0                                      
    else
      if(state==S_IDLE)
        SCLK <= CPOL;
      else if(next_state==S_TX_CMD || next_state==S_RX_DATA || next_state==S_TX_DATA)
        if((SPI_CLK_Counter+1) == DIV)
          SCLK <= CPHA ? ~CPOL : CPOL;
        else if((SPI_CLK_Counter+1) < (DIV/2))begin
          SCLK <= CPHA ? ~CPOL : CPOL;
          //$display("debug");
        end else
          SCLK <= CPHA ? CPOL : ~CPOL;
      else
        SCLK <= CPOL;   

  end
  
  // SPI Clock Counter
  always@(posedge CLK) begin
    if(!RST_N)
      SPI_CLK_Counter <= 0;
    else
      if(state==S_TX_CMD)
        if(SPI_CLK_Counter == DIV - 1)
          SPI_CLK_Counter <= 0;
        else
          SPI_CLK_Counter <= SPI_CLK_Counter + 1'b1;
      else if(state==S_RX_DATA || state==S_TX_DATA)
        if(SPI_CLK_Counter == DIV - 1)
          SPI_CLK_Counter <= 0;
        else
          SPI_CLK_Counter <= SPI_CLK_Counter + 1'b1;
      else // state == S_IDLE
        SPI_CLK_Counter <= 0;
  end
  
  // Leading and trailing edge of clock
  // Used for CPHA/CPOL-related timing
  always@(posedge CLK) begin
    if(!RST_N) begin
      Leading_Edge <= 0;
      Trailing_Edge <= 0;
    end else begin
      // Default values
      Leading_Edge <= 0;
      Trailing_Edge <= 0;
      
      if((SPI_CLK_Counter+1) == (DIV>>1) )
        if(CPHA==0)
          Leading_Edge <= 1;
        else
          Trailing_Edge <= 1;
      else if(SPI_CLK_Counter == DIV-1 )
        if(CPHA==0)
          Trailing_Edge <= 1;
        else
          Leading_Edge <= 1;
    end
  end
  
  // =================== MOSI Data =====================
  // Send data to slave through MOSI
  
  always@(posedge CLK) begin
    if(!RST_N)
      MOSI <= 1'b0;
    else
      case(state)
        S_IDLE: begin
          if(next_state==S_TX_CMD)
            MOSI <= 0;              // Set to 0 (Bit 7 of CMD is unused)
          else
            MOSI <= MOSI;
        end
        
        S_TX_CMD: begin
          if(next_state==S_TX_DATA)
            MOSI <= WDATA_reg[3'd7];
          else if(next_state==S_TX_CMD && (SPI_CLK_Counter+1)==DIV)
            MOSI <= TX_reg[TX_count-1];
          else if(next_state==S_RX_DATA)
            MOSI <= 0;
          else
            MOSI <= MOSI;
        end
        
        S_TX_DATA: begin
          if(next_state==S_TX_DATA && (SPI_CLK_Counter+1)==DIV)
            MOSI <= TX_reg[TX_count-1];
          else
            MOSI <= MOSI;
        end
        
        S_RX_DATA:
            MOSI <= 0;

      endcase
      
  end
  
  // MOSI TX Counter
  always@(posedge CLK) begin
    if(!RST_N)
      TX_count <= 3'd7;                  // Send MSB first
    else
      if( (state==S_IDLE) && next_state==S_TX_CMD)
        TX_count <= 3'd7;
      else if(next_state==S_TX_CMD && (SPI_CLK_Counter+1)==DIV)
        TX_count <= TX_count - 1'b1;   
      else if (state==S_TX_CMD && next_state==S_TX_DATA)
        TX_count <= 3'd7;
      else if(next_state==S_TX_DATA && (SPI_CLK_Counter+1)==DIV)
        TX_count <= TX_count - 1'b1;         
  end
  
  // =================== MISO Data =====================
  // Receiving data from slave through MISO
  
  always@(posedge CLK) begin
    if(!RST_N)
      RDATA_SPI <= 0;
    else
      if(state==S_RX_DATA && ((Leading_Edge && ~CPHA) || (Trailing_Edge && CPHA)))
        RDATA_SPI <= {RDATA_SPI[DATA_WIDTH-2:0],MISO};
      else
        RDATA_SPI <= RDATA_SPI;
  end
  
  // MISO RX Counter
  always@(posedge CLK) begin
    if(!RST_N)
      RX_count <= 3'd7;                
    else
      if(state==S_IDLE)
        RX_count <= 3'd7;
      else if(state==S_RX_DATA && (SPI_CLK_Counter+1)==DIV)
        RX_count <= RX_count - 1'b1;      
        
  end
  
endmodule
