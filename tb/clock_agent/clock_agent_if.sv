//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   clock_agent_if.sv
// Description  :   Clock Agent Interface
//-------------------------------------------------------------
`ifndef _CLOCK_AGENT_AGENT_IF_SV
  `define _CLOCK_AGENT_AGENT_IF_SV

interface clock_agent_if#(parameter N_CLK=1) ();
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Logic array for the clocks
  logic [N_CLK-1:0] clk;
  // Process for each clock generated
  process clk_proc[N_CLK];

  /*****************************************************************************************
  *   Task: Start Clock
  *     Starts the clock defined in the clk_sel array. Can
  *     also be used to reconfigure the clk in clk_sel.
  *
  *   Args:
  *      clk_sel    - selecting target clock in clk array (logic)
  *
  *      clk_init   - initial value of the clock with the same
  *                   index in clk array (logic)
  *
  *      clk_period - clock period of the clock with the same
  *                   index in clk array (realtime)
  *
  *      phase_shift- set phase shift of the clock with the same
  *                   index in clk array (realtime)
  *
  *      duty_cycle - set the pulse width of the percentage of
  *                   the period where the clock is high. (int)
  *                   Duty Cycle values: MIN = 1, MAX = 99
  *
  *          ___     ___     ___     ___      T_high = T_low
  *      ___|   |___|   |___|   |___|   |___  Duty   = T_high / (T_high+T_low) = 50%
  *
  *          ______    ______    ______    _  T_high = 6 time units, T_low = 2 time units
  *       __|      |__|      |__|      |__|   Duty   = T_high / (T_high+T_low) = 75%
  *
  *****************************************************************************************/
  task start(
    input     clk_sel    [N_CLK], 
    input     clk_init   [N_CLK], 
    realtime  clk_period [N_CLK], 
    realtime  phase_shift[N_CLK],
    int       duty_cycle [N_CLK]);

    real duty[N_CLK];
    realtime delay[N_CLK];

    // Perform initial check for duty cycle
    foreach(duty_cycle[i]) begin
      if(duty_cycle[i]>99) begin
        `uvm_warning("Clock Agent IF", $sformatf("Duty Cycle for clk[%0d] is set to greater than 99%%",i))
        duty[i] = 99;
      end else if(duty_cycle[i]<=0) begin
        `uvm_warning("Clock Agent IF", $sformatf("Duty Cycle for clk[%0d] is set to or less than 0%%",i))
        duty[i] = 1;
      end else
        duty[i] = duty_cycle[i];
    end

    // Start the clock for each element of clk_sel
    foreach(clk_sel[i]) begin
      if(clk_sel[i]) begin
        automatic int j = i;

        // If process has been started, kill the process
        if(clk_proc[j] != null)
          clk_proc[j].kill();

        // Generate the clock in a fork..join_none
        fork 
          begin : clk_gen 
            // Create handle to the current process
            clk_proc[j] = process::self();

            // Set the clock initial value
            clk[j] = clk_init[j];

            // Main clock gen in forever loop
            forever begin
              // Positive edge of clock
              if(clk[j]==1) begin
                delay[j] = (clk_period[j]*realtime'(duty[j]/100));
                `uvm_info("Clock Agent IF", $sformatf("Clock High, Period=%0t Duty=%0t Delay=%0t", clk_period[j], realtime'(duty[j]/100), delay[j]), UVM_DEBUG)
                #(clk_period[j]*realtime'(duty[j]/100));
              // Negative edge of clock
              end else begin
                delay[j] = (clk_period[j]*realtime'((100-duty[j])/100));
                `uvm_info("Clock Agent IF", $sformatf("Clock Low, Period=%0t Duty=%0t Delay=%0t",clk_period[j], realtime'((100-duty[j])/100), delay[j]), UVM_DEBUG)
                #(clk_period[j]*realtime'((100-duty[j])/100));
              end
              // Invert the clock
              clk[j] = ~clk[j];
            end // forever begin

          end   : clk_gen
        join_none // fork 
      end
    end

    `uvm_info("Clock Agent IF", "Start Task Finished", UVM_DEBUG)

  endtask : start

  /*********************************************************
  *   Task: Stop Clock
  *     Stops the clock with indices same as 
  *********************************************************/
  task stop(input clk_sel[N_CLK]);
    foreach(clk_sel[i]) begin
      automatic int j = i;
      if(clk_sel[j] && clk_proc[j]!= null) begin
        clk_proc[j].kill();
        clk_proc[j] = null;
      end
    end

    `uvm_info("Clock Agent IF", "Stop Task Finished", UVM_DEBUG)
  endtask : stop

endinterface : clock_agent_if

`endif //_CLOCK_AGENT_AGENT_IF_SV