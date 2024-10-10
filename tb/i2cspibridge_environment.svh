//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2cspibridge_environment.svh
// Description  :   I2C-SPI Bridge Environment 
//-------------------------------------------------------------
`ifndef _I2CSPIBRIDGE_ENVIRONMENT_SVH
  `define _I2CSPIBRIDGE_ENVIRONMENT_SVH

class i2cspibridge_environment extends uvm_env;
  // Register with factory
  `uvm_component_param_utils(i2cspibridge_environment)

  //###############################################
  //  Env Blocks (Non-agent)
  //###############################################
  // Virtual Sequencer
  i2cspibridge_virtual_sequencer  m_vseqr;
  // Environment Configuration
  i2cspibridge_config             m_cfg;
  // Scoreboard Instance
  i2cspibridge_sb                 m_sb;
  // Coverage Instance
  // i2cspibridge_cov                m_cov;

  //###############################################
  //  Agent-related Instances
  //###############################################
  // Agents
  clock_agent_t         m_clock_agent;
  // Agent Configs
  clock_agent_config    m_clock_agent_cfg;

  /******************************************************************************
  *   FUNCTION: Constructor
  ******************************************************************************/
  function new(string name="i2cspibridge_environment", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  /******************************************************************************
  *   FUNCTION: Build Phase
  ******************************************************************************/
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Retrieve configuration
    assert(uvm_config_db#(i2cspibridge_config)::get(this,"","i2cspibridge_config",m_cfg))
    else 
      `uvm_fatal("I2CSPIBRIDGE Env", "Unable to retrieve env config!")

    // Build Virtual Sequencer
    m_vseqr = i2cspibridge_virtual_sequencer::type_id::create("m_vseqr", this);
    m_vseqr.m_cfg = m_cfg;
    `uvm_info("I2CSPIBRIDGE Env", "Virtual Sequencer Built", UVM_HIGH)

    // Build Clock Agent if defined in config
    if(m_cfg.has_clock_agent) begin
      // Agent
      m_clock_agent = clock_agent_t::type_id::create("m_clock_agent", this);
      `uvm_info("I2CSPIBRIDGE Env", "Clock Agent Built", UVM_HIGH)
      // Agent Config
      m_clock_agent_cfg = clock_agent_config::type_id::create("m_clock_agent_cfg", this);
      m_clock_agent_cfg.set_active_passive(UVM_ACTIVE);
      `uvm_info("I2CSPIBRIDGE Env", "Clock Agent Config Built", UVM_HIGH)
      // Set Config
      uvm_config_db#(clock_agent_config)
        ::set(this, "m_clock_agent", "clock_agent_config", m_clock_agent_cfg);
      `uvm_info("I2CSPIBRIDGE Env", "Clock Agent Config Set", UVM_HIGH)
    end

    // Build Scoreboard if defined in config
    if(m_cfg.has_scoreboard) begin
      m_sb = i2cspibridge_sb::type_id::create("m_sb", this);
      `uvm_info("I2CSPIBRIDGE Env", "Scoreboard Built", UVM_HIGH)
    end

    // Build Coverage if defined in config
    if(m_cfg.has_coverage) begin 
      //m_cov = i2cspibridge_cov::type_id::create("m_cov", this);
      `uvm_info("I2CSPIBRIDGE Env", "Coverage Built", UVM_HIGH)
    end
  endfunction : build_phase

  /******************************************************************************
  *   FUNCTION: Connect Phase
  ******************************************************************************/
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction : connect_phase


endclass : i2cspibridge_environment

`endif // _I2CSPIBRIDGE_ENVIRONMENT_SVH