//-------------------------------------------------------------
// Create Date  :   2024-10-10
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2c_agent_send_start_seq.svh
// Description  :   I2C Agent Send Start Byte Sequence
//-------------------------------------------------------------
`ifndef _I2C_AGENT_SEND_START_SEQ_SVH
  `define _I2C_AGENT_SEND_START_SEQ_SVH
class i2c_agent_send_start_seq#(
    parameter BYTE_SIZE = 8,
    parameter ADDR_SIZE = BYTE_SIZE-1,
    type      SEQ_ITEM_T   = i2c_agent_seq_item#(BYTE_SIZE)
  ) extends i2c_agent_base_seq#(SEQ_ITEM_T);
  `uvm_object_param_utils(i2c_agent_send_start_seq#(BYTE_SIZE, ADDR_SIZE, SEQ_ITEM_T))

  // Define Variables to init Seq Item manually
  logic [ADDR_SIZE-1:0] i2c_address;
  logic                 rw_bit;

  /******************************************************
  *   FUNCTION: Constructor
  ******************************************************/
  function new(string name="i2c_agent_send_start_seq");
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

    // Create clocks with defined init settings in the variables
    start_item(command);
      command.i2c_op      = I2C_SEND_START;
      command.i2c_signal  = {i2c_address, rw_bit};
    finish_item(command);
  endtask : body
  
endclass : i2c_agent_send_start_seq
`endif // _I2C_AGENT_SEND_START_SEQ_SVH