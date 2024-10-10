//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2cspibridge_coverage.svh
// Description  :   I2C-SPI Bridge Coverage Collector
//-------------------------------------------------------------
`ifndef _I2CSPIBRIDGE_COVERAGE_SVH
  `define _I2CSPIBRIDGE_COVERAGE_SVH

class i2cspibridge_coverage extends uvm_component;

  // Register to Factory
  `uvm_component_param_utils(i2cspibridge_coverage)

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="i2cspibridge_coverage", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  /************************************************************
  *   FUNCTION: Build Phase
  *************************************************************/
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

  /************************************************************
  *   TASK: Run Phase
  *************************************************************/
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask : run_phase

endclass : i2cspibridge_coverage

`endif // _I2CSPIBRIDGE_COVERAGE_SVH