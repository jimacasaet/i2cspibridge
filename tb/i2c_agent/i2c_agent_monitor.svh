class i2c_agent_monitor#(
    parameter BYTE_SIZE = 8,
    parameter ADDR_SIZE = BYTE_SIZE-1,
    type      SEQ_ITEM_T   = i2c_agent_seq_item#(BYTE_SIZE, ADDR_SIZE)
  ) extends uvm_monitor;
  // Register mon to factory
  `uvm_component_param_utils(i2c_agent_monitor#(BYTE_SIZE, ADDR_SIZE, SEQ_ITEM_T))

  // Analysis port instance
  uvm_analysis_port#(SEQ_ITEM_T)  m_ap;

  // Configuration instance
  i2c_agent_config               m_cfg;

  // VIF instance
  virtual i2c_agent_if#(BYTE_SIZE, ADDR_SIZE)  m_vif;

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
  *   FUNCTION: Start of Simulation Phase
  ***********************************************************************************/
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    // Retrieve the virtual interface
    assert(uvm_config_db#(virtual i2c_agent_if#(BYTE_SIZE, ADDR_SIZE))
      ::get(this, "", "i2c_agent_if", m_vif))
    else  
      `uvm_fatal("I2C Agent Driver", "Unable to retrieve I2C VIF!")
    
    `uvm_info("I2C Monitor", "VIF Set", UVM_DEBUG)
  endfunction : start_of_simulation_phase
  
  /***********************************************************************************
  *   TASK: Run Phase
  ***********************************************************************************/
  virtual task run_phase(uvm_phase phase);
    // Instantiate i2c transactions
    SEQ_ITEM_T    i2c_txn;

    super.run_phase(phase);

    forever begin
      // Create txn
      i2c_txn = new("i2c_txn");
      // Read txn from VIF
      m_vif.read_i2c(i2c_txn.i2c_signal, m_cfg.is_sync);
      // Write to AP
      m_ap.write(i2c_txn);
      // Print contents of txn
      `uvm_info("I2C Mon Run", i2c_txn.convert2string(), UVM_DEBUG)
    end
  endtask : run_phase

endclass : i2c_agent_monitor