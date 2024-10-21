//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   gpio_agent_pkg.sv
// Description  :   GPIO Agent Package
//-------------------------------------------------------------
`ifndef _GPIO_AGENT_PKG_SV
  `define _GPIO_AGENT_PKG_SV

package gpio_agent_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Typedef enum for clock operations
  typedef enum logic {
    GPIO_WRITE = 1'b0,   // GPIO Write Values
    GPIO_INIT  = 1'b1    // GPIO Initialize Values
  } gpio_op_e;

  `include "gpio_agent_config.svh"
  `include "gpio_agent_seq_item.svh"
  `include "gpio_agent_sequencer.svh"
  `include "gpio_agent_driver.svh"
  `include "gpio_agent_monitor.svh"
  `include "gpio_agent.svh"

  // Common Sequences
  `include "gpio_agent_seq_lib.svh"
endpackage : gpio_agent_pkg
`endif //_GPIO_AGENT_PKG_SV