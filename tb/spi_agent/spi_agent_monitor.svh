class spi_agent_monitor#(
    parameter BYTE_WIDTH = 1,
    type      SEQ_ITEM_T   = spi_agent_seq_item#(BYTE_WIDTH)
  ) extends uvm_monitor;
  // Register mon to factory
  `uvm_component_param_utils(spi_agent_monitor#(BYTE_WIDTH, SEQ_ITEM_T))

  // Analysis port instance
  uvm_analysis_port#(SEQ_ITEM_T)  m_ap;

  // Configuration instance
  spi_agent_config               m_cfg;

  // VIF instance
  virtual spi_agent_if#(BYTE_WIDTH)  m_vif;

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
    assert(uvm_config_db#(virtual spi_agent_if#(BYTE_WIDTH))
      ::get(this, "", "spi_agent_if", m_vif))
    else  
      `uvm_fatal("SPI Agent Driver", "Unable to retrieve SPI VIF!")
    
    `uvm_info("SPI Monitor", "VIF Set", UVM_DEBUG)
  endfunction : start_of_simulation_phase
  
  /***********************************************************************************
  *   TASK: Run Phase
  ***********************************************************************************/
  virtual task run_phase(uvm_phase phase);
    // Instantiate spi transactions
    SEQ_ITEM_T    spi_txn;

    super.run_phase(phase);

    // FIXME
    // forever begin
    //   // Create txn
    //   spi_txn = new("spi_txn");
    //   // Read txn from VIF
    //   m_vif.read_spi(spi_txn.spi_signal, m_cfg.is_sync);
    //   // Write to AP
    //   m_ap.write(spi_txn);
    //   // Print contents of txn
    //   `uvm_info("SPI Mon Run", spi_txn.convert2string(), UVM_DEBUG)
    // end
  endtask : run_phase

endclass : spi_agent_monitor