//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2c_slave_agent_driver.svh
// Description  :   I2C Slave Agent Driver
//-------------------------------------------------------------
`ifndef _I2C_SLAVE_AGENT_DRIVER_SVH
  `define _I2C_SLAVE_AGENT_DRIVER_SVH

class i2c_slave_agent_driver#(
    parameter BYTE_SIZE = 8,
    parameter ADDR_SIZE = BYTE_SIZE-1,
    type      SEQ_ITEM_T   = i2c_agent_seq_item#(BYTE_SIZE)
  ) extends uvm_driver#(SEQ_ITEM_T);
  // Register to the factory
  `uvm_component_param_utils(i2c_slave_agent_driver#(BYTE_SIZE, ADDR_SIZE, SEQ_ITEM_T))

  // Handle to the virtual interface
  virtual i2c_agent_if#(BYTE_SIZE, ADDR_SIZE) m_vif;

  // Handle to the config object
  i2c_agent_config             m_cfg;

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="i2c_slave_agent_driver", uvm_component parent=null);
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
    `uvm_info("I2C Slave Agent Driver", "Starting Start of Sim Phase", UVM_DEBUG)

    // Retrieve the virtual interface
    assert(uvm_config_db#(virtual i2c_agent_if#(BYTE_SIZE, ADDR_SIZE))
      ::get(this, "", "i2c_agent_if", m_vif))
    else  
      `uvm_fatal("I2C Slave Agent Driver", "Unable to retrieve I2C VIF!")
    
    `uvm_info("I2C Slave Agent Driver", "Start of Sim Phase Finished", UVM_DEBUG)
  endfunction : start_of_simulation_phase

  /************************************************************
  *   TASK: Run Phase
  *************************************************************/
  virtual task run_phase(uvm_phase phase);
    
    // Instantiate driver transactions
    SEQ_ITEM_T  txn;

    `uvm_info("I2C Slave Agent Driver", "Starting Run Phase", UVM_DEBUG);

    // Get transactions in a forever loop
    forever begin
      // Get Seq Item 
      seq_item_port.get_next_item(txn);

      // Print contents of the seq item
      `uvm_info("I2C Slave Agent Driver", $sformatf("Seq Item:\n%s", txn.convert2string), UVM_HIGH)

      // Do VIF task based on clock operation
      case(txn.i2c_op)
        I2C_SEND_START: begin
          m_vif.send_start(txn.i2c_signal[ADDR_SIZE:1], txn.i2c_signal[0] );
          `uvm_info("I2C Slave Agent Driver", $sformatf("Sent I2C Start Byte"), UVM_DEBUG)
        end

        I2C_WRITE_BYTE: begin
          m_vif.write_sda_byte(txn.i2c_signal);
          `uvm_info("I2C Slave Agent Driver", $sformatf("Sent I2C Data Byte"), UVM_DEBUG)
        end

        I2C_WRITE_BIT: begin
          m_vif.write_sda_bit(txn.i2c_signal[0]);
          `uvm_info("I2C Slave Agent Driver", $sformatf("Sent I2C Data Bit"), UVM_DEBUG)
        end

        I2C_SEND_STOP: begin
          m_vif.send_stop();
          `uvm_info("I2C Slave Agent Driver", $sformatf("Sent I2C Stop Condition"), UVM_DEBUG)
        end

        default: begin
          `uvm_fatal("I2C Slave Agent Driver", "Unknown I2C Operation!")
        end
      endcase

      // Set Seq Item to Done
      `uvm_info("I2C Slave Agent Driver", "Seq Item Done", UVM_DEBUG)
      seq_item_port.item_done(txn);
    end
  endtask : run_phase

endclass : i2c_slave_agent_driver

`endif //_I2C_SLAVE_AGENT_DRIVER_SVH