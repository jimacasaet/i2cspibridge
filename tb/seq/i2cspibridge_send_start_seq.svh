`ifndef _I2CSPIBRIDGE_SEND_START_SEQ  
  `define _I2CSPIBRIDGE_SEND_START_SEQ  

class i2cspibridge_send_start_seq#(
  parameter logic [I2C_ADDR_SIZE-1:0] I2C_SLV_ADDRESS = 7'b1010101
) extends i2cspibridge_base_seq;
  `uvm_object_param_utils(i2cspibridge_send_start_seq#(I2C_SLV_ADDRESS))

  // Declare sequence
  i2c_agent_send_start_seq#(I2C_BYTE_SIZE,
                            I2C_ADDR_SIZE,
                            i2c_seq_item_t)   send_start_byte_seq;

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="i2cspibridge_send_start_seq");
    super.new(name);
  endfunction : new

  /************************************************************
  *   TASK: Body
  *************************************************************/
  task body();
    super.body();
  endtask : body

endclass : i2cspibridge_send_start_seq

`endif // _I2CSPIBRIDGE_SEND_START_SEQ  