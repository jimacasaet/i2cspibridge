//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   clock_agent_seq_item.svh
// Description  :   Clock Agent Sequence Item
//-------------------------------------------------------------
`ifndef _CLOCK_AGENT_SEQ_ITEM_SVH
  `define _CLOCK_AGENT_SEQ_ITEM_SVH

class clock_agent_seq_item#(
    parameter N_CLK = 1
  ) extends uvm_sequence_item;

  // Register seq item to factory
  `uvm_object_param_utils(clock_agent_seq_item#(N_CLK))

  // Seq item variable definitions
  clock_op_e  clock_op; // Clock operation
  logic       clock_sel     [N_CLK]; // Clock select
  logic       clock_init    [N_CLK]; // Initial clock value
  realtime    clock_period  [N_CLK]; // Clock period
  realtime    phase_shift   [N_CLK]; // Phase shift
  int         duty_cycle    [N_CLK]; // Clock duty cycle

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
    foreach(clock_sel[i]) begin
      $sformat(s, "%s op=%0s\tsel=%0d\tperiod=%0d\tinit=%0b\tpshift=%0d\tduty=%0d\n", 
                   s, clock_op.name, clock_sel[i], clock_period[i],
                   clock_init[i], phase_shift[i], duty_cycle[i]);
    end
    return s;
  endfunction : convert2string

endclass : clock_agent_seq_item

`endif //_CLOCK_AGENT_SEQ_ITEM_SVH