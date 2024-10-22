//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2cspibridge_tb.svh
// Description  :   I2C-SPI Bridge Virtual Sequencer
//-------------------------------------------------------------
`ifndef _I2CSPIBRIDGE_VIRTUAL_SEQUENCER_SVH
  `define _I2CSPIBRIDGE_VIRTUAL_SEQUENCER_SVH

class i2cspibridge_virtual_sequencer extends uvm_virtual_sequencer;
  `uvm_component_param_utils(i2cspibridge_virtual_sequencer)

  // Declare config file
  i2cspibridge_config   m_cfg;
  
  // Declare subsequencer handles
  clock_seqr_t          clock_seqr;
  reset_seqr_t          reset_seqr;

  /*********************************************************
  *   FUNCTION: Constructor
  *********************************************************/
  function new(string name="i2cspibridge_virtual_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new
  
endclass : i2cspibridge_virtual_sequencer

`endif // _I2CSPIBRIDGE_VIRTUAL_SEQUENCER_SVH