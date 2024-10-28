`ifndef _I2CSPIBRIDGE_READ_DATA_SEQ  
  `define _I2CSPIBRIDGE_READ_DATA_SEQ  

class i2cspibridge_read_data_seq extends i2cspibridge_base_seq;
  `uvm_object_param_utils(i2cspibridge_read_data_seq)

  // Configuration variables 
  i2c_byte_t            addr;            // Sets the write address
  rand int              read_iter;      // Sets number of iterations for write 
                                         // read_iter=0 will randomize iterations
  rand i2c_byte_t       read_data[128];  // Randomized i2c data to be written

  constraint cs_iterations{
    soft read_iter inside {16, 24, 32, 48, 64};
  }

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="i2cspibridge_read_data_seq");
    super.new(name);
    read_iter = 0;
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
    // Step 3: Send repeated start byte with read command
    send_i2c_repeated_start(1'b1);
    // Step 4: if read_iter==0, randomize iterations
    if(read_iter==0)
      assert(randomize(read_iter));
    // Step 5: Randomize read_data and iterate sending
    assert(randomize(read_data));
    for(int i=0; i<read_iter; i++) begin
      read_i2c_data( (i<read_iter ? 1'b1 : 1'b0));
    end
    // Step 6: Send stop condition
    send_i2c_stop();
  endtask : body

endclass : i2cspibridge_read_data_seq

`endif // _I2CSPIBRIDGE_READ_DATA_SEQ  