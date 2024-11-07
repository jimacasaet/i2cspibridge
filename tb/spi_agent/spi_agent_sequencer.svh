//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   spi_agent_sequencer.svh
// Description  :   SPI Agent Sequencer
//-------------------------------------------------------------
`ifndef _SPI_AGENT_SEQUENCER_SVH
  `define _SPI_AGENT_SEQUENCER_SVH

class spi_agent_sequencer#(
    type SEQ_ITEM_T = spi_agent_seq_item#(1, 1)
  ) extends uvm_sequencer#(SEQ_ITEM_T);

  `uvm_component_param_utils(spi_agent_sequencer#(SEQ_ITEM_T))

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="spi_agent_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

endclass : spi_agent_sequencer

`endif //_SPI_AGENT_SEQUENCER_SVH