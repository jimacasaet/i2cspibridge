
/*
  Register Map Block
  (I2C SPI Bridge)
  by John Rufino Macasaet
*/

module RegMap#(
  parameter DATA_WIDTH = 8,
  parameter ADR_WIDTH  = 6,
  parameter MEM_DEPTH  = 2 ** ADR_WIDTH
  )(
  input CLK, RST_N,                                               // Clocks and Resets
  input REQ_REG,                                                  // RegMap Enable
  input RW_FLAG,                                                  // READ=1, WRITE=0
  input [ADR_WIDTH-1:0] ADR,                                      // Address
  input [DATA_WIDTH-1:0] WDATA,                                   // Write Input Data
  output [1:0] SPI_MODE,                                          // Set SPI Mode
  output SPI_ADR0, SPI_ADR1, SPI_ADR2,                            // SPI Slave Select Signals
  output SPI_CLK,
  output reg [DATA_WIDTH-1:0] RDATA_REG                           // Read Output Data
);

  integer i;                                                      // For indexing memory
  reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];                       // RegMap Memory
  reg [DATA_WIDTH-1:0] SPI_CLK_reg, SPI_MODE_reg, SPI_ADR0_reg, SPI_ADR1_reg, SPI_ADR2_reg;
  
  /*  
              REGMAP
      -----------|-------|
      |   Name   | Addr  |
      |----------|-------|
      |SPI_CLK   | 0x00  |
      |----------|-------|
      |SPI_CFG   | 0x01  |
      |----------|-------|
      |UADDR_SS0 | 0x02  |
      |----------|-------|
      |UADDR_SS1 | 0x03  |
      |----------|-------|
      |UADDR_SS2 | 0x04  |
      |----------|-------|
  */

  // Writing to Memory
  always@(posedge CLK) begin
    if(!RST_N)  
      for(i=0; i<(MEM_DEPTH); i++) 
        mem[i] <= 0;
    else
      if(REQ_REG && RW_FLAG==0)
        mem[ADR] <= WDATA;
      else
        mem[ADR] <= mem[ADR];
  end
  
  // RDATA_REG
  always@(posedge CLK) begin
    if(!RST_N)
        RDATA_REG <= 0;
    else
      if(REQ_REG && RW_FLAG==1)
        RDATA_REG <= mem[ADR];
      else
        RDATA_REG <= RDATA_REG;
  end
  
  // Assigning SPI Signals
  always@(*) begin
    SPI_CLK_reg = mem[6'h00];
    SPI_MODE_reg = mem[6'h01];
    SPI_ADR0_reg = mem[6'h02];
    SPI_ADR1_reg = mem[6'h03];
    SPI_ADR2_reg = mem[6'h04];
  end
  
  assign SPI_CLK = SPI_CLK_reg[0];
  assign SPI_MODE = SPI_MODE_reg[1:0];
  assign SPI_ADR0 = (SPI_ADR0_reg[DATA_WIDTH-1:DATA_WIDTH-2] == 2'b01) ? 1 : 0;
  assign SPI_ADR1 = (SPI_ADR1_reg[DATA_WIDTH-1:DATA_WIDTH-2] == 2'b10) ? 1 : 0;
  assign SPI_ADR2 = (SPI_ADR2_reg[DATA_WIDTH-1:DATA_WIDTH-2] == 2'b11) ? 1 : 0;
endmodule