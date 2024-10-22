//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2cspibridge_uvm_pkg.sv
// Description  :   I2C-SPI Bridge UVM Package
//-------------------------------------------------------------
`ifndef _I2CSPIBRIDGE_UVM_PKG_SV
  `define _I2CSPIBRIDGE_UVM_PKG_SV
package i2cspibridge_uvm_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  import clock_agent_pkg::*;
  import gpio_agent_pkg::*;

  // TODO: DPI
  // import "DPI-C" function void c_py_init();
  // import "DPI-C" function void c_py_final();
  // import "DPI-C" function void c_py_gen_packet(input bit[63:0] mode, output bit[2047:0] pkt, output bit [7:0] len);

  typedef class i2cspibridge_virtual_sequencer;
  typedef class i2cspibridge_config;
  typedef class i2cspibridge_sb;

  `include "i2cspibridge_common.svh"
  `include "i2cspibridge_config.svh"
  `include "i2cspibridge_virtual_sequencer.svh"
  `include "i2cspibridge_sb.svh"
  `include "i2cspibridge_coverage.svh"
  `include "i2cspibridge_environment.svh"

  // Sequence and Sequence Library
  `include "i2cspibridge_base_seq.svh"
  `include "i2cspibridge_seq_lib.svh"

  // Base Test
  `include "i2cspibridge_base_test.svh"
endpackage : i2cspibridge_uvm_pkg
`endif // _I2CSPIBRIDGE_UVM_PKG_SV