

module I2CSPIBridge(
  input CLK,
  input RST_N,
  // I2C
  input SCL,
  inout SDA,
  // SPI
  input MISO,
  output SCLK,
  output MOSI,
  output SS0, SS1, SS2
);
  parameter DATA_WIDTH = 8;
  parameter ADR_WIDTH = 6;

  wire REQ_REG, REQ_SPI, FINISH_SPI, ERROR_SUSPEND, RW_FLAG;
  wire SPI_CLK;
  wire [1:0] SPI_MODE;
  wire SPI_ADR0, SPI_ADR1, SPI_ADR2;
  wire [DATA_WIDTH-1:0] WDATA, RDATA_SPI, RDATA_REG;
  wire [ADR_WIDTH-1:0] ADR;
  wire SDA_out;
  
  assign (pull0, highz1) SDA = SDA_out ? 1'b0 : 1'bz;  // SDA output pulls the line to LOW/0

  I2CSLAVE I2CSLAVE_DUT(
    .CLK(CLK), .RST_N(RST_N),                                            
    .SCL(SCL), .SDA_in(SDA), .SDA_out(SDA_out),                              
    .FINISH_SPI(FINISH_SPI),
    .RDATA_REG(RDATA_REG), .RDATA_SPI(RDATA_SPI),
    .REQ_REG(REQ_REG), .RW_FLAG(RW_FLAG), .REQ_SPI(REQ_SPI), .ERROR_SUSPEND(ERROR_SUSPEND),
    .WDATA(WDATA), .ADR(ADR)
  );
  
  RegMap RegMap_DUT(
    .CLK(CLK), .RST_N(RST_N),
    .REQ_REG(REQ_REG), .RW_FLAG(RW_FLAG),
    .ADR(ADR), .WDATA(WDATA), .RDATA_REG(RDATA_REG),
    .SPI_CLK(SPI_CLK), .SPI_MODE(SPI_MODE), .SPI_ADR0(SPI_ADR0), .SPI_ADR1(SPI_ADR1), .SPI_ADR2(SPI_ADR2)
  );
  
  SPIMaster SPIMaster_DUT(
    .CLK(CLK), .RST_N(RST_N),
    .ADR(ADR), .WDATA(WDATA), .REQ_SPI(REQ_SPI), .RW_FLAG(RW_FLAG), .ERROR_SUSPEND(ERROR_SUSPEND),
    .RDATA_SPI(RDATA_SPI), .FINISH_SPI(FINISH_SPI),
    .SPI_CLK(SPI_CLK), .SPI_MODE(SPI_MODE), .SPI_ADR0(SPI_ADR0), .SPI_ADR1(SPI_ADR1), .SPI_ADR2(SPI_ADR2),
    .MISO(MISO), .SCLK(SCLK), .MOSI(MOSI), .SS0(SS0), .SS1(SS1), .SS2(SS2)
  );
  
endmodule