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
    parameter BYTE_SIZE = 8
  ) extends uvm_sequence_item;

  // Register seq item to factory
  `uvm_object_param_utils(i2c_agent_seq_item#(BYTE_SIZE))

  // Seq item variable definitions
  i2c_op_e                  i2c_op;                // I2C operation
  logic [BYTE_SIZE-1:0]     i2c_signal;            // I2C Data
  logic                     i2c_ack;

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
    $sformat(s, "op=%s val=%0h", i2c_op.name, i2c_signal);
    return s;
  endfunction : convert2string

endclass : i2c_agent_seq_item

`endif //_I2C_AGENT_SEQ_ITEM_SVH