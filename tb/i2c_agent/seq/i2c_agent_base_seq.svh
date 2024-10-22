`ifndef _I2C_AGENT_BASE_SEQ_SVH
  `define _I2C_AGENT_BASE_SEQ_SVH
class i2c_agent_base_seq#(
    type SEQ_ITEM_T
  ) extends uvm_sequence#(SEQ_ITEM_T);
  `uvm_object_param_utils(i2c_agent_base_seq#(SEQ_ITEM_T))

  /******************************************************
  *   FUNCTION: Constructor
  ******************************************************/
  function new(string name="i2c_agent_base_seq");
    super.new(name);
  endfunction : new

  /******************************************************
  *   TASK: Body
  ******************************************************/
  virtual task body();

  endtask : body

endclass : i2c_agent_base_seq
`endif // _I2C_AGENT_BASE_SEQ_SVH
