//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   spi_agent_seq_item.svh
// Description  :   SPI Agent Sequence Item
//-------------------------------------------------------------
`ifndef _SPI_AGENT_SEQ_ITEM_SVH
  `define _SPI_AGENT_SEQ_ITEM_SVH

class spi_agent_seq_item#(
    parameter SIGNAL_WIDTH = 1,
    parameter N_SIGNAL     = 1
  ) extends uvm_sequence_item;

  // Register seq item to factory
  `uvm_object_param_utils(spi_agent_seq_item#(SIGNAL_WIDTH, N_SIGNAL))

  // Seq item variable definitions
  spi_op_e                 spi_op;                // SPI operation
  logic [SIGNAL_WIDTH-1:0]  spi_signal [N_SIGNAL]; // SPI select
  realtime                  delay       [N_SIGNAL]; // SPI Async delay

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
    foreach(spi_signal[i]) begin
      $sformat(s, "%s signal[%0d]=%0h ", 
                   s, i, spi_signal[i]);
    end
    return s;
  endfunction : convert2string

endclass : spi_agent_seq_item

`endif //_SPI_AGENT_SEQ_ITEM_SVH