//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2cspibridge_spi_wr_test_seq.svh
// Description  :   I2C-SPI Bridge SPI Write Test Sequence
//-------------------------------------------------------------
`ifndef _I2CSPIBRIDGE_SPI_WR_TEST_SEQ_SVH
  `define _I2CSPIBRIDGE_SPI_WR_TEST_SEQ_SVH

class i2cspibridge_spi_wr_test_seq extends i2cspibridge_base_seq;

  // Register with the factory
  `uvm_object_param_utils_begin(i2cspibridge_spi_wr_test_seq)
  `uvm_object_utils_end

  // Parameters
  localparam realtime TIMEOUT_DELAY = 3ms;
  localparam          WR_ADR_WIDTH  = 6;

  // Randomization variables
  rand logic  [1:0]               spi_slave;
  rand logic                      spi_clk;
  rand logic  [1:0]               spi_cfg;
  rand logic  [WR_ADR_WIDTH-1:0]  wr_addr;
  rand int                        iter;
  rand logic                      reset_bridge;

  // Instantiate the sequences
  i2cspibridge_config_seq             config_seq;
  i2cspibridge_write_data_seq         write_data_seq;
  i2cspibridge_read_data_seq          read_data_seq;

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="i2cspibridge_spi_wr_test_seq");
    super.new(name);
    `uvm_info("I2CSPIBridge SPI Write Test Seq","Constructor Done", UVM_HIGH)
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

    // Randomized SPI Write Test: Loop stimulus until timeout occurs
    
    fork
      // Thread for stimulus
      begin : stimulus_th
        // 
        forever begin
          `uvm_info("SPI WR TEST SEQ", "Randomizing Parameters", UVM_MEDIUM)
          // Randomize test parameters
          randomize_test_params();
          // Configure the RegMap
          `uvm_info("SPI WR TEST SEQ", "Configuring RegMap", UVM_MEDIUM)
          config_seq.dest     = spi_slave;
          config_seq.spi_clk  = spi_clk;
          config_seq.spi_cfg  = spi_cfg;
          config_seq.start(p_sequencer);
          // Do the write
          `uvm_info("SPI WR TEST SEQ", "Writing to SPI SLV", UVM_MEDIUM)
          write_data_seq.addr       = wr_addr;
          write_data_seq.write_iter = iter;
          write_data_seq.start(p_sequencer);
          `uvm_info("SPI WR TEST SEQ", "Finished Write", UVM_MEDIUM)
          // Reset the I2C-SPI Bridge
          if(reset_bridge) begin
            `uvm_info("SPI WR TEST SEQ", "Resetting I2C-SPI Bridge", UVM_MEDIUM)
          end
          change_scl_freq(I2C_STANDARD_MODE);
        end
      end   : stimulus_th

      // Thread for timeout
      begin : timeout_th
        #(TIMEOUT_DELAY);
        `uvm_info("SPI WR TEST SEQ", "Test Ended!", UVM_MEDIUM)
      end   : timeout_th
    join_any
  endtask : body

  /************************************************************************************
  *   TASK: Randomize Test Parameters
  ************************************************************************************/
  task randomize_test_params();
    assert(randomize(wr_addr) with { wr_addr inside {[0:63]}; } );
    assert(randomize(iter) with {iter inside {[0:64]}; } );
    assert(randomize(spi_slave) with { spi_slave inside {2'b01, 2'b10, 2'b11}; } );
    assert(randomize(spi_clk) with {spi_clk dist {1'b0:= 70, 1'b1 := 30}; } );
    assert(randomize(spi_cfg) with {spi_cfg dist {2'b00:=60, [2'b01:2'b11]:=40}; } );
  endtask : randomize_test_params
  
endclass : i2cspibridge_spi_wr_test_seq

`endif // _I2CSPIBRIDGE_SPI_WR_TEST_SEQ_SVH