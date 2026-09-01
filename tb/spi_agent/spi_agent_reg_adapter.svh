`ifndef _SPI_AGENT_REG_ADAPTER_SVH_
  `define _SPI_AGENT_REG_ADAPTER_SVH_

class spi_agent_reg_adapter#(
    parameter BYTE_SIZE = 8
  ) extends uvm_reg_adapter;
  `uvm_object_param_utils(spi_agent_reg_adapter#(BYTE_SIZE))

  spi_agent_seq_item#(BYTE_SIZE)  spi_txn;

  function new(string name="");
    super.new(name);
  endfunction : new

  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    spi_txn = spi_agent_seq_item#(BYTE_SIZE)::type_id::create("spi_txn");

    spi_txn.spi_signal = rw.data;
    spi_txn.spi_op     = (rw.kind==UVM_READ) ? SPI_READ_BYTE : SPI_WRITE_BYTE;
    // spi_txn.spi_adr    = rw.addr;  FIXME: need to rethink spi addressing in seq item/driver

    return spi_txn;
  endfunction : reg2bus

  virtual function void bus2reg(uvm_sequence_item  bus_item,
                                ref uvm_reg_bus_op rw);
    spi_agent_seq_item spi_txn;

    if(! $cast(spi_txn, bus_item)) begin
      `uvm_fatal("SPI Agent Reg Adapter", "Failed to cast! bus_item of incorrect type")
    end 
    rw.kind   = (spi_txn.spi_op==SPI_READ_BYTE) ? UVM_READ : UVM_WRITE;
    // wr.addr = spi_txn.spi_adr; FIXME: spi addressing in seq item
    rw.data   = spi_txn.spi_signal;
    rw.status = UVM_IS_OK;
  endfunction : bus2reg
endclass : spi_agent_reg_adapter

`endif // _SPI_AGENT_REG_ADAPTER_SVH_