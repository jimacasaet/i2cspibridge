//-------------------------------------------------------------
// Create Date  :   2024-10-25
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2cspibridge_regmap_wr_test_seq.svh
// Description  :   I2C-SPI Bridge RegMap Write Test Sequence
//-------------------------------------------------------------
`ifndef _I2CSPIBRIDGE_REGMAP_WR_TEST_SEQ_SVH
  `define _I2CSPIBRIDGE_REGMAP_WR_TEST_SEQ_SVH

class i2cspibridge_regmap_wr_test_seq extends i2cspibridge_base_seq;

  // Register with the factory
  `uvm_object_param_utils_begin(i2cspibridge_regmap_wr_test_seq)
  `uvm_object_utils_end

  // Parameters
  localparam realtime TEST_TIMEOUT  = 50ms;
  localparam          WR_ADR_WIDTH  = 6;

  // Randomization variables
  rand i2c_freq_e                 i2c_freq;
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
  function new(string name="i2cspibridge_regmap_wr_test_seq");
    super.new(name);
    `uvm_info("RegMap Write Test Seq","Constructor Done", UVM_HIGH)
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

    // Randomized RegMap Write Test: Loop stimulus until timeout occurs
    
    fork
      // Thread for stimulus
      begin : stimulus_th
        // 
        forever begin
          // Step 1: Randomize test parameters
          `uvm_info("RegMap WR TEST SEQ", "Randomizing Parameters", UVM_MEDIUM)
          randomize_test_params();

          // Step 2&3: Configure the RegMap and Send Stop Condition
          `uvm_info("RegMap WR TEST SEQ", "Configuring RegMap", UVM_MEDIUM)
          config_seq.dest     = 0;
          config_seq.start(p_sequencer);

          // Do the write
          `uvm_info("RegMap WR TEST SEQ", "Writing to RegMap", UVM_MEDIUM)
          write_data_seq.addr       = {2'h0, wr_addr};
          write_data_seq.write_iter = iter;
          write_data_seq.start(p_sequencer);
          `uvm_info("RegMap WR TEST SEQ", "Finished Write", UVM_MEDIUM)
          
          // Reset the I2C-SPI Bridge
          if(reset_bridge) begin
            `uvm_info("RegMap WR TEST SEQ", "Resetting I2C-SPI Bridge", UVM_MEDIUM)
          end
          change_scl_freq(I2C_STANDARD_MODE);
        end
      end   : stimulus_th

      // Thread for timeout
      begin : timeout_th
        #(TEST_TIMEOUT );
        `uvm_info("RegMap WR TEST SEQ", "Test Ended!", UVM_MEDIUM)
      end   : timeout_th
    join_any
  endtask : body

  /************************************************************************************
  *   TASK: Randomize Test Parameters
  ************************************************************************************/
  task randomize_test_params();
    assert(randomize(i2c_freq));
    assert(randomize(wr_addr) with { wr_addr inside {[0:63]}; } );
    assert(randomize(iter) with {iter inside {[0:64]}; } );
    assert(randomize(reset_bridge) with {reset_bridge dist {1'b0 := 60, 1'b1 := 40}; });
    //Change the I2C Clock Frequency
    change_scl_freq(i2c_freq);
    //Print the randomized parameters
    `uvm_info("RegMap WR Test Seq", $sformatf("Rand Test Params\ni2c_freq=%0s\nwr_addr=%0h\niter=%0d\nreset_bridge=%0s",
              i2c_freq.name, wr_addr, iter,(reset_bridge?"TRUE":"FALSE")), UVM_LOW)
  endtask : randomize_test_params
  
endclass : i2cspibridge_regmap_wr_test_seq

`endif // _I2CSPIBRIDGE_REGMAP_WR_TEST_SEQ_SVH