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
  import spi_agent_pkg::*;

  import i2cspibridge_uvm_pkg::*;
  import i2cspibridge_test_pkg::*;

  // Time Format
  initial $timeformat(-9, 3, "ns", 9);

  // Instantiate tb config
  i2cspibridge_config   m_cfg;
  wire SDA_w;

  // Temporary wires until SPI Agent is created
  wire SCLK_w, MOSI_w, MISO_w;
  wire SS0_w, SS1_w, SS2_w;

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
  ) m_reset_vif (
    .clk_i(m_clock_vif.clk[CLK_CLK])
  );

  i2c_agent_if #(
    .BYTE_SIZE(I2C_BYTE_SIZE),
    .ADDR_SIZE(I2C_ADDR_SIZE)
  ) m_i2c_vif (
    .scl(m_clock_vif.clk[CLK_SCL]),
    .sda( SDA_w )
  );

  spi_agent_if #(
    .BYTE_WIDTH(I2C_BYTE_SIZE)
  ) m_spi_vif ( .sclk(SCLK_w) );

  //###########################################
  //  Set the VIF using uvm_config_db
  //###########################################
  initial begin
    uvm_config_db #(virtual clock_agent_if#(N_CLK))::
      set(null, "*", "clock_agent_if", m_clock_vif);

    uvm_config_db #(virtual gpio_agent_if#(RESET_WIDTH, N_RESET))::
      set(null, "uvm_test_top.t_env.m_reset_agent.*", "gpio_agent_if", m_reset_vif);

    uvm_config_db #(virtual i2c_agent_if#(I2C_BYTE_SIZE, I2C_ADDR_SIZE))::
      set(null, "uvm_test_top.t_env.m_i2c_agent.*", "i2c_agent_if", m_i2c_vif);

    uvm_config_db #(virtual spi_agent_if#(I2C_BYTE_SIZE))::
      set(null, "uvm_test_top.t_env.*", "spi_agent_if", m_spi_vif);
    
    run_test();
  end // initial begin

  //###########################################
  //  Dumping
  //###########################################
  initial begin
    `ifdef VCS 
      begin
        `uvm_info("TB", "Using VCS Compiler", UVM_NONE)
        $vcdplusfile("i2cspibridge_dump.vpd");
        $vcdpluson();
        $vcdplusmemon();
      end 
    `elsif XCELIUM
      begin
        `uvm_info("TB", "Using Xcelium Compiler", UVM_NONE)
        $recordfile("i2cspibridge_dump.trn");
        $recordvars();
      end
    `else 
      begin
        `uvm_info("TB", "Using Other Compiler", UVM_NONE)
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
    .SDA  ( SDA_w          ),
    .MISO ( MISO_w ),
    .SCLK ( SCLK_w         ),
    .MOSI ( MOSI_w ),
    .SS0  ( SS0_w ),
    .SS1  ( SS1_w  ),
    .SS2  ( SS2_w  )
  );

  //###########################################
  //  Instantiate SPI Slaves
  //###########################################
  
  // SS0
  SPISlave#(.DATA_WIDTH(I2C_BYTE_SIZE)) i_ss0(
    .CLK  ( m_clock_vif.clk[CLK_CLK]      ),
    .RST_N( m_reset_vif.gpio_signal[RST_N]),
    .SCLK ( SCLK_w ),
    .MOSI ( MOSI_w ),
    .SS   ( SS0_w  ),
    .MISO ( MISO_w )
  );

  // SS1
  SPISlave#(.DATA_WIDTH(I2C_BYTE_SIZE)) i_ss1(
    .CLK  ( m_clock_vif.clk[CLK_CLK]      ),
    .RST_N( m_reset_vif.gpio_signal[RST_N]),
    .SCLK ( SCLK_w ),
    .MOSI ( MOSI_w ),
    .SS   ( SS1_w  ),
    .MISO ( MISO_w )
  );

  // SS2
  SPISlave#(.DATA_WIDTH(I2C_BYTE_SIZE)) i_ss2(
    .CLK  ( m_clock_vif.clk[CLK_CLK]      ),
    .RST_N( m_reset_vif.gpio_signal[RST_N]),
    .SCLK ( SCLK_w ),
    .MOSI ( MOSI_w ),
    .SS   ( SS2_w  ),
    .MISO ( MISO_w )
  );
endmodule : tb_i2cspibridge

`endif // _I2CSPIBRIDGE_TB_SV