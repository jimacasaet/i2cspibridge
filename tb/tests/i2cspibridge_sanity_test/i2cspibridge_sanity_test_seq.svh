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

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="i2cspibridge_sanity_test_seq");
    super.new(name);
    `uvm_info("I2CSPIBridge Sanity Test","Constructor Done", UVM_HIGH)
  endfunction : new

  /************************************************************
  *   TASK: Body
  *************************************************************/
  task body();
    super.body();
    #(T_SCL*10);
    `uvm_info("I2CSPIBridge Sanity Test","Body Done", UVM_HIGH)
  endtask : body
  
endclass : i2cspibridge_sanity_test_seq

`endif // _I2CSPIBRIDGE_SANITY_TEST_SEQ_SVH