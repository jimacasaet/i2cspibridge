//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2cspibridge_spi_wr_test_seq.svh
// Description  :   I2C-SPI Bridge SPI Write Test Sequence
//-------------------------------------------------------------
`ifndef _I2CSPIBRIDGE_SPI_WR_TEST_SEQ_SVH
  `define _I2CSPIBRIDGE_SPI_WR_TEST_SEQ_SVH

class i2cspibridge_spi_wr_test_seq extends i2cspibridge_base_seq;

  // Register with the factory
  `uvm_object_param_utils_begin(i2cspibridge_spi_wr_test_seq)
  `uvm_object_utils_end

  randc logic [I2C_BYTE_SIZE-1:0] i2c_write_data;
  rand logic  [1:0]               spi_slave;
  rand int                        iter;

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="i2cspibridge_spi_wr_test_seq");
    super.new(name);
    `uvm_info("I2CSPIBridge SPI Write Test Seq","Constructor Done", UVM_HIGH)
  endfunction : new

  /************************************************************
  *   TASK: Body
  *************************************************************/
  task body();
    super.body();

    // Send start bit
    send_i2c_start(1'b0);
    // Set write address to 8'h00
    send_i2c_data(8'h00);
    // Write to 0x00
    send_i2c_data(8'h00);
    // Write to 0x01
    send_i2c_data(8'h00);
    // Write to 0x02
    send_i2c_data(8'h00);
    // Send stop condition
    send_i2c_stop();

    // Send start bit
    send_i2c_start(1'b0);
    // Set write address to 8'h50
    send_i2c_data(8'h00);
    // Send randomized data
    repeat(25) begin
      assert(randomize(i2c_write_data));
      `uvm_info("I2CSPIBridge SPI Write Test Seq", $sformatf("Writing I2C Data = %2h", i2c_write_data), UVM_LOW)
      send_i2c_data(i2c_write_data);
    end

    `uvm_info("I2CSPIBridge SPI Write Test Seq","Body Done", UVM_HIGH)
  endtask : body

  
  
endclass : i2cspibridge_spi_wr_test_seq

`endif // _I2CSPIBRIDGE_SPI_WR_TEST_SEQ_SVH