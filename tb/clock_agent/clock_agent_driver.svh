//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   clock_agent_driver.svh
// Description  :   Clock Agent Driver
//-------------------------------------------------------------
`ifndef _CLOCK_AGENT_DRIVER_SVH
  `define _CLOCK_AGENT_DRIVER_SVH

class clock_agent_driver#(
    parameter N_CLK = 1,
    type      SEQ_ITEM_T
  ) extends uvm_driver#(SEQ_ITEM_T);
  // Register to the factory
  `uvm_component_param_utils(clock_agent_driver#(N_CLK, SEQ_ITEM_T))

  // Handle to the virtual interface
  virtual clock_agent_if#(N_CLK) m_vif;

  // Handle to the config object
  clock_agent_config             m_cfg;

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="clock_agent_driver", uvm_component parent=null);
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
    `uvm_info("Clock Agent Driver", "Starting Connect Phase", UVM_DEBUG)

    // Retrieve the virtual interface
    assert(uvm_config_db#(virtual clock_agent_if#(N_CLK))
      ::get(null, "", "clock_agent_if", m_vif))
    else  
      `uvm_fatal("Clock Agent Driver", "Unable to retrieve Clock VIF!")
    
    `uvm_info("Clock Agent Driver", "Connect Phase Finished", UVM_DEBUG)
  endfunction : start_of_simulation_phase

  /************************************************************
  *   TASK: Run Phase
  *************************************************************/
  virtual task run_phase(uvm_phase phase);
    
    // Instantiate driver transactions
    SEQ_ITEM_T  txn;

    `uvm_info("Clock Agent Driver", "Starting Run Phase", UVM_DEBUG);

    // Get transactions in a forever loop
    forever begin
      // Get Seq Item 
      seq_item_port.get_next_item(txn);

      // Print contents of the seq item
      `uvm_info("Clock Agent Driver", $sformatf("Seq Item:\n%s", txn.convert2string), UVM_HIGH)

      // Do VIF task based on clock operation
      case(txn.clock_op)
        CLK_START: begin
          // Start clock with settings in seq item
          m_vif.start(
            txn.clock_sel, 
            txn.clock_init, 
            txn.clock_period, 
            txn.phase_shift,
            txn.duty_cycle
          );
          `uvm_info("Clock Agent Driver", $sformatf("Clock Started/Set"), UVM_HIGH)
        end

        CLK_STOP: begin
          // Stop clock
          m_vif.stop(txn.clock_sel);
          `uvm_info("Clock Agent Driver", $sformatf("Clock Stopped"), UVM_HIGH)
        end

        default: begin
          `uvm_fatal("Clock Agent Driver", "Unknown Clock Operation!")
        end
      endcase

      // Set Seq Item to Done
      `uvm_info("Clock Agent Driver", "Seq Item Done", UVM_HIGH)
      seq_item_port.item_done(txn);
    end
  endtask : run_phase

endclass : clock_agent_driver

`endif //_CLOCK_AGENT_DRIVER_SVH