//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2c_slave_agent.svh
// Description  :   I2C Slave Agent 
//-------------------------------------------------------------
`ifndef _I2C_SLAVE_AGENT_SVH
  `define _I2C_SLAVE_AGENT_SVH

class i2c_slave_agent#(
    parameter BYTE_SIZE = 8,
    parameter ADDR_SIZE = BYTE_SIZE-1,
    type      SEQ_ITEM_T   = i2c_agent_seq_item#(BYTE_SIZE)
  ) extends uvm_agent;

  // Register to factory
  `uvm_component_param_utils(i2c_slave_agent#(BYTE_SIZE, ADDR_SIZE, SEQ_ITEM_T))

  // Instantiate config
  i2c_slave_agent_config  m_cfg;

  // Create component typedefs
  typedef i2c_slave_agent_driver#(BYTE_SIZE, ADDR_SIZE, SEQ_ITEM_T)   driver_t;
  typedef i2c_agent_sequencer #(SEQ_ITEM_T)                           seqr_t;  
  typedef i2c_agent_monitor#(BYTE_SIZE, ADDR_SIZE, SEQ_ITEM_T)        monitor_t;

  // Instantiate components
  driver_t                        m_driver;  
  seqr_t                          m_seqr;
  monitor_t                       m_monitor;

  // Instantiate analysis port
  uvm_analysis_port#(SEQ_ITEM_T)  m_ap;

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="i2c_slave_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  /************************************************************
  *   FUNCTION: Build Phase
  *************************************************************/
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("I2C Slave Agent Build Phase", "Starting Build Phase", UVM_DEBUG)

    // Build analysis port
    m_ap = new( "m_ap", this );

    // Check that config has been set
    assert(uvm_config_db#(i2c_slave_agent_config)::get(this, "", "i2c_slave_agent_config", m_cfg))
    else
      `uvm_fatal("I2C Slave Agent", "Failed to get the configuration object")
    
    // Set agent type from config object
    this.is_active = m_cfg.get_active_passive();

    // Build components if UVM_ACTIVE
    if(get_is_active()==UVM_ACTIVE) begin
      m_driver = driver_t::type_id::create("m_driver", this);
      m_seqr   = seqr_t::type_id::create("m_seqr", this);
      `uvm_info("I2C Slave Agent Build Phase", "Driver and Sequencer Built", UVM_DEBUG)
    end
    // Build monitor
    m_monitor = monitor_t::type_id::create("m_monitor", this);

    // Set Config object
    m_driver.m_cfg  = m_cfg;
    m_monitor.m_cfg = m_cfg;

    `uvm_info("I2C Slave Agent Build Phase", "Build Phase Finished", UVM_DEBUG)
  endfunction : build_phase

  /************************************************************
  *   FUNCTION: Connect Phase
  *************************************************************/
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("I2C Slave Agent Connect Phase", "Starting Connect Phase", UVM_DEBUG)

    m_monitor.m_ap.connect(m_ap);
    `uvm_info("I2C Slave Agent Connect Phase", "Mon Connected to AP", UVM_DEBUG)

    // Connect Driver to Sequencer Seq Item Export if UVM_ACTIVE
    if(get_is_active()==UVM_ACTIVE) begin
      m_driver.seq_item_port.connect(m_seqr.seq_item_export);
      `uvm_info("I2C Slave Agent Connect Phase", "Driver Connected to Seq Item Export", UVM_DEBUG)
    end
    `uvm_info("I2C Slave Agent Connect Phase", "Connect Phase Finished", UVM_DEBUG)
  endfunction : connect_phase
endclass : i2c_slave_agent

`endif //_I2C_SLAVE_AGENT_SVH