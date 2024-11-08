//-------------------------------------------------------------
// Create Date  :   2024-11-07
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   spi_agent_if.sv
// Description  :   SPI Agent Interface
//-------------------------------------------------------------
`ifndef _SPI_AGENT_AGENT_IF_SV
  `define _SPI_AGENT_AGENT_IF_SV

interface spi_agent_if#(
  parameter BYTE_WIDTH = 8
  ) (input sclk);
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // SPI Pinout
  logic mosi;
  logic miso;
  logic ss0;
  logic ss1;
  logic ss2;
  // SPI Config
  logic cpha, cpol;


  /***************************************************
  *   CLOCKING BLOCK
  *       To accommodate the different clock modes
  *       supported by the SPI protocol.
  ***************************************************/
  clocking cb_driver_pos@(posedge sclk);
    default input #0 output #0;
    input miso;
    output mosi, ss0, ss1, ss2;
  endclocking : cb_driver_pos

  clocking cb_driver_neg@(negedge sclk);
    default input #0 output #0;
    input miso;
    output mosi, ss0, ss1, ss2;
  endclocking : cb_driver_neg

  clocking cb_mon_pos@(posedge sclk);
    default input #0 output #0;
    input miso, mosi, ss0, ss1, ss2;
  endclocking : cb_mon_pos

  clocking cb_mon_neg@(negedge sclk);
    default input #0 output #0;
    input miso, mosi, ss0, ss1, ss2;
  endclocking : cb_mon_neg

  /***************************************************
  *   TASK: Write SPI Byte to the Bus
  *   
  ***************************************************/
  task write_mosi(input [BYTE_WIDTH-1:0] write_data);

  endtask : write_mosi

  /***************************************************
  *   TASK: Read SPI Byte to the Bus
  ***************************************************/
  task read_mosi(output [BYTE_WIDTH-1:0] read_data);

  endtask : read_mosi

  /***************************************************
  *   TASK: Read SPI Byte to the Bus
  ***************************************************/
  task read_miso(output [BYTE_WIDTH-1:0] read_data);

  endtask : read_miso

  /***************************************************
  *   TASK: Set SPI CPOL/CPHA Configuration
  ***************************************************/
  task set_spi_cfg(input cpol_cfg, input cpha_cfg);
    cpol = cpol_cfg;
    cpha = cpha_cfg;
  endtask : set_spi_cfg

endinterface : spi_agent_if

`endif //_SPI_AGENT_AGENT_IF_SV