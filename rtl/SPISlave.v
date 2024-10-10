/*
  SPI Slave Module
  (I2C SPI Bridge - Testbench)
  by John Rufino Macasaet
*/


module SPISlave #(
  parameter DATA_WIDTH     = 8,
  parameter COUNT_WIDTH    = $clog2(DATA_WIDTH),
  parameter SET_SPI_MODE   = 2'b00,   // Sets SPI Clock Polarity and Clock Phase
  parameter SPI_ADR_WIDTH  = 6,
  parameter MEM_DEPTH      = 2 ** SPI_ADR_WIDTH
)
(
  input CLK, RST_N,               // Internal clock and reset
  // SPI Signals
  input SCLK,                     // SPI CLK
  input MOSI,                     // Slave input
  input SS,                       // Slave select
  output MISO                     // Slave output
);
  // States
  localparam S_IDLE      = 2'd0;  // Idle state
  localparam S_READ_CMD  = 2'd1;  // Read command (Address + R/W bit)
  localparam S_READ      = 2'd2;  
  localparam S_WRITE     = 2'd3;
  
  // Control
  reg [1:0] next_state, state;
  reg [COUNT_WIDTH-1:0] count;
  reg RW_FLAG;
  
  // For over sampling SCLK and MOSI
  reg SCLK_DFF0, SCLK_DFF1;
  reg MOSI_DFF0;
  
  // Shift register
  reg [DATA_WIDTH-1:0] shift_reg;
  
  // SPI Data
  reg [SPI_ADR_WIDTH-1:0] ADR;
  wire [DATA_WIDTH-1:0] RDATA;  // Read data from MEM
  
  // SPI Config
  wire [1:0] SPI_MODE;
  wire CPOL, CPHA;
  wire SCLK_posedge, SCLK_negedge;
  
  // SPI Memory
  integer i;
  reg [DATA_WIDTH-1:0] SPI_MEM [0:MEM_DEPTH-1];
  
  //====== SPI Config =======
  assign SPI_MODE = SET_SPI_MODE;
  assign CPOL = SPI_MODE[1];
  assign CPHA = SPI_MODE[0];
  
  //====== Sampling SPI Signals =======
  
  // SCLK 
  always@(posedge CLK)
    if(!RST_N) begin
      SCLK_DFF0 <= 0;
      SCLK_DFF1 <= 0;
    end else begin
      SCLK_DFF0 <= SCLK;
      SCLK_DFF1 <= SCLK_DFF0;
    end
  
  // MOSI
  always@(posedge CLK)
    if(!RST_N) begin
      MOSI_DFF0 <= 0;
    end else begin
      MOSI_DFF0 <= MOSI;
    end
    
  assign SCLK_posedge = (~SCLK_DFF1 && SCLK_DFF0);
  assign SCLK_negedge = (SCLK_DFF1 && ~SCLK_DFF0);

      
  // ====== State Transition ======
  always@(posedge CLK) begin
    if(!RST_N)
      state <= S_IDLE;
    else
      state <= next_state;
  end
  
  always@(*) begin
    case(state)
      S_IDLE: begin
        if(SS==0)
          next_state <= S_READ_CMD;
        else
          next_state <= S_IDLE;
      end
      
      S_READ_CMD: begin
        if(count==7 && SCLK_posedge)
          next_state <= MOSI_DFF0 ? S_READ : S_WRITE;
        else
          next_state <= S_READ_CMD;
      end
      
      S_READ: begin
        if(count==7 && SCLK_posedge)
          next_state <= S_IDLE;
        else
          next_state <= S_READ;
      end
      
      S_WRITE: begin
        if(count==7 && SCLK_posedge)
          next_state <= S_IDLE;
        else
          next_state <= S_WRITE;
      end
    endcase
  end
  
  // ====== Counter =====
  always@(posedge CLK) begin
    if(!RST_N)
      count <= 0;
    else
      case(state)
        S_IDLE: begin
          count <= 0;
        end
        
        S_READ_CMD: begin
          if(next_state==S_READ_CMD && SCLK_posedge)
            count <= count + 1;
          else if( (next_state==S_READ||next_state==S_WRITE) && SCLK_posedge)
            count <= 0;
          else
            count <= count;
        end
        
        S_READ: begin
          if(next_state==S_READ && count < 7 && SCLK_posedge)
            count <= count + 1;
          else if(count==7 && SCLK_posedge)
            count <=0;
          else
            count <= count;
        end
        
        S_WRITE: begin
          if(next_state==S_WRITE && count < 7 && SCLK_posedge)
            count <= count + 1;
          else if(count==7 && SCLK_posedge)
            count <=0;
          else
            count <= count;
        end
      endcase
  end
  
  // ====== Shift Register ======
  always@(posedge CLK) begin
    if(!RST_N)
      shift_reg <= 0;
    else
      if(state==S_READ_CMD && next_state==S_READ)
        shift_reg <= RDATA;
      else if(( (state==S_READ_CMD && next_state==S_READ_CMD)||state==S_WRITE) && SCLK_posedge)
        shift_reg <= {shift_reg[DATA_WIDTH-2:0],MOSI_DFF0};
      else if(state==S_READ && next_state==S_READ && SCLK_posedge)
        shift_reg <= {shift_reg[DATA_WIDTH-2:0],1'b0};
      else
        shift_reg <= shift_reg;
  end
  
  // ====== RW FLAG ======
  always@(posedge CLK) begin
    if(!RST_N)
      RW_FLAG <= 0;
    else
      if(state==S_IDLE)
        RW_FLAG <= 0;
      else if(state==S_READ_CMD && count==7 && SCLK_negedge)
        RW_FLAG <= MOSI_DFF0;
      else
        RW_FLAG <= RW_FLAG;
  end
  
  // ====== MISO ======
  assign MISO = RW_FLAG ? shift_reg[DATA_WIDTH-1] : 1'bz;
  
  // ======= ADR Register ======
  always@(posedge CLK) begin
    if(!RST_N)
      ADR <= 0;
    else
      if(state==S_IDLE)
        ADR <= 0;
      else if(state==S_READ_CMD && count==7 && SCLK_negedge)
        ADR <= shift_reg[DATA_WIDTH-3:0];
      else
        ADR <= ADR;
  end
  
  // ======= SPI Memory Initialize ======
  // Reading from memory
  assign RDATA = SPI_MEM[ADR];
  
  // Writing to memory
  always@(posedge CLK) begin
    if(!RST_N)
      //for(i=0; i<(MEM_DEPTH); i++) 
      //  SPI_MEM[i] <= 0;
      $readmemh("SPI_MEM.mem",SPI_MEM);
    else if(state==S_WRITE && count==7 && SCLK_negedge)
      SPI_MEM[ADR] <= {shift_reg[DATA_WIDTH-2:0],MOSI_DFF0};
    else
      SPI_MEM[ADR] <= SPI_MEM[ADR]; 
  end
  
  // Initialize memory
  initial begin
    #200;
      $readmemh("SPI_MEM.mem",SPI_MEM);
  end

endmodule