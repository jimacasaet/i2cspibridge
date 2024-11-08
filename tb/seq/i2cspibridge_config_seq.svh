`ifndef _I2CSPIBRIDGE_CONFIG_SEQ  
  `define _I2CSPIBRIDGE_CONFIG_SEQ  

class i2cspibridge_config_seq extends i2cspibridge_base_seq;
  `uvm_object_param_utils(i2cspibridge_config_seq)

  localparam DEST_REGMAP = 0;
  localparam DEST_SS0    = 1;
  localparam DEST_SS1    = 2;
  localparam DEST_SS2    = 3;

  localparam ADR_SS0     = 'h40;
  localparam ADR_SS1     = 'h80;
  localparam ADR_SS2     = 'hC0;

  // Configuration variables 
  
  /****** Destination*********
  *   dest = 'b00: RegMap
  *   dest = 'b01: SPI S0
  *   dest = 'b10: SPI S1
  *   dest = 'b11: SPI S2
  ****************************/
  logic [1:0]     dest;

  /******** SPI Config ********
  *   spi_clk = 'b1:  1.25MHz
  *   spi_clk = 'b0:  2.5MHz
  ****************************/
  logic           spi_clk;
  
  /******** SPI Config ********
  *   spi_cfg[1]: CPOL
  *   spi_cfg[0]: CPHA
  ****************************/
  logic [1:0]     spi_cfg;

  /********* Allow Multiple SS **************
  * Setting for allowing selection of
  * multiple SPI peripherals.
  *
  *   multiple_ss = 'b1: Allow multiple SS
  *   multiple_ss = 'b0: Allow one SS only (default)
  */
  logic           multiple_ss;

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="i2cspibridge_config_seq");
    super.new(name);
    dest    = 0;
    spi_cfg = 0;
    multiple_ss = 0;
  endfunction : new

  /************************************************************
  *   TASK: Body
  *************************************************************/
  task body();
    super.body();
    
    // Step 1: Send I2C Start bit with write command
    send_i2c_start(1'b0);
    // Step 2: Set the write address to 8'h00
    send_i2c_data(8'h00);
    // Step 3: Set SPI Clock Setting at RegMap=0x00
    send_i2c_data({ {(I2C_BYTE_SIZE-1){1'b0}}, spi_clk });
    // Step 4: Set SPI Config Setting at RegMap=0x01
    send_i2c_data({ {(I2C_BYTE_SIZE-2){1'b0}}, spi_cfg });
    // Step 5: Set UADR Config Registers for the Destination
    if(dest==DEST_REGMAP) begin
      // If destination is RegMap, end configuration
      send_i2c_stop();
    end else if(dest==DEST_SS0) begin
      // If destination is SS0, write to RegMap=0x02 with value ADR_SS0
      `uvm_info("I2CSPIBridge Config Seq", "Configured to write to ADR_SS0", UVM_HIGH)
      send_i2c_data(ADR_SS0);
      // If multiple peripherals not allowed, clear uadr for SS1 and SS2
      if(!multiple_ss) begin
        repeat(2) send_i2c_data(8'h00);
      end
    end else if(dest==DEST_SS1||dest==DEST_SS2) begin
      // If destination is SS1 or SS2, send stop and reissue write command
      // to the appropriate address with the correct uadr value
      `uvm_info("I2CSPIBridge Config Seq", $sformatf("Configured to write to %s", (dest==DEST_SS1 ? "DEST_SS1" : "DEST_SS2") ), UVM_HIGH)

      if(multiple_ss) begin
        send_i2c_stop();
        send_i2c_start(1'b0);
        send_i2c_data( (dest==DEST_SS1 ? 8'h03 : 8'h04) );
        send_i2c_data( (dest==DEST_SS1 ? 8'h80 : 8'hC0) );
        send_i2c_stop();
      end else begin
        send_i2c_data(  8'h00                           );  // UADR0
        send_i2c_data( (dest==DEST_SS1 ? 8'h80 : 8'h00) );  // UADR1
        send_i2c_data( (dest==DEST_SS2 ? 8'hC0 : 8'h00) );  // UADR2
      end
    end else begin
      `uvm_error("I2CSPIBridge Config Seq", "Invalid destination!")
    end
  endtask : body

endclass : i2cspibridge_config_seq

`endif // _I2CSPIBRIDGE_CONFIG_SEQ  