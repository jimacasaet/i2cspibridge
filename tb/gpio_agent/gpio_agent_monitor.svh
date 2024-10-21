class gpio_agent_monitor#(
    parameter SIGNAL_WIDTH,
    parameter N_SIGNAL,
    type      SEQ_ITEM_T
  ) extends uvm_monitor;
  // Register mon to factory
  `uvm_component_param_utils(gpio_agent_monitor#(SIGNAL_WIDTH, N_SIGNAL, SEQ_ITEM_T))

  // Analysis port instance
  uvm_analysis_port#(SEQ_ITEM_T)  m_ap;

  // Configuration instance
  gpio_agent_monitor              m_cfg;

  // VIF instance
  virtual gpio_agent_if#(SIGNAL_WIDTH, N_SIGNAL)  m_vif;

  /***********************************************************************************
  *   FUNCTION: Constructor
  ***********************************************************************************/
  function new(string name="", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  /***********************************************************************************
  *   FUNCTION: Run Phase
  ***********************************************************************************/
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_ap = new("m_ap", this);
  endfunction : build_phase

  /***********************************************************************************
  *   FUNCTION: Run Phase
  ***********************************************************************************/
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    // Retrieve VIF from DB
    assert(uvm_config_db#(virtual gpio_agent_if#(SIGNAL_WIDTH, N_SIG))::get(this, "", "gpio_agent_vif", m_vif))
    else
      `uvm_fatal("GPIO Monitor", "Unable to retrieve VIF")
    
    `uvm_info("GPIO Monitor", "VIF Set", UVM_DEBUG)
  endfunction : start_of_simulation_phase
  
  /***********************************************************************************
  *   TASK: Run Phase
  ***********************************************************************************/
  virtual task run_phase(uvm_phase phase);
    // Instantiate gpio transactions
    SEQ_ITEM_T    gpio_txn;

    super.run_phase(phase);

    forever begin
      // Create txn
      gpio_txn = new("gpio_txn");
      // Read txn from VIF
      m_vif.read_gpio(gpio_txn.gpio_signal);
      // Write to AP
      m_ap.write(gpio_txn);
      // Print contents of txn
      `uvm_info("GPIO Mon Run", gpio_txn.convert2string(), UVM_DEBUG)
    end
  endtask : run_phase

endclass : gpio_agent_monitor