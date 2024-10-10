//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   clock_agent.svh
// Description  :   Clock Agent 
//-------------------------------------------------------------
`ifndef _CLOCK_AGENT_SVH
  `define _CLOCK_AGENT_SVH

class clock_agent#(
    parameter N_CLK      = 1,
    type      SEQ_ITEM_T = clock_agent_seq_item#(N_CLK)
  ) extends uvm_agent;

  // Register to factory
  `uvm_component_param_utils(clock_agent#(N_CLK))

  // Instantiate config
  clock_agent_config  m_cfg;

  // Create component typedefs
  typedef clock_agent_driver#(N_CLK, SEQ_ITEM_T)  driver_t;
  typedef clock_agent_sequencer #(SEQ_ITEM_T)     seqr_t;  

  // Instantiate components
  driver_t                        m_driver;  
  seqr_t                          m_seqr;

  // Instantiate analysis port
  uvm_analysis_port#(SEQ_ITEM_T)  m_ap;

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="clock_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  /************************************************************
  *   FUNCTION: Build Phase
  *************************************************************/
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("Clock Agent Build Phase", "Starting Build Phase", UVM_DEBUG)

    // Check that config has been set
    assert(uvm_config_db#(clock_agent_config)::get(this, "", "clock_agent_config", m_cfg))
    else
      `uvm_fatal("Clock Agent", "Failed to get the configuration object")
    
    // Set agent type from config object
    this.is_active = m_cfg.get_active_passive();

    // Build components if UVM_ACTIVE
    if(get_is_active()==UVM_ACTIVE) begin
      m_driver = driver_t::type_id::create("m_driver", this);
      m_seqr   = seqr_t::type_id::create("m_seqr", this);
    end
    `uvm_info("Clock Agent Build Phase", "Build Phase Finished", UVM_DEBUG)
  endfunction : build_phase

  /************************************************************
  *   FUNCTION: Connect Phase
  *************************************************************/
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("Clock Agent Build Phase", "Starting Connect Phase", UVM_DEBUG)
    // Connect Driver to Sequencer Seq Item Export if UVM_ACTIVE
    if(get_is_active()==UVM_ACTIVE) begin
      m_driver.seq_item_port.connect(m_seqr.seq_item_export);
    end
    `uvm_info("Clock Agent Build Phase", "Connect Phase Finished", UVM_DEBUG)
  endfunction : connect_phase
endclass : clock_agent

`endif //_CLOCK_AGENT_SVH