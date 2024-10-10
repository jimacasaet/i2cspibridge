//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   clock_agent_sequencer.svh
// Description  :   Clock Agent Sequencer
//-------------------------------------------------------------
`ifndef _CLOCK_AGENT_SEQUENCER_SVH
  `define _CLOCK_AGENT_SEQUENCER_SVH

class clock_agent_sequencer#(
    type SEQ_ITEM_T
  ) extends uvm_sequencer#(SEQ_ITEM_T);

  `uvm_component_param_utils(clock_agent_sequencer#(SEQ_ITEM_T))

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="clock_agent_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

endclass : clock_agent_sequencer

`endif //_CLOCK_AGENT_SEQUENCER_SVH