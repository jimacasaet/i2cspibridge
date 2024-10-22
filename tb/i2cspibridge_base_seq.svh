//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2cspibridge_base_seq.svh
// Description  :   I2C-SPI Bridge Base Sequence
//-------------------------------------------------------------
`ifndef _I2CSPIBRIDGE_BASE_SEQ_SVH
  `define _I2CSPIBRIDGE_BASE_SEQ_SVH

class i2cspibridge_base_seq extends uvm_sequence;
  // Declare the P Sequencer
  `uvm_declare_p_sequencer(i2cspibridge_virtual_sequencer)
  // Register with the factory
  `uvm_object_param_utils_begin(i2cspibridge_base_seq)
    `uvm_field_object(m_cfg, UVM_ALL_ON)
  `uvm_object_utils_end

  // Declare config object
  i2cspibridge_config m_cfg;

  // Declare subsequencer handles
  clock_seqr_t        clock_seqr;
  reset_seqr_t        reset_seqr;

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="i2cspibridge_base_seq");
    super.new(name);
  endfunction : new

  /************************************************************
  *   TASK: Body
  *************************************************************/
  virtual task body();
    // Connect sub-sequencer instances to p_sequencer 
    clock_seqr = p_sequencer.clock_seqr;
    reset_seqr = p_sequencer.reset_seqr;
    // Set environment config
    m_cfg = p_sequencer.m_cfg;
  endtask : body
  
endclass : i2cspibridge_base_seq

`endif // _I2CSPIBRIDGE_BASE_SEQ_SVH
