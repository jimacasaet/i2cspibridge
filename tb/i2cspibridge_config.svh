//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2cspibridge_config.svh
// Description  :   I2C-SPI Bridge Environment Config
//-------------------------------------------------------------
`ifndef _I2CSPIBRIDGE_CONFIG_SVH
  `define _I2CSPIBRIDGE_CONFIG_SVH

class i2cspibridge_config extends uvm_component;
  `uvm_component_param_utils(i2cspibridge_config)

  // RegModel Handle
  i2cspibridge_uvm_reg_block  m_rm;

  // Configuration Variables
  rand bit has_scoreboard;
  rand bit has_coverage;
  rand bit has_regmodel;

  rand bit has_clock_agent;
  rand bit has_reset_agent;
  rand bit has_i2c_slv_agent;
  rand bit has_spi_mst_agent;

  // Define default constraints upon randomization
  constraint default_constraints{
    // Env Constraints
    soft has_scoreboard   == 1;
    soft has_coverage     == 1;
    soft has_regmodel     == 1;
    // Agent Constraints
    soft has_clock_agent  == 1;
    soft has_reset_agent  == 1;
    soft has_i2c_slv_agent== 1;
    soft has_spi_mst_agent== 1;
  };

  /*********************************************************
  *   FUNCTION: Constructor
  *********************************************************/
  function new(string name="i2cspibridge_config", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new
endclass : i2cspibridge_config

`endif // _I2CSPIBRIDGE_CONFIG_SVH