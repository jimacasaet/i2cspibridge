`ifndef _I2C_AGENT_REG_ADAPTER_SVH_
  `define _I2C_AGENT_REG_ADAPTER_SVH_

class i2c_agent_reg_adapter extends uvm_reg_adapter;
  `uvm_object_param_utils(i2c_agent_reg_adapter)

  function new(string name="");
    super.new(name);
  endfunction : new

  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    i2c_agent_seq_item  i2c_txn = i2c_agent_seq_item::type_id::create("i2c_txn");

    i2c_txn.i2c_signal = rw.data;
    i2c_txn.i2c_op     = (rw.kind==UVM_READ) ? I2C_READ_BYTE : I2C_WRITE_BYTE;
    // i2c_txn.i2c_adr    = rw.addr;  FIXME: need to rethink i2c addressing in seq item/driver

    return i2c_txn;
  endfunction : reg2bus

  virtual function void bus2reg(uvm_sequence_item  bus_item,
                                ref uvm_reg_bus_op rw);
    i2c_agent_seq_item i2c_txn;

    if(! $cast(i2c_txn, bus_item)) begin
      `uvm_fatal("I2C Agent Reg Adapter", "Failed to cast! bus_item of incorrect type")
    end 
    rw.kind   = (i2c_txn.i2c_op==I2C_READ_BYTE) ? UVM_READ : UVM_WRITE;
    // wr.addr = i2c_txn.i2c_adr; FIXME: i2c addressing in seq item
    rw.data   = i2c_txn.i2c_signal;
    rw.status = UVM_IS_OK;
  endfunction : bus2reg
endclass : i2c_agent_reg_adapter

`endif // _I2C_AGENT_REG_ADAPTER_SVH_