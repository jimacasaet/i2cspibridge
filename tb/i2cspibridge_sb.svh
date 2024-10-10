//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2cspibridge_sb.svh
// Description  :   I2C-SPI Bridge Scoreboard
//-------------------------------------------------------------
`ifndef _I2CSPIBRIDGE_SB_SVH
  `define _I2CSPIBRIDGE_SB_SVH

class i2cspibridge_sb extends uvm_scoreboard;

  // Register to Factory
  `uvm_component_param_utils(i2cspibridge_sb)

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="i2cspibridge_sb", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  /************************************************************
  *   FUNCTION: Build Phase
  *************************************************************/
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : i2cspibridge_sb

`endif // _I2CSPIBRIDGE_SB_SVH