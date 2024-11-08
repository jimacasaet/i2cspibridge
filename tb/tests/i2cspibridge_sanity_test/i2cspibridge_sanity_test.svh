//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2cspibridge_sanity_test.svh
// Description  :   I2C-SPI Bridge Sanity Test
//-------------------------------------------------------------
`ifndef _I2CSPIBRIDGE_SANITY_TEST_SVH
  `define _I2CSPIBRIDGE_SANITY_TEST_SVH

class i2cspibridge_sanity_test extends i2cspibridge_base_test;

  // Instantiate Test Sequence
  rand i2cspibridge_sanity_test_seq sanity_test_seq;

  `uvm_component_utils_begin(i2cspibridge_sanity_test)
    `uvm_field_object(sanity_test_seq, UVM_ALL_ON)
  `uvm_component_utils_end

  /******************************************************************************
  *   FUNCTION: Constructor
  ******************************************************************************/
  function new(string name="i2cspibridge_sanity_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  /******************************************************************************
  *   FUNCTION: Build Phase
  ******************************************************************************/
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

  /******************************************************************************
  *   TASK: Main Phase
  ******************************************************************************/
  virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);
    // Create the test seq
    sanity_test_seq = i2cspibridge_sanity_test_seq::type_id::create("sanity_test_seq", this);

    // Pass the configuration object to test seq
    sanity_test_seq.m_cfg = m_cfg;

    // Start test and raise objection
    `uvm_info("Sanity Test", "Starting Test...", UVM_LOW)
    phase.raise_objection(this);
      // Randomize the test sequence
      assert(sanity_test_seq.randomize())
      else
        `uvm_error("Sanity Test", "Failed to randomize sequence")
      // Start Test Seq
      sanity_test_seq.start(t_env.m_vseqr);
    phase.drop_objection(this);
  endtask : main_phase


endclass : i2cspibridge_sanity_test
`endif // _I2CSPIBRIDGE_SANITY_TEST_SVH
