//-------------------------------------------------------------
// Create Date  :   2024-10-10
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   gpio_agent_init_seq.svh
// Description  :   GPIO Agent Initialize Sequence
//-------------------------------------------------------------
`ifndef _GPIO_AGENT_INIT_SEQ_SVH
  `define _GPIO_AGENT_INIT_SEQ_SVH
class gpio_agent_init_seq#(
    parameter SIGNAL_WIDTH,
    parameter N_SIGNAL,
    type      SEQ_ITEM_T= gpio_agent_seq_item#(SIGNAL_WIDTH, N_SIGNAL)
  ) extends gpio_agent_base_seq#(SEQ_ITEM_T);
  `uvm_object_param_utils(gpio_agent_init_seq#(SIGNAL_WIDTH, N_SIGNAL, SEQ_ITEM_T))

  // Define Variables to init Seq Item manually
  logic [SIGNAL_WIDTH-1:0] gpio_signal   [N_SIGNAL];

  /******************************************************
  *   FUNCTION: Constructor
  ******************************************************/
  function new(string name="gpio_agent_init_seq");
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
      command.gpio_op = GPIO_INIT;
      foreach(command.gpio_signal[i]) begin
        command.gpio_signal[i] = 0;
      end
    finish_item(command);
  endtask : body
  
endclass : gpio_agent_init_seq
`endif // _GPIO_AGENT_INIT_SEQ_SVH