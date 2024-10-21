//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   gpio_agent_seq_item.svh
// Description  :   GPIO Agent Sequence Item
//-------------------------------------------------------------
`ifndef _GPIO_AGENT_SEQ_ITEM_SVH
  `define _GPIO_AGENT_SEQ_ITEM_SVH

class gpio_agent_seq_item#(
    parameter SIGNAL_WIDTH,
    parameter N_SIGNAL
  ) extends uvm_sequence_item;

  // Register seq item to factory
  `uvm_object_param_utils(gpio_agent_seq_item#(SIGNAL_WIDTH, N_SIGNAL))

  // Seq item variable definitions
  gpio_op_e                 gpio_op;                // GPIO operation
  logic [SIGNAL_WIDTH-1:0]  gpio_signal [N_SIGNAL]; // GPIO select

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
    $sformat(s, "op=%s ", gpio_op.name);
    foreach(gpio_signal[i]) begin
      $sformat(s, "%s signal[%0d]=%0h ", 
                   s, i, gpio_signal[i]);
    end
    return s;
  endfunction : convert2string

endclass : gpio_agent_seq_item

`endif //_GPIO_AGENT_SEQ_ITEM_SVH