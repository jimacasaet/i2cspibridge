//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2c_agent_seq_item.svh
// Description  :   I2C Agent Sequence Item
//-------------------------------------------------------------
`ifndef _I2C_AGENT_SEQ_ITEM_SVH
  `define _I2C_AGENT_SEQ_ITEM_SVH

class i2c_agent_seq_item#(
    parameter SIGNAL_WIDTH = 1,
    parameter N_SIGNAL     = 1
  ) extends uvm_sequence_item;

  // Register seq item to factory
  `uvm_object_param_utils(i2c_agent_seq_item#(SIGNAL_WIDTH, N_SIGNAL))

  // Seq item variable definitions
  i2c_op_e                 i2c_op;                // I2C operation
  logic [SIGNAL_WIDTH-1:0]  i2c_signal [N_SIGNAL]; // I2C select
  realtime                  delay       [N_SIGNAL]; // I2C Async delay

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
    $sformat(s, "op=%s ", i2c_op.name);
    foreach(i2c_signal[i]) begin
      $sformat(s, "%s signal[%0d]=%0h ", 
                   s, i, i2c_signal[i]);
    end
    return s;
  endfunction : convert2string

endclass : i2c_agent_seq_item

`endif //_I2C_AGENT_SEQ_ITEM_SVH