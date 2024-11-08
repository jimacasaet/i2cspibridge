`ifndef _SPI_AGENT_BASE_SEQ_SVH
  `define _SPI_AGENT_BASE_SEQ_SVH
class spi_agent_base_seq#(
    type SEQ_ITEM_T
  ) extends uvm_sequence#(SEQ_ITEM_T);
  `uvm_object_param_utils(spi_agent_base_seq#(SEQ_ITEM_T))

  /******************************************************
  *   FUNCTION: Constructor
  ******************************************************/
  function new(string name="spi_agent_base_seq");
    super.new(name);
  endfunction : new

  /******************************************************
  *   TASK: Body
  ******************************************************/
  virtual task body();

  endtask : body

endclass : spi_agent_base_seq
`endif // _SPI_AGENT_BASE_SEQ_SVH
