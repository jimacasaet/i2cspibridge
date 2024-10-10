//-------------------------------------------------------------
// Create Date  :   2024-10-10
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   clock_agent_set_seq.svh
// Description  :   Clock Agent Set Sequence
//-------------------------------------------------------------
`ifndef _CLOCK_AGENT_SET_SEQ_SVH
  `define _CLOCK_AGENT_SET_SEQ_SVH
class clock_agent_set_seq#(
    parameter N_CLK     = 1,
    type      SEQ_ITEM_T= clock_agent_seq_item#(N_CLK)
) extends clock_agent_base_seq#(SEQ_ITEM_T);
  `uvm_object_param_utils(clock_agent_set_seq#(N_CLK, SEQ_ITEM_T))

  // Define Variables to set Seq Item manually
  logic     clock_sel   [N_CLK];
  logic     clock_init  [N_CLK];
  realtime  clock_period[N_CLK];
  realtime  phase_shift [N_CLK];
  int       duty_cycle  [N_CLK];

  /******************************************************
  *   FUNCTION: Constructor
  ******************************************************/
  function new(string name="clock_agent_set_seq");
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
        command.clock_sel   [i] = clock_sel   [i];
        command.clock_period[i] = clock_period[i];
        command.clock_init  [i] = clock_init  [i];
        command.phase_shift [i] = phase_shift [i];
        command.duty_cycle  [i] = duty_cycle  [i];
      end
    finish_item(command);
  endtask : body
  
endclass : clock_agent_set_seq
`endif // _CLOCK_AGENT_SET_SEQ_SVH