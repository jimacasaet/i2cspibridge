`ifndef _I2CSPIBRIDGE_UVM_REG_BLOCK_SVH
  `define _I2CSPIBRIDGE_UVM_REG_BLOCK_SVH

//############################################################
// I2CSPIBRIDGE CONFIG (Reg Map) REG BLOCK
//############################################################
class i2cspibridge_cfg extends uvm_reg_block;
  `uvm_object_param_utils(i2cspibridge_cfg)

  rand i2cspibridge_cfg_spi_clk spi_clk;
  rand i2cspibridge_cfg_spi_cfg spi_cfg;
  rand i2cspibridge_cfg_uadr_ss uadr_ss[3];
  rand i2cspibridge_cfg_free    free[59];

  /*****************************************************
  *   FUNCTION: New
  *****************************************************/
  function new(string name="i2cspibridge_cfg");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

  /*****************************************************
  *   FUNCTION: Build
  *****************************************************/
  virtual function void build();
    default_map = create_map("", 0, 64, UVM_LITTLE_ENDIAN, 0);
    
    // SPI_CLK
    spi_clk = i2cspibridge_cfg_spi_clk::type_id::create("spi_clk");
    spi_clk.configure(this, null);
    spi_clk.build();
    default_map.add_reg(.rg      (spi_clk), 
                             .offset  (`UVM_REG_ADDR_WIDTH'h0), 
                             .rights  ("RW"), 
                             .unmapped(0)
                            );

    // SPI_CFG
    spi_cfg = i2cspibridge_cfg_spi_cfg::type_id::create("spi_cfg");
    spi_cfg.configure(this, null);
    spi_cfg.build();
    default_map.add_reg(.rg      (spi_cfg), 
                             .offset  (`UVM_REG_ADDR_WIDTH'h1), 
                             .rights  ("RW"), 
                             .unmapped(0)
                            );

    // UADR_SS
    for(int i=0; i<3; i++) begin
      uadr_ss[i] = i2cspibridge_cfg_uadr_ss::type_id::create($sformatf("uadr_ss%0d",i));
      uadr_ss[i].configure(this, null);
      uadr_ss[i].build();
      default_map.add_reg(.rg      (uadr_ss[i]), 
                               .offset  (`UVM_REG_ADDR_WIDTH'h2 + i), 
                               .rights  ("RW"), 
                               .unmapped(0)
                              );
    end

    // OTHER REGS
    for(int i=0; i<59; i++) begin
      free[i] = i2cspibridge_cfg_free::type_id::create($sformatf("free_%0d",i));
      free[i].configure(this, null);
      free[i].build();
      default_map.add_reg(.rg      (free[i]), 
                               .offset  (`UVM_REG_ADDR_WIDTH'h5 + i), 
                               .rights  ("RW"), 
                               .unmapped(0)
                              );
    end

  endfunction : build

endclass : i2cspibridge_cfg

//############################################################
// I2CSPIBRIDGE SSX (SPI Peripheral) REG BLOCK
//############################################################
class i2cspibridge_ss extends uvm_reg_block;
  `uvm_object_param_utils(i2cspibridge_ss)

  rand i2cspibridge_cfg_free data[64];

  function new(string name="");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

  virtual function void build();
    default_map = create_map("", 0, 64, UVM_LITTLE_ENDIAN, 0);

    for(int i=0; i<64; i++) begin
      data[i] = i2cspibridge_cfg_free::type_id::create($sformatf("data_%0d",i));
      data[i].configure(this, null);
      data[i].build();
      default_map.add_reg(.rg      (data[i]), 
                               .offset  (`UVM_REG_ADDR_WIDTH'h0 + i), 
                               .rights  ("RW"), 
                               .unmapped(0)
                              );
    end
  endfunction : build
endclass : i2cspibridge_ss

//############################################################
// I2CSPIBRIDGE TOP REG BLOCK
//############################################################
class i2cspibridge_uvm_reg_block extends uvm_reg_block;
  rand i2cspibridge_cfg cfg;
  rand i2cspibridge_ss  ss0;
  rand i2cspibridge_ss  ss1;
  rand i2cspibridge_ss  ss2;

  `uvm_object_param_utils(i2cspibridge_uvm_reg_block)

  function new(string name="i2cspibridge_uvm_reg_block");
    super.new(name);
  endfunction : new

  function void build();
    
    default_map = create_map("", 0, 64, UVM_LITTLE_ENDIAN, 0);
    
    // RegMap 0x00-0x3F
    cfg         = i2cspibridge_cfg::type_id::create("cfg");
    cfg.configure(this);
    cfg.build();
    default_map.add_submap(cfg.default_map, `UVM_REG_ADDR_WIDTH'h0);

    // SS0 0x40-0x7F
    ss0        = i2cspibridge_ss::type_id::create("ss0");
    ss0.configure(this);
    ss0.build();
    default_map.add_submap(ss0.default_map, `UVM_REG_ADDR_WIDTH'h40);
  endfunction : build
endclass : i2cspibridge_uvm_reg_block

`endif // _I2CSPIBRIDGE_UVM_REG_BLOCK_SVH