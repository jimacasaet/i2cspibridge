//-------------------------------------------------------------
// Create Date  :   2024-10-10
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2c_agent_read_byte_seq.svh
// Description  :   I2C Agent Write Byte Sequence
//-------------------------------------------------------------
`ifndef _I2C_AGENT_READ_BYTE_SEQ_SVH
  `define _I2C_AGENT_READ_BYTE_SEQ_SVH
class i2c_agent_read_byte_seq#(
    parameter BYTE_SIZE = 8,
    parameter ADDR_SIZE = BYTE_SIZE-1,
    type      SEQ_ITEM_T   = i2c_agent_seq_item#(BYTE_SIZE)
  ) extends i2c_agent_base_seq#(SEQ_ITEM_T);
  `uvm_object_param_utils(i2c_agent_read_byte_seq#(BYTE_SIZE, ADDR_SIZE, SEQ_ITEM_T))

  // Define Variables to read_byte Seq Item manually
  logic i2c_ack;

  /******************************************************
  *   FUNCTION: Constructor
  ******************************************************/
  function new(string name="i2c_agent_read_byte_seq");
    super.new(name);
  endfunction : new

  /******************************************************
  *   TASK: Body
  ******************************************************/
  task body();
    // Instantiate the sequence item
    SEQ_ITEM_T  command;

    // Create the sequence item
    command = SEQ_ITEM_T::type_id::create("command");

    // Set the sequence item contents
    start_item(command);
      command.i2c_op = I2C_READ_BYTE;
      command.i2c_signal = {{(BYTE_SIZE-1){1'b0}}, i2c_ack};
    finish_item(command);
  endtask : body
  
endclass : i2c_agent_read_byte_seq
`endif // _I2C_AGENT_READ_BYTE_SEQ_SVH