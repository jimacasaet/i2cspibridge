//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2c_agent_if.sv
// Description  :   I2C Agent Interface
//-------------------------------------------------------------
`ifndef _I2C_AGENT_AGENT_IF_SV
  `define _I2C_AGENT_AGENT_IF_SV

interface i2c_agent_if#(parameter BYTE_SIZE = 8,
                        parameter ADDR_SIZE = BYTE_SIZE-1)
                       (input scl, 
                        inout sda
                       );
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Maximum frequency of I2C IF is 1.7 MHz
  localparam realtime T_FM_PLUS = 1000ns;

  // Logic array for the clocks
  logic sda_in;
  logic sda_out;
  logic sda_en;
  logic scl_in;

  assign sda = sda_en ? sda_out : 1'bz;
  assign sda_in = sda;
  assign scl_in = scl;

  initial sda_out = 1'b1;

  /********************************************************
  *   Clocking Block
  ********************************************************/
  clocking cb_driver @(negedge scl);
    default input #0 output #0;
    input  sda_in;
    output sda_out;
  endclocking : cb_driver

  clocking cb_monitor @(posedge scl);
    default input #0 output #0;
    input sda_in;
  endclocking : cb_monitor

  clocking cb_scl @(posedge scl or negedge scl);
    default input #0 output #0;
    input scl_in;
  endclocking

  /********************************************************
  *   TASK: Send Start Byte
  *     Sends I2C Device ID followed by Read/Write Bit.
  *
  *   @params[in]     i2c_address : logic [ADDR_SIZE-1:0]
  *                   rw_bit      : logic
  ********************************************************/
  task send_start(input logic [ADDR_SIZE-1:0] i2c_address, input logic rw_bit);
    // Drive the start condition: SDA goes low while SCL is high
    sda_en  <= 1;
    sda_out <= 1;
    @(cb_monitor);
    #(T_FM_PLUS/2);
    sda_out <= 0;
    // Send the address + rw bit
    for(int i=0; i<ADDR_SIZE; i++) begin
      @(cb_driver);
      sda_out <= i2c_address[ADDR_SIZE-1-i];
    end
    @(cb_driver);
    sda_out <= rw_bit;
    @(cb_driver);
    sda_en <= 0;
  endtask : send_start

  /********************************************************
  *   TASK: Write Data to SDA Line
  *     Sends I2C data byte
  *
  *   @params[in]     i2c_data : logic [BYTE_SIZE-1:0]
  ********************************************************/
  task write_sda_byte(input logic [BYTE_SIZE-1:0] i2c_data);
    for(int i=0; i<BYTE_SIZE; i++) begin
      @(cb_driver);
      sda_en <= 1;
      sda_out <= i2c_data[BYTE_SIZE-1-i];
    end
    @(cb_driver);
    sda_en <=0;
  endtask : write_sda_byte

  /********************************************************
  *   TASK: Write Data to SDA Line
  *     Sends I2C data bit
  *
  *   @params[in]     i2c_bit : logic 
  ********************************************************/
  task write_sda_bit(input logic i2c_bit);
    @(cb_driver);
    sda_en <= 1;
    sda_out <= i2c_bit;
    @(cb_driver);
    sda_en <= 0;
  endtask : write_sda_bit

  /********************************************************
  *   TASK: Read I2C Data
  *     Reads I2C Data
  ********************************************************/
  task read_sda(output logic [BYTE_SIZE-1:0] i2c_sda);
    @(cb_scl);
    i2c_sda <= (sda_in===1'bz) ? 1'b1 : sda_in;
  endtask : read_sda

  /********************************************************
  *   TASK: Read I2C SCL
  *     Reads I2C clock
  ********************************************************/
  task read_scl(output logic i2c_scl);
    @(cb_scl);
    i2c_scl <= scl_in;
  endtask : read_scl

  /********************************************************
  *   TASK: Send Stop
  *     Sends Stop Condition
  ********************************************************/
  task send_stop();
    sda_en  <= 1;
    sda_out <= 0;
    @(cb_monitor);
    #(T_FM_PLUS/2);
    sda_out <= 1;
    @(cb_monitor);
  endtask : send_stop

endinterface : i2c_agent_if

`endif //_I2C_AGENT_AGENT_IF_SV