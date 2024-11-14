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
    output mosi;
  endclocking : cb_driver_pos

  clocking cb_driver_neg@(negedge sclk);
    default input #0 output #0;
    input miso;
    output mosi;
  endclocking : cb_driver_neg

  clocking cb_mon_pos@(posedge sclk);
    default input #0 output #0;
    input miso, mosi, ss0, ss1, ss2;
  endclocking : cb_mon_pos

  clocking cb_mon_neg@(negedge sclk);
    default input #0 output #0;
    input miso, mosi, ss0, ss1, ss2;
  endclocking : cb_mon_neg

  // Initialize SPI Mode to 'b00
  initial begin
    cpol = 0;
    cpha = 0;
  end

  // Clock sampling depending on SPI Mode
  task clock_edge();
    if(!cpha) begin
      if(!cpol)
        @(cb_driver_pos);
      else
        @(cb_driver_neg);
    end else begin
      if(!cpol)
        @(cb_driver_neg);
      else
        @(cb_driver_pos);
    end
  endtask : clock_edge

  /***************************************************
  *   TASK: Write SPI Byte to the Bus
  *   
  ***************************************************/
  task write_miso(input [BYTE_WIDTH-1:0] write_data);
    foreach(write_data[i]) begin
      clock_edge();
      miso <= write_data[i];
    end
  endtask : write_miso

  /***************************************************
  *   TASK: Read SPI Byte to the Bus
  ***************************************************/
  task read_mosi(output [BYTE_WIDTH-1:0] read_data);
    foreach(read_data[i]) begin
      clock_edge();
      read_data[i] <= mosi;
    end
  endtask : read_mosi

  /***************************************************
  *   TASK: Read SPI Byte to the Bus
  ***************************************************/
  task read_miso(output [BYTE_WIDTH-1:0] read_data);
    foreach(read_data[i]) begin
      clock_edge();
      read_data[i] <= miso;
    end
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