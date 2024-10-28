`ifndef _I2CSPIBRIDGE_WRITE_DATA_SEQ  
  `define _I2CSPIBRIDGE_WRITE_DATA_SEQ  

class i2cspibridge_write_data_seq extends i2cspibridge_base_seq;
  `uvm_object_param_utils(i2cspibridge_write_data_seq)

  // Configuration variables 
  i2c_byte_t            addr;            // Sets the write address
  rand int              write_iter;      // Sets number of iterations for write 
                                         // write_iter=0 will randomize iterations
  rand i2c_byte_t       write_data[128]; // Randomized i2c data to be written

  constraint cs_iterations{
    soft write_iter inside {16, 24, 32, 48, 64};
  }

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="i2cspibridge_write_data_seq");
    super.new(name);
    write_iter = 0;
  endfunction : new

  /************************************************************
  *   TASK: Body
  *************************************************************/
  task body();
    super.body();
    // Step 1: Send Start byte with write command
    send_i2c_start(1'b0);
    // Step 2: Set the write address
    send_i2c_data(addr);
    // Step 3: if write_iter==0, randomize iterations
    if(write_iter==0)
      assert(randomize(write_iter));
    // Step 4: Randomize write_data and iterate sending
    assert(randomize(write_data));
    for(int i=0; i<write_iter; i++) begin
      send_i2c_data(write_data[i]);
    end
    // Step 5: Send stop condition
    send_i2c_stop();
  endtask : body

endclass : i2cspibridge_write_data_seq

`endif // _I2CSPIBRIDGE_WRITE_DATA_SEQ  