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
  parameter T_CLK     = 200ns;    // 5MHz
  parameter T_SCL     = 10000ns;  // 100KHz

  //################################
  // Typedefs
  //################################
  
  //----- Sequence Item Typedef -----
  typedef clock_agent_seq_item#(N_CLK)              clock_seq_item_t;

  //----- Sequencer Typedef -----
  typedef clock_agent_sequencer#(clock_seq_item_t)  clock_seqr_t;

  //----- Agent Typedef ----
  typedef clock_agent#(N_CLK, clock_seq_item_t)     clock_agent_t;

`endif // _I2CSPIBRIDGE_COMMON_SVH

