//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2c_agent_pkg.sv
// Description  :   I2C Agent Package
//-------------------------------------------------------------
`ifndef _I2C_AGENT_PKG_SV
  `define _I2C_AGENT_PKG_SV

package i2c_agent_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Typedef enum for clock operations
  typedef enum {
    I2C_SEND_START,   // I2C Start Condition and Send Address + RW bit
    I2C_WRITE_BYTE,   // I2c Send Data Byte
    I2C_WRITE_BIT,    // I2C Send Data Bit
    I2C_READ_BYTE,    // I2C Read Data Byte
    I2C_SEND_RS,      // I2C Repeated Start Condition
    I2C_SEND_STOP     // I2C Stop Condition
  } i2c_op_e;

  `include "i2c_agent_config.svh"
  `include "i2c_agent_seq_item.svh"
  `include "i2c_agent_sequencer.svh"
  `include "i2c_agent_monitor.svh"
  `include "i2c_agent_reg_adapter.svh"
  // `include "i2c_master_agent_driver.svh"
  // `include "i2c_master_agent_config.svh"
  // `include "i2c_master_agent.svh"
  `include "i2c_slave_agent_driver.svh"
  `include "i2c_slave_agent_config.svh"
  `include "i2c_slave_agent.svh"

  // Common Sequences
  `include "i2c_agent_seq_lib.svh"
endpackage : i2c_agent_pkg
`endif //_I2C_AGENT_PKG_SV