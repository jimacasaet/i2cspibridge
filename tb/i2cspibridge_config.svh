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

  // Configuration Variables
  bit has_scoreboard;
  bit has_coverage;

  bit has_clock_agent;

  // Define default constraints upon randomization
  constraint default_constraints{
    // Env Constraints
    soft has_scoreboard   == 0;
    soft has_coverage     == 0;
    // Agent Constraints
    soft has_clock_agent  == 1;
  };

  /*********************************************************
  *   FUNCTION: Constructor
  *********************************************************/
  function new(string name="i2cspibridge_config", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new
endclass : i2cspibridge_config

`endif // _I2CSPIBRIDGE_CONFIG_SVH