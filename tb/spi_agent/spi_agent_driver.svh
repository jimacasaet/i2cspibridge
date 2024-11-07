//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   spi_agent_driver.svh
// Description  :   SPI Agent Driver
//-------------------------------------------------------------
`ifndef _SPI_AGENT_DRIVER_SVH
  `define _SPI_AGENT_DRIVER_SVH

class spi_agent_driver#(
    parameter SIGNAL_WIDTH = 1,
    parameter N_SIGNAL     = 1,
    type      SEQ_ITEM_T   = spi_agent_seq_item#(SIGNAL_WIDTH, N_SIGNAL)
  ) extends uvm_driver#(SEQ_ITEM_T);
  // Register to the factory
  `uvm_component_param_utils(spi_agent_driver#(SIGNAL_WIDTH, N_SIGNAL, SEQ_ITEM_T))

  // Handle to the virtual interface
  virtual spi_agent_if#(SIGNAL_WIDTH, N_SIGNAL) m_vif;

  // Handle to the config object
  spi_agent_config             m_cfg;

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="spi_agent_driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  /************************************************************
  *   FUNCTION: Connect Phase
  *************************************************************/
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction : connect_phase

  /************************************************************
  *   FUNCTION: Start of Simulation Phase
  *************************************************************/
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("SPI Agent Driver", "Starting Start of Sim Phase", UVM_DEBUG)

    // Retrieve the virtual interface
    assert(uvm_config_db#(virtual spi_agent_if#(SIGNAL_WIDTH, N_SIGNAL))
      ::get(this, "", "spi_agent_if", m_vif))
    else  
      `uvm_fatal("SPI Agent Driver", "Unable to retrieve SPI VIF!")
    
    `uvm_info("SPI Agent Driver", "Start of Sim Phase Finished", UVM_DEBUG)
  endfunction : start_of_simulation_phase

  /************************************************************
  *   TASK: Run Phase
  *************************************************************/
  virtual task run_phase(uvm_phase phase);
    
    // Instantiate driver transactions
    SEQ_ITEM_T  txn;

    `uvm_info("SPI Agent Driver", "Starting Run Phase", UVM_DEBUG);

    // Get transactions in a forever loop
    forever begin
      // Get Seq Item 
      seq_item_port.get_next_item(txn);

      // Print contents of the seq item
      `uvm_info("SPI Agent Driver", $sformatf("Seq Item:\n%s", txn.convert2string), UVM_HIGH)

      // FIXME Do VIF task based on clock operation
      // case(txn.spi_op)
      //   SPI_WRITE: begin
      //     m_vif.write_spi(txn.spi_signal, m_cfg.is_sync, txn.delay);
      //     `uvm_info("SPI Agent Driver", $sformatf("Written to SPI"), UVM_DEBUG)
      //   end

      //   SPI_INIT: begin
      //     m_vif.init_spi(txn.spi_signal);
      //     `uvm_info("SPI Agent Driver", $sformatf("SPI Initialized"), UVM_DEBUG)
      //   end

      //   default: begin
      //     `uvm_fatal("SPI Agent Driver", "Unknown SPI Operation!")
      //   end
      // endcase

      // Set Seq Item to Done
      `uvm_info("SPI Agent Driver", "Seq Item Done", UVM_DEBUG)
      seq_item_port.item_done(txn);
    end
  endtask : run_phase

endclass : spi_agent_driver

`endif //_SPI_AGENT_DRIVER_SVH