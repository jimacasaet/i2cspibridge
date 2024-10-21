//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   gpio_agent_if.sv
// Description  :   GPIO Agent Interface
//-------------------------------------------------------------
`ifndef _GPIO_AGENT_AGENT_IF_SV
  `define _GPIO_AGENT_AGENT_IF_SV

interface gpio_agent_if#(
  parameter SIGNAL_WIDTH, 
  parameter N_SIGNAL
  ) (input clk_i, input rst_n_i);
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Logic array for the clocks
  logic [SIGNAL_WIDTH-1:0] gpio_signal [N_SIGNAL];

  /************************************************************
  *  CLOCKING BLOCK
  ************************************************************/
  clocking gpio_cb @(posedge clk_i);
    input #0 output #0 gpio_signal;
  endclocking : gpio_cb

  /************************************************************
  *  TASK: Write to GPIO
  ************************************************************/
  task write_gpio(input [SIGNAL_WIDTH-1:0] gpio_input [N_SIGNAL]);
    @(gpio_cb);
    foreach(gpio_input[i])
      gpio_signal[i] <= gpio_input[i];
  endtask : write_gpio

  /************************************************************
  *  TASK: Initialize GPIO
  ************************************************************/
  task init_gpio(input [SIGNAL_WIDTH-1:0] gpio_input [N_SIGNAL]);
    foreach(gpio_input[i])
      gpio_signal[i] <= gpio_input[i];
  endtask : init_gpio

  /************************************************************
  *  TASK: Read GPIO
  ************************************************************/
  task read_gpio(output [SIGNAL_WIDTH-1:0] gpio_output [N_SIGNAL]);
    @(gpio_cb);
    foreach(gpio_output[i])
      gpio_output <= gpio_signal[i];
  endtask : read_gpio

endinterface : gpio_agent_if

`endif //_GPIO_AGENT_AGENT_IF_SV