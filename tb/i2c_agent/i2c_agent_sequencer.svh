//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2c_agent_sequencer.svh
// Description  :   I2C Agent Sequencer
//-------------------------------------------------------------
`ifndef _I2C_AGENT_SEQUENCER_SVH
  `define _I2C_AGENT_SEQUENCER_SVH

class i2c_agent_sequencer#(
    type SEQ_ITEM_T = i2c_agent_seq_item#(1, 1)
  ) extends uvm_sequencer#(SEQ_ITEM_T);

  `uvm_component_param_utils(i2c_agent_sequencer#(SEQ_ITEM_T))

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="i2c_agent_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

endclass : i2c_agent_sequencer

`endif //_I2C_AGENT_SEQUENCER_SVH