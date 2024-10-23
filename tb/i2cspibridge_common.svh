//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2cspibridge_common.svh
// Description  :   I2C-SPI Bridge Commons File
//-------------------------------------------------------------
`ifndef _I2CSPIBRIDGE_COMMON_SVH
  `define _I2CSPIBRIDGE_COMMON_SVH

  //################################
  // Parameter Defs
  //################################
  
  // ----- Clock Agent ----
  parameter N_CLK = 2;
  // Indices for clocks
  parameter CLK_CLK   = 0;
  parameter CLK_SCL   = 1;
  // Clock Periods
  parameter T_CLK     = 200ns;    // 5 MHz
  // I2C Clock Speeds Enum
  typedef enum int {
    I2C_STANDARD_MODE  = 10000,  // 100 KHz
    I2C_FAST_MODE      = 2500,   // 400 KHz
    I2C_FAST_MODE_PLUS = 1000,   // 1.0 MHz
    I2C_HIGHSPEED_MODE = 588     // 1.7 MHz
  } i2c_freq_e;

  parameter i2c_freq_e T_SCL = I2C_FAST_MODE_PLUS;

  // ----- Reset Agent -----
  parameter RESET_WIDTH = 1;
  parameter N_RESET     = 1;
  // Index for reset
  parameter RST_N   = 0;

  // ----- I2C Agent ----
  parameter I2C_BYTE_SIZE = 8;
  parameter I2C_ADDR_SIZE = I2C_BYTE_SIZE-1;
  parameter TARGET_ADDR = 7'b1010101; // I2C Target ID


  //################################
  // Typedefs
  //################################
  
  //----- Sequence Item Typedef -----
  typedef clock_agent_seq_item#(N_CLK)                clock_seq_item_t;
  typedef gpio_agent_seq_item#(RESET_WIDTH, N_RESET)  reset_seq_item_t;

  //----- Sequencer Typedef -----
  typedef clock_agent_sequencer#(clock_seq_item_t)    clock_seqr_t;
  typedef gpio_agent_sequencer#(reset_seq_item_t)     reset_seqr_t;

  //----- Agent Typedef ----
  typedef clock_agent#(N_CLK, clock_seq_item_t)       clock_agent_t;
  typedef gpio_agent#(RESET_WIDTH, N_RESET,
                      reset_seq_item_t)               reset_agent_t;

`endif // _I2CSPIBRIDGE_COMMON_SVH

