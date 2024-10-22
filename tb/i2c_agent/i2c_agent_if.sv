//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2c_agent_if.sv
// Description  :   I2C Agent Interface
//-------------------------------------------------------------
`ifndef _I2C_AGENT_AGENT_IF_SV
  `define _I2C_AGENT_AGENT_IF_SV

interface i2c_agent_if#(
  parameter SIGNAL_WIDTH = 1, 
  parameter N_SIGNAL     = 1
  ) (input clk_i);
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Logic array for the clocks
  logic [SIGNAL_WIDTH-1:0] i2c_signal [N_SIGNAL];

  /************************************************************
  *  CLOCKING BLOCK
  ************************************************************/
  clocking i2c_cb @(posedge clk_i);
    input #0 output #0 i2c_signal;
  endclocking : i2c_cb

  /************************************************************
  *  TASK: Write to I2C
  ************************************************************/
  task write_i2c(input [SIGNAL_WIDTH-1:0] i2c_input [N_SIGNAL], input is_sync, realtime delay [N_SIGNAL]);
    // If synchronous, wait clock edge
    if(is_sync)
      @(i2c_cb);

    foreach(i2c_input[i])
      i2c_signal[i] <= i2c_input[i];
  endtask : write_i2c

  /************************************************************
  *  TASK: Initialize I2C
  ************************************************************/
  task init_i2c(input [SIGNAL_WIDTH-1:0] i2c_input [N_SIGNAL]);
    foreach(i2c_input[i])
      i2c_signal[i] <= i2c_input[i];
  endtask : init_i2c

  /************************************************************
  *  TASK: Read I2C
  ************************************************************/
  task read_i2c(output [SIGNAL_WIDTH-1:0] i2c_output [N_SIGNAL], input is_sync);
    // If synchronous, wait clock edge
    if(is_sync)
      @(i2c_cb);

    foreach(i2c_output[i]) begin
      automatic int j = i;
      fork 
        begin
          i2c_output[j] <= i2c_signal[j];
        end
      join
    end
  endtask : read_i2c

endinterface : i2c_agent_if

`endif //_I2C_AGENT_AGENT_IF_SV