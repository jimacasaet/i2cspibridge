`ifndef _I2CSPIBRIDGE_SEND_DATA_SEQ  
  `define _I2CSPIBRIDGE_SEND_DATA_SEQ  

class i2cspibridge_send_data_seq extends i2cspibridge_base_seq;
  `uvm_object_param_utils(i2cspibridge_send_data_seq)

  // Declare sequence
  

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="i2cspibridge_send_data_seq");
    super.new(name);
  endfunction : new

  /************************************************************
  *   TASK: Body
  *************************************************************/
  task body();
    super.body();
  endtask : body

endclass : i2cspibridge_send_data_seq

`endif // _I2CSPIBRIDGE_SEND_DATA_SEQ  