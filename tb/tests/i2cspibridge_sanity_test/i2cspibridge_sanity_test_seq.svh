//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2cspibridge_sanity_test_seq.svh
// Description  :   I2C-SPI Bridge Sanity Test Sequence
//-------------------------------------------------------------
`ifndef _I2CSPIBRIDGE_SANITY_TEST_SEQ_SVH
  `define _I2CSPIBRIDGE_SANITY_TEST_SEQ_SVH

class i2cspibridge_sanity_test_seq extends i2cspibridge_base_seq;

  // Register with the factory
  `uvm_object_param_utils_begin(i2cspibridge_sanity_test_seq)
  `uvm_object_utils_end

  // bit [2047:0]  data;
  // bit [7   :0]  len ;
  // bit [63  :0]  mode;
  randc logic [I2C_BYTE_SIZE-1:0] i2c_write_data;

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="i2cspibridge_sanity_test_seq");
    super.new(name);
    `uvm_info("I2CSPIBridge Sanity Test Seq","Constructor Done", UVM_HIGH)
  endfunction : new

  /************************************************************
  *   TASK: Body
  *************************************************************/
  task body();
    super.body();

    /* Set SPI Configuration Registers */
    // Send start bit
    send_i2c_start(1'b0);
    // Set write address to 8'h00
    send_i2c_data(8'h00);
    // Write to 0x00
    send_i2c_data(8'h00);
    // Write to 0x01
    send_i2c_data(8'h00);
    // Write to 0x02
    send_i2c_data(8'h40);
    // Send stop condition
    send_i2c_stop();

    /* Write to SPI Mem */
    // Send start bit with write
    send_i2c_start(1'b0);
    // Set write address to 8'h50
    send_i2c_data(8'h50);
    // Send randomized data
    repeat(25) begin
      assert(randomize(i2c_write_data));
      `uvm_info("I2CSPIBridge Sanity Test Seq", $sformatf("Writing I2C Data = %2h", i2c_write_data), UVM_LOW)
      send_i2c_data(i2c_write_data);
    end
    send_i2c_stop();

    /* Set write address to 0x50*/
    // Send start bit with write
    send_i2c_start(1'b0);
    // Set write address to 8'h50
    send_i2c_data(8'h50);
    /* Repeated start */
    send_i2c_repeated_start(1'b1); // FIXME: Replace delay with proper repeated start function
    repeat(3)
      read_i2c_data(1'b1);
    send_i2c_stop();

    // TODO: DPI
    // mode = 64'h11_13011112;
    // c_py_init();
    // c_py_gen_packet(mode,data,len);
    
    // $display("print data in systemverilog !");
    
    // $display("get len  ='h%h",len );
    // $display("get data ='h%0h",data);
    // $display("get data = %s",data);
    
    // c_py_final();
    `uvm_info("I2CSPIBridge Sanity Test Seq","Body Done", UVM_HIGH)
  endtask : body

  
  
endclass : i2cspibridge_sanity_test_seq

`endif // _I2CSPIBRIDGE_SANITY_TEST_SEQ_SVH