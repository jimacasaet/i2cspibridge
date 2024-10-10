//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2cspibridge_base_test.svh
// Description  :   I2C-SPI Bridge Base Test
//-------------------------------------------------------------
`ifndef _I2CSPIBRIDGE_BASE_TEST_SVH
  `define _I2CSPIBRIDGE_BASE_TEST_SVH

virtual class i2cspibridge_base_test extends uvm_test;

  // Instantiate Configuration
  i2cspibridge_config       m_cfg;
  // Instantiate Environment
  i2cspibridge_environment  t_env;

  // Instantiate Common Sequences
  // clock_agent_

  /******************************************************************************
  *   FUNCTION: Constructor
  ******************************************************************************/
  function new(string name="i2cspibridge_base_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  /******************************************************************************
  *   FUNCTION: Build Phase
  ******************************************************************************/
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Create config
    m_cfg = i2cspibridge_config::type_id::create("m_i2cspibridge_cfg", this);
    
    // Randomize config
    assert(m_cfg.randomize())
    else
      `uvm_fatal("Base Test CFG", "Failed to randomize the config object")

    // Set the config in DB
    uvm_config_db#(i2cspibridge_config)::
      set(null, "", "i2cspibridge_config", m_cfg);

    // Set the config in DB
    uvm_config_db#(i2cspibridge_config)::
      set(null, "t_env", "i2cspibridge_config", m_cfg);

    // Create new environment for testcase
    t_env = new("t_env", this);
  endfunction : build_phase

  /******************************************************************************
  *   TASK: Pre-reset Phase
  ******************************************************************************/
  virtual task pre_reset_phase(uvm_phase phase);
    super.pre_reset_phase(phase);

    phase.raise_objection(this);

    phase.drop_objection(this);
  endtask : pre_reset_phase

  /*****************************************************************
  *   FUNCTION: Report Phase
  *****************************************************************/
  virtual function void report_phase(uvm_phase phase);
    uvm_report_server   m_server;
    super.report_phase(phase);

    m_server = uvm_report_server::get_server();

    if(m_server.get_severity_count(UVM_FATAL)+m_server.get_severity_count(UVM_ERROR) > 0) begin
      $display("%c[1;31m",27);
      $display("###############################");
      $display("# ███████╗ █████╗ ██╗██╗      #");
      $display("# ██╔════╝██╔══██╗██║██║      #");
      $display("# █████╗  ███████║██║██║      #");
      $display("# ██╔══╝  ██╔══██║██║██║      #");
      $display("# ██║     ██║  ██║██║███████╗ #");
      $display("# ╚═╝     ╚═╝  ╚═╝╚═╝╚══════╝ #");
      $display("###############################");
      $write("%c[0m",27);
    end else begin
      if(m_server.get_severity_count(UVM_WARNING)>0)
        $display("%c[1;33m",27);
      else
        $display("%c[1;32m",27);
      $display("####################################");
      $display("# ██████╗  █████╗ ███████╗███████╗ #");
      $display("# ██╔══██╗██╔══██╗██╔════╝██╔════╝ #");
      $display("# ██████╔╝███████║███████╗███████╗ #");
      $display("# ██╔═══╝ ██╔══██║╚════██║╚════██║ #");
      $display("# ██║     ██║  ██║███████║███████║ #");
      $display("# ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝ #");
      $display("####################################");
      $write("%c[0m",27);
    end
  endfunction : report_phase


endclass : i2cspibridge_base_test
`endif // _I2CSPIBRIDGE_BASE_TEST_SVH
