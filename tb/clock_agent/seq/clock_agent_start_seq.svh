//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   clock_agent_start_seq.svh
// Description  :   Clock Agent Start Sequence
//-------------------------------------------------------------
`ifndef _CLOCK_AGENT_START_SEQ_SVH
  `define _CLOCK_AGENT_START_SEQ_SVH
class clock_agent_start_seq#(
    parameter N_CLK     = 1,
    realtime  CLK_PERIOD= 15ns,
    type      SEQ_ITEM_T= clock_agent_seq_item#(N_CLK)
) extends clock_agent_base_seq#(SEQ_ITEM_T);
  `uvm_object_param_utils(clock_agent_start_seq#(N_CLK, CLK_PERIOD, SEQ_ITEM_T))

  /******************************************************
  *   FUNCTION: Constructor
  ******************************************************/
  function new(string name="clock_agent_start_seq");
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

    // Create clocks that have period CLK_PERIOD with init=1,
    // no phase shift, and duty cycle of 50%
    start_item(command);
      command.clock_op = CLK_START;
      foreach(command.clock_sel[i]) begin
        command.clock_sel   [i] = 1;
        command.clock_period[i] = CLK_PERIOD;
        command.clock_init  [i] = 1;
        command.phase_shift [i] = 0;
        command.duty_cycle  [i] = 50;
      end
    finish_item(command);
  endtask : body
  
endclass : clock_agent_start_seq
`endif // _CLOCK_AGENT_START_SEQ_SVH