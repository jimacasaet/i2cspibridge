//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   gpio_agent_driver.svh
// Description  :   GPIO Agent Driver
//-------------------------------------------------------------
`ifndef _GPIO_AGENT_DRIVER_SVH
  `define _GPIO_AGENT_DRIVER_SVH

class gpio_agent_driver#(
    parameter SIGNAL_WIDTH,
    parameter N_SIGNAL,
    type      SEQ_ITEM_T
  ) extends uvm_driver#(SEQ_ITEM_T);
  // Register to the factory
  `uvm_component_param_utils(gpio_agent_driver#(SIGNAL_WIDTH, N_SIGNAL, SEQ_ITEM_T))

  // Handle to the virtual interface
  virtual gpio_agent_if#(SIGNAL_WIDTH, N_SIGNAL) m_vif;

  // Handle to the config object
  gpio_agent_config             m_cfg;

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="gpio_agent_driver", uvm_component parent=null);
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
    `uvm_info("GPIO Agent Driver", "Starting Connect Phase", UVM_DEBUG)

    // Retrieve the virtual interface
    assert(uvm_config_db#(virtual gpio_agent_if#(SIGNAL_WIDTH, N_SIGNAL))
      ::get(null, "", "gpio_agent_if", m_vif))
    else  
      `uvm_fatal("GPIO Agent Driver", "Unable to retrieve GPIO VIF!")
    
    `uvm_info("GPIO Agent Driver", "Connect Phase Finished", UVM_DEBUG)
  endfunction : start_of_simulation_phase

  /************************************************************
  *   TASK: Run Phase
  *************************************************************/
  virtual task run_phase(uvm_phase phase);
    
    // Instantiate driver transactions
    SEQ_ITEM_T  txn;

    `uvm_info("GPIO Agent Driver", "Starting Run Phase", UVM_DEBUG);

    // Get transactions in a forever loop
    forever begin
      // Get Seq Item 
      seq_item_port.get_next_item(txn);

      // Print contents of the seq item
      `uvm_info("GPIO Agent Driver", $sformatf("Seq Item:\n%s", txn.convert2string), UVM_HIGH)

      // Do VIF task based on clock operation
      case(txn.gpio_op)
        GPIO_WRITE: begin
          // Start clock with settings in seq item
          m_vif.write_gpio(txn.gpio_signal);
          `uvm_info("GPIO Agent Driver", $sformatf("Written to GPIO"), UVM_DEBUG)
        end

        GPIO_INIT: begin
          // Stop clock
          m_vif.init_gpio(txn.gpio_signal);
          `uvm_info("GPIO Agent Driver", $sformatf("GPIO Initialized"), UVM_DEBUG)
        end

        default: begin
          `uvm_fatal("GPIO Agent Driver", "Unknown GPIO Operation!")
        end
      endcase

      // Set Seq Item to Done
      `uvm_info("GPIO Agent Driver", "Seq Item Done", UVM_DEBUG)
      seq_item_port.item_done(txn);
    end
  endtask : run_phase

endclass : gpio_agent_driver

`endif //_GPIO_AGENT_DRIVER_SVH