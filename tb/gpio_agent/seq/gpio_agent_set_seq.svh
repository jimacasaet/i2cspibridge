//-------------------------------------------------------------
// Create Date  :   2024-10-10
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   gpio_agent_set_seq.svh
// Description  :   GPIO Agent Set Sequence
//-------------------------------------------------------------
`ifndef _GPIO_AGENT_SET_SEQ_SVH
  `define _GPIO_AGENT_SET_SEQ_SVH
class gpio_agent_set_seq#(
    parameter SIGNAL_WIDTH,
    parameter N_SIGNAL,
    type      SEQ_ITEM_T= gpio_agent_seq_item#(SIGNAL_WIDTH, N_SIGNAL)
  ) extends gpio_agent_base_seq#(SEQ_ITEM_T);
  `uvm_object_param_utils(gpio_agent_set_seq#(SIGNAL_WIDTH, N_SIGNAL, SEQ_ITEM_T))

  // Define Variables to set Seq Item manually
  logic [SIGNAL_WIDTH-1:0] gpio_signal   [N_SIGNAL];

  /******************************************************
  *   FUNCTION: Constructor
  ******************************************************/
  function new(string name="gpio_agent_set_seq");
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

    // Create clocks with defined settings in the variables
    start_item(command);
      command.gpio_op = GPIO_WRITE;
      foreach(command.gpio_signal[i]) begin
        command.gpio_signal[i] = gpio_signal[i];
      end
    finish_item(command);
  endtask : body
  
endclass : gpio_agent_set_seq
`endif // _GPIO_AGENT_SET_SEQ_SVH