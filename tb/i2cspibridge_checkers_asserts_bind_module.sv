`ifndef _I2CSPIBRIDGE_CHECKERS_ASSERTS_BIND_MODULE_SV
  `define _I2CSPIBRIDGE_CHECKERS_ASSERTS_BIND_MODULE_SV

module i2cspibridge_checkers_asserts(
  input CLK,
  input RST_N,
  input SDA
  input MOSI,
  input SCLK,
);
import uvm_pkg::*;
`include "uvm_macros.svh"

// ASSERT_rst_n_property
// Verifies that I2C SPI Bridge Outputs Reset to 0
property ASSERT_rst_n_property;
  disable iff(0)
  @(CLK)
  !RST_N |->
    !MOSI && !SCLK && SDA;
endproperty : ASSERT_rst_n_property
ASSERT_rst_n: assert property (ASSERT_rst_n_property) else begin
  `uvm_error("ASSERT_rst_n_property", $sformatf("Expected MOSI=0, SCLK=0, and SDA=0. Got MOSI=%0h, SCLK=%0h, SDA=%0h", MOSI, SCLK, SDA) )
end
COV_ASSERT_rst_n_property: cover property (ASSERT_rst_n_property);

// ASSERT_

endmodule : i2cspibridge_checkers_asserts

`endif // _I2CSPIBRIDGE_CHECKERS_ASSERTS_BIND_MODULE_SV