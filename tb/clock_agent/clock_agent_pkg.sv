//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   clock_agent_pkg.sv
// Description  :   Clock Agent Package
//-------------------------------------------------------------
`ifndef _CLOCK_AGENT_PKG_SV
  `define _CLOCK_AGENT_PKG_SV

package clock_agent_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Typedef enum for clock operations
  typedef enum logic {
    CLK_START = 1'b0,   // Clock Start/Reconfig
    CLK_STOP  = 1'b1    // Clock Stop
  } clock_op_e;

  `include "clock_agent_config.svh"
  `include "clock_agent_seq_item.svh"
  `include "clock_agent_sequencer.svh"
  `include "clock_agent_driver.svh"
  `include "clock_agent.svh"

  // Common Sequences
  `include "clock_agent_seq_lib.svh"
endpackage : clock_agent_pkg
`endif //_CLOCK_AGENT_PKG_SV