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
  
  // Instantiate the sequences
  i2cspibridge_config_seq             config_seq;
  i2cspibridge_write_data_seq         write_data_seq;
  i2cspibridge_read_data_seq          read_data_seq;

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="i2cspibridge_sanity_test_seq");
    super.new(name);
    `uvm_info("Sanity Test Seq","Constructor Done", UVM_HIGH)
  endfunction : new

  /************************************************************
  *   TASK: Body
  *************************************************************/
  task body();
    config_seq      = i2cspibridge_config_seq::type_id::create("config_seq");
    write_data_seq  = i2cspibridge_write_data_seq::type_id::create("write_data_seq");
    read_data_seq   = i2cspibridge_read_data_seq::type_id::create("read_data_seq");

    super.body();

    /* Set Configuration Registers to write to SS0*/
    config_seq.dest     = 2'b01;
    config_seq.spi_clk  = 1'b1;
    config_seq.spi_cfg  = 2'b00;
    config_seq.start(p_sequencer);

    /* Write to SPI Mem */
    write_data_seq.addr       = 8'h50;
    write_data_seq.write_iter = 3;
    write_data_seq.start(p_sequencer);

    /* Set write address to 0x50*/
    read_data_seq.addr        = 8'h50;
    read_data_seq.read_iter   = 3;
    read_data_seq.start(p_sequencer);

    // TODO: DPI
    // mode = 64'h11_13011112;
    // c_py_init();
    // c_py_gen_packet(mode,data,len);
    
    // $display("print data in systemverilog !");
    
    // $display("get len  ='h%h",len );
    // $display("get data ='h%0h",data);
    // $display("get data = %s",data);
    
    // c_py_final();
    `uvm_info("Sanity Test Seq","Body Done", UVM_HIGH)
  endtask : body

  
  
endclass : i2cspibridge_sanity_test_seq

`endif // _I2CSPIBRIDGE_SANITY_TEST_SEQ_SVH