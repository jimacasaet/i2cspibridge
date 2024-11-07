//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   spi_agent_pkg.sv
// Description  :   SPI Agent Package
//-------------------------------------------------------------
`ifndef _SPI_AGENT_PKG_SV
  `define _SPI_AGENT_PKG_SV

package spi_agent_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Typedef enum for clock operations
  typedef enum logic {
    SPI_WRITE,
    SPI_READ
  } spi_op_e;

  `include "spi_agent_config.svh"
  `include "spi_agent_seq_item.svh"
  `include "spi_agent_sequencer.svh"
  `include "spi_agent_driver.svh"
  `include "spi_agent_monitor.svh"
  `include "spi_agent.svh"

  // Common Sequences
  `include "spi_agent_seq_lib.svh"
endpackage : spi_agent_pkg
`endif //_SPI_AGENT_PKG_SV