//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   clock_agent_stop_seq.svh
// Description  :   Clock Agent Stop Sequence
//-------------------------------------------------------------
`ifndef _CLOCK_AGENT_STOP_SEQ_SVH
  `define _CLOCK_AGENT_STOP_SEQ_SVH
class clock_agent_stop_seq#(
    parameter N_CLK     = 1,
    type      SEQ_ITEM_T= clock_agent_seq_item#(N_CLK)
) extends clock_agent_base_seq#(SEQ_ITEM_T);
  `uvm_object_param_utils(clock_agent_stop_seq#(N_CLK, SEQ_ITEM_T))

  /******************************************************
  *   FUNCTION: Constructor
  ******************************************************/
  function new(string name="clock_agent_stop_seq");
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

    // Stop all clocks
    start_item(command);
      command.clock_op = CLK_STOP;
      foreach(command.clock_sel[i]) begin
        command.clock_sel   [i] = 1;
      end
    finish_item(command);
  endtask : body
  
endclass : clock_agent_stop_seq
`endif // _CLOCK_AGENT_STOP_SEQ_SVH