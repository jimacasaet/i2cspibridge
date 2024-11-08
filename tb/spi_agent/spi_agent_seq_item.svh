//-------------------------------------------------------------
// Create Date  :   2024-11-07
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   spi_agent_seq_item.svh
// Description  :   SPI Agent Sequence Item
//-------------------------------------------------------------
`ifndef _SPI_AGENT_SEQ_ITEM_SVH
  `define _SPI_AGENT_SEQ_ITEM_SVH

class spi_agent_seq_item#(
    parameter BYTE_WIDTH = 8
  ) extends uvm_sequence_item;

  // Register seq item to factory
  `uvm_object_param_utils(spi_agent_seq_item#(BYTE_WIDTH))

  // Seq item variable definitions
  spi_op_e                spi_op;                // SPI operation
  logic [BYTE_WIDTH-1:0]  spi_signal; // SPI select

  /*********************************************************
  *   FUNCTION: Constructor
  **********************************************************/
  function new(string name="");
    super.new(name);
  endfunction : new

  /*********************************************************
  *   FUNCTION: Convert2String
  *     Converts contents of the sequence item into a 
  *     formatted string.
  **********************************************************/
  virtual function string convert2string();
    string s;
    $sformat(s, "op=%s ", spi_op.name);
    $sformat(s, "%s signal[%0d]=%0h ", s, spi_signal);
    return s;
  endfunction : convert2string

endclass : spi_agent_seq_item

`endif //_SPI_AGENT_SEQ_ITEM_SVH