`ifndef _I2CSPIBRIDGE_TEST_PKG_SV
  `define _I2CSPIBRIDGE_TEST_PKG_SV

package i2cspibridge_test_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  
  import i2cspibridge_uvm_pkg::*;

  `include "i2cspibridge_base_test.svh"

  // Test Sequences
  `include "i2cspibridge_sanity_test/i2cspibridge_sanity_test_seq.svh"
  `include "i2cspibridge_spi_wr_test/i2cspibridge_spi_wr_test_seq.svh"

  // Tests
  `include "i2cspibridge_sanity_test/i2cspibridge_sanity_test.svh"
  `include "i2cspibridge_spi_wr_test/i2cspibridge_spi_wr_test.svh"

endpackage : i2cspibridge_test_pkg

`endif // _I2CSPIBRIDGE_TEST_PKG_SV