`ifndef _CLOCK_AGENT_BASE_SEQ_SVH
  `define _CLOCK_AGENT_BASE_SEQ_SVH
class clock_agent_base_seq#(
    type SEQ_ITEM_T
  ) extends uvm_sequence#(SEQ_ITEM_T);
  `uvm_object_param_utils(clock_agent_base_seq#(SEQ_ITEM_T))

  /******************************************************
  *   FUNCTION: Constructor
  ******************************************************/
  function new(string name="clock_agent_base_seq");
    super.new(name);
  endfunction : new

  /******************************************************
  *   TASK: Body
  ******************************************************/
  virtual task body();

  endtask : body

endclass : clock_agent_base_seq
`endif // _CLOCK_AGENT_BASE_SEQ_SVH
