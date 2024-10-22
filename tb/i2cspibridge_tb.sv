//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2cspibridge_tb.sv
// Description  :   I2C-SPI Bridge Testbench Top
//-------------------------------------------------------------
`ifndef _I2CSPIBRIDGE_TB_SV
  `define _I2CSPIBRIDGE_TB_SV

`timescale 1ns/1ps
module tb_i2cspibridge();
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  // Import Agent Packages
  import clock_agent_pkg::*;
  import gpio_agent_pkg::*;

  import i2cspibridge_uvm_pkg::*;
  import i2cspibridge_test_pkg::*;

  // Time Format
  initial $timeformat(-9, 3, "ns", 9);

  // Instantiate tb config
  i2cspibridge_config   m_cfg;

  //###########################################
  //  Instantiate Agent Interfaces
  //###########################################

  // Clock Agent Interface
  clock_agent_if #(
    .N_CLK(N_CLK)
  ) m_clock_vif();

  gpio_agent_if #(
    .SIGNAL_WIDTH(RESET_WIDTH ),
    .N_SIGNAL    (N_RESET     )
  ) m_reset_vif (.clk_i(m_clock_vif.clk[CLK_CLK]));

  //###########################################
  //  Set the VIF using uvm_config_db
  //###########################################
  initial begin
    uvm_config_db #(virtual clock_agent_if#(N_CLK))::
      set(null, "*", "clock_agent_if", m_clock_vif);

    uvm_config_db #(virtual gpio_agent_if#(RESET_WIDTH, N_RESET))::
      set(null, "uvm_test_top.t_env.m_reset_agent.*", "gpio_agent_if", m_reset_vif);
    
    run_test();
  end // initial begin

  //###########################################
  //  Dumping
  //###########################################
  initial begin
    `ifdef VCS 
      begin
        // `uvm_info("TB", "Using VCS Compiler", UVM_NONE);
        $vcdplusfile("i2cspibridge_dump.vpd");
        $vcdpluson();
        $vcdplusmemon();
      end 
    `else 
      begin
        // `uvm_info("TB", "Using Other Compiler", UVM_NONE);
        $dumpfile("i2cspibridge_dump.vcd");
        $dumpvars();
      end
    `endif
  end // initial begin

  //###########################################
  //  Setting config using uvm_config_db
  //###########################################
  initial begin
    // Wait for config to be modified
    uvm_config_db#(i2cspibridge_config)::wait_modified(null, "", "i2cspibridge_config");
    // Retrieve config from the db
    assert(uvm_config_db#(i2cspibridge_config)::get(null, "", "i2cspibridge_config", m_cfg)) else 
      `uvm_fatal("TB Config Missing", "No Configuration Found");
  
  end // initial begin

  //###########################################
  //  Instantiate Design
  //###########################################
  I2CSPIBridge i_i2cspibridge(
    .CLK  ( m_clock_vif.clk[CLK_CLK]      ),
    .RST_N( m_reset_vif.gpio_signal[RST_N]),
    .SCL  ( m_clock_vif.clk[CLK_SCL]      ),
    .SDA  ( ),
    .MISO ( ),
    .SCLK ( ),
    .MOSI ( ),
    .SS0  ( ),
    .SS1  ( ),
    .SS2  ( )
  );
endmodule : tb_i2cspibridge

`endif // _I2CSPIBRIDGE_TB_SV