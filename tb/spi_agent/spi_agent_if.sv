//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   spi_agent_if.sv
// Description  :   SPI Agent Interface
//-------------------------------------------------------------
`ifndef _SPI_AGENT_AGENT_IF_SV
  `define _SPI_AGENT_AGENT_IF_SV

interface spi_agent_if#(
  parameter SIGNAL_WIDTH = 1, 
  parameter N_SIGNAL     = 1
  ) (input clk_i);
  import uvm_pkg::*;
  `include "uvm_macros.svh"


endinterface : spi_agent_if

`endif //_SPI_AGENT_AGENT_IF_SV