//-------------------------------------------------------------
// Create Date  :   2024-10-25
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2cspibridge_regmap_rd_test_seq.svh
// Description  :   I2C-SPI Bridge SPI Read Test Sequence
//-------------------------------------------------------------
`ifndef _I2CSPIBRIDGE_REGMAP_RD_TEST_SEQ_SVH
  `define _I2CSPIBRIDGE_REGMAP_RD_TEST_SEQ_SVH

class i2cspibridge_regmap_rd_test_seq extends i2cspibridge_base_seq;

  // Register with the factory
  `uvm_object_param_utils_begin(i2cspibridge_regmap_rd_test_seq)
  `uvm_object_utils_end

  // Parameters
  localparam realtime TEST_TIMEOUT  = 50ms;
  localparam          WR_ADR_WIDTH  = 6;

  // Randomization variables
  rand i2c_freq_e                 i2c_freq;
  rand logic  [1:0]               spi_slave;
  rand logic                      spi_clk;
  rand logic  [1:0]               spi_cfg;
  rand logic  [WR_ADR_WIDTH-1:0]  rd_addr;
  rand int                        iter;
  rand logic                      reset_bridge;

  // Instantiate the sequences
  i2cspibridge_config_seq             config_seq;
  i2cspibridge_write_data_seq         write_data_seq;
  i2cspibridge_read_data_seq          read_data_seq;

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="i2cspibridge_regmap_rd_test_seq");
    super.new(name);
    `uvm_info("SPI Read Test Seq","Constructor Done", UVM_HIGH)
  endfunction : new

  /************************************************************
  *   TASK: Body
  *************************************************************/
  task body();
    // Build the sequences
    config_seq      = i2cspibridge_config_seq::type_id::create("config_seq");
    write_data_seq  = i2cspibridge_write_data_seq::type_id::create("write_data_seq");
    read_data_seq   = i2cspibridge_read_data_seq::type_id::create("read_data_seq");
    
    super.body();

    // Randomized SPI Read Test: Loop stimulus until timeout occurs
    
    fork
      // Thread for stimulus
      begin : stimulus_th
        // 
        forever begin
          // Step 1: Randomize test parameters
          `uvm_info("RegMap RD TEST SEQ", "Randomizing Parameters", UVM_MEDIUM)
          randomize_test_params();

          // Step 2&3: Configure the RegMap and Send Stop Condition
          `uvm_info("RegMap RD TEST SEQ", "Configuring RegMap", UVM_MEDIUM)
          config_seq.dest     = 2'b00;
          config_seq.spi_clk  = spi_clk;
          config_seq.spi_cfg  = spi_cfg;
          config_seq.start(p_sequencer);

          // Step 4, 5, & 6: Do the read
          `uvm_info("RegMap RD TEST SEQ", "Reading from SPI SLV", UVM_MEDIUM)
          read_data_seq.addr       = {spi_slave, rd_addr};
          read_data_seq.read_iter = iter;
          read_data_seq.start(p_sequencer);
          `uvm_info("RegMap RD TEST SEQ", "Finished Read", UVM_MEDIUM)
          
          // Step 8: Reset the I2C-SPI Bridge
          if(reset_bridge) begin
            `uvm_info("RegMap RD TEST SEQ", "Resetting I2C-SPI Bridge", UVM_MEDIUM)
          end
          // change_scl_freq(I2C_STANDARD_MODE);
        end
      end   : stimulus_th

      // Thread for timeout
      begin : timeout_th
        #(TEST_TIMEOUT );
        `uvm_info("RegMap RD TEST SEQ", "Test Ended!", UVM_MEDIUM)
      end   : timeout_th
    join_any
  endtask : body

  /************************************************************************************
  *   TASK: Randomize Test Parameters
  ************************************************************************************/
  task randomize_test_params();
    assert(randomize(i2c_freq));
    assert(randomize(rd_addr) with { rd_addr inside {[0:63]}; } );
    assert(randomize(iter) with {iter inside {[0:64]}; } );
    assert(randomize(spi_slave) with { spi_slave inside {2'b01, 2'b10, 2'b11}; } );
    assert(randomize(spi_clk) with {spi_clk dist {1'b0:= 70, 1'b1 := 30}; } );
    assert(randomize(spi_cfg) with {spi_cfg dist {2'b00:=60, [2'b01:2'b11]:=0}; } );
    assert(randomize(reset_bridge) with {reset_bridge dist {1'b0 := 60, 1'b1 := 40}; });
    //Change the I2C Clock Frequency
    change_scl_freq(i2c_freq);
    //Print the randomized parameters
    `uvm_info("RegMap RD Test Seq", $sformatf("Rand Test Params\ni2c_freq=%0s\nrd_addr=%0h\niter=%0d\nspi_slv=%0b\nspi_clk=%0h\nspi_cfg=%0b\nreset_bridge=%0s",
              i2c_freq.name, rd_addr, iter, spi_slave, spi_clk, spi_cfg, (reset_bridge?"TRUE":"FALSE")), UVM_LOW)
  endtask : randomize_test_params
  
endclass : i2cspibridge_regmap_rd_test_seq

`endif // _I2CSPIBRIDGE_REGMAP_RD_TEST_SEQ_SVH