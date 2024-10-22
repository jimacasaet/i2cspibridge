//-------------------------------------------------------------
// Create Date  :   2024-10-10
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2c_agent_init_seq.svh
// Description  :   I2C Agent Initialize Sequence
//-------------------------------------------------------------
`ifndef _I2C_AGENT_INIT_SEQ_SVH
  `define _I2C_AGENT_INIT_SEQ_SVH
class i2c_agent_init_seq#(
    parameter SIGNAL_WIDTH,
    parameter N_SIGNAL,
    type      SEQ_ITEM_T= i2c_agent_seq_item#(SIGNAL_WIDTH, N_SIGNAL)
  ) extends i2c_agent_base_seq#(SEQ_ITEM_T);
  `uvm_object_param_utils(i2c_agent_init_seq#(SIGNAL_WIDTH, N_SIGNAL, SEQ_ITEM_T))

  // Define Variables to init Seq Item manually
  logic [SIGNAL_WIDTH-1:0] i2c_signal   [N_SIGNAL];

  /******************************************************
  *   FUNCTION: Constructor
  ******************************************************/
  function new(string name="i2c_agent_init_seq");
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
      command.i2c_op = I2C_INIT;
      foreach(command.i2c_signal[i]) begin
        command.i2c_signal[i] = 0;
      end
    finish_item(command);
  endtask : body
  
endclass : i2c_agent_init_seq
`endif // _I2C_AGENT_INIT_SEQ_SVH