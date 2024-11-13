`ifndef _I2CSPIBRIDGE_UVM_REG_SVH
  `define _I2CSPIBRIDGE_UVM_REG_SVH

//############################################################
// SPI_CLK Register
//############################################################
class i2cspibridge_cfg_spi_clk extends uvm_reg;
  rand uvm_reg_field clk;

  `uvm_object_param_utils(i2cspibridge_cfg_spi_clk)

  /*****************************************************
  *   FUNCTION: New
  *****************************************************/
  function new(string name="i2cspibridge_cfg_spi_clk");
    super.new(name, 8, UVM_NO_COVERAGE);
  endfunction : new

  /*****************************************************
  *   FUNCTION: Build
  *****************************************************/
  virtual function void build();
    this.clk = uvm_reg_field::type_id::create("clk");
    this.clk.configure( .parent                 (this),
                        .size                   (1),
                        .lsb_pos                (0),
                        .access                 ("RW"),
                        .volatile               (0),
                        .reset                  (0),
                        .has_reset              (1),
                        .is_rand                (0),
                        .individually_accessible(0)
                      );
  endfunction : build
endclass : i2cspibridge_cfg_spi_clk

//############################################################
// SPI_CFG Register
//############################################################
class i2cspibridge_cfg_spi_cfg extends uvm_reg;
  rand uvm_reg_field cpha;
  rand uvm_reg_field cpol;

  `uvm_object_param_utils(i2cspibridge_cfg_spi_cfg)

  /*****************************************************
  *   FUNCTION: New
  *****************************************************/
  function new(string name="i2cspibridge_cfg_spi_cfg");
    super.new(name, 8, UVM_NO_COVERAGE);
  endfunction : new

  /*****************************************************
  *   FUNCTION: Build
  *****************************************************/
  virtual function void build();
    this.cpha = uvm_reg_field::type_id::create("cpha");
    this.cpha.configure(.parent                 (this),
                        .size                   (1),
                        .lsb_pos                (0),
                        .access                 ("RW"),
                        .volatile               (0),
                        .reset                  (0),
                        .has_reset              (1),
                        .is_rand                (0),
                        .individually_accessible(0)
                      );

    this.cpol = uvm_reg_field::type_id::create("cpol");
    this.cpol.configure(.parent                 (this),
                        .size                   (1),
                        .lsb_pos                (1),
                        .access                 ("RW"),
                        .volatile               (0),
                        .reset                  (0),
                        .has_reset              (1),
                        .is_rand                (0),
                        .individually_accessible(0)
                      );
  endfunction : build
endclass : i2cspibridge_cfg_spi_cfg

//############################################################
//  UADR_SS Register
//############################################################
class i2cspibridge_cfg_uadr_ss extends uvm_reg;
  rand uvm_reg_field uadr;
  rand uvm_reg_field data;

  `uvm_object_param_utils(i2cspibridge_cfg_uadr_ss)

  /*****************************************************
  *   FUNCTION: New
  *****************************************************/
  function new(string name="i2cspibridge_cfg_uadr_ss");
    super.new(name, 8, UVM_NO_COVERAGE);
  endfunction : new

  /*****************************************************
  *   FUNCTION: Build
  *****************************************************/
  virtual function void build();
    this.uadr = uvm_reg_field::type_id::create("uadr");
    this.uadr.configure(.parent                 (this),
                        .size                   (2),
                        .lsb_pos                (6),
                        .access                 ("RW"),
                        .volatile               (0),
                        .reset                  (0),
                        .has_reset              (1),
                        .is_rand                (0),
                        .individually_accessible(0)
                       );

    this.data = uvm_reg_field::type_id::create("data");
    this.data.configure(.parent                 (this),
                        .size                   (6),
                        .lsb_pos                (0),
                        .access                 ("RW"),
                        .volatile               (0),
                        .reset                  (0),
                        .has_reset              (1),
                        .is_rand                (0),
                        .individually_accessible(0)
                       );
  endfunction : build
endclass : i2cspibridge_cfg_uadr_ss

//############################################################
//  I2CSPIBRIDGE Free Reg
//############################################################
class i2cspibridge_cfg_free extends uvm_reg;
  rand uvm_reg_field data;

  `uvm_object_param_utils(i2cspibridge_cfg_free)

  /*****************************************************
  *   FUNCTION: New
  *****************************************************/
  function new(string name="i2cspibridge_cfg_free");
    super.new(name, 8, UVM_NO_COVERAGE);
  endfunction : new

  /*****************************************************
  *   FUNCTION: Build
  *****************************************************/
  virtual function void build();
    this.data = uvm_reg_field::type_id::create("data");
    this.data.configure(.parent                 (this),
                        .size                   (8),
                        .lsb_pos                (0),
                        .access                 ("RW"),
                        .volatile               (0),
                        .reset                  (0),
                        .has_reset              (1),
                        .is_rand                (0),
                        .individually_accessible(0)
                       );
  endfunction : build
endclass : i2cspibridge_cfg_free

`endif // _I2CSPIBRIDGE_UVM_REG_SVH