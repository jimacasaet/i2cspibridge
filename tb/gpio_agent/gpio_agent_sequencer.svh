//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   gpio_agent_sequencer.svh
// Description  :   GPIO Agent Sequencer
//-------------------------------------------------------------
`ifndef _GPIO_AGENT_SEQUENCER_SVH
  `define _GPIO_AGENT_SEQUENCER_SVH

class gpio_agent_sequencer#(
    type SEQ_ITEM_T
  ) extends uvm_sequencer#(SEQ_ITEM_T);

  `uvm_component_param_utils(gpio_agent_sequencer#(SEQ_ITEM_T))

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="gpio_agent_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

endclass : gpio_agent_sequencer

`endif //_GPIO_AGENT_SEQUENCER_SVH