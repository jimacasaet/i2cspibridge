//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   i2cspibridge_base_seq.svh
// Description  :   I2C-SPI Bridge Base Sequence
//-------------------------------------------------------------
`ifndef _I2CSPIBRIDGE_BASE_SEQ_SVH
  `define _I2CSPIBRIDGE_BASE_SEQ_SVH

class i2cspibridge_base_seq extends uvm_sequence;
  // Declare the P Sequencer
  `uvm_declare_p_sequencer(i2cspibridge_virtual_sequencer)
  // Register with the factory
  `uvm_object_param_utils_begin(i2cspibridge_base_seq)
    `uvm_field_object(m_cfg, UVM_ALL_ON)
  `uvm_object_utils_end

  // Declare config object
  i2cspibridge_config m_cfg;

  // Declare subsequencer handles
  clock_seqr_t        clock_seqr;
  reset_seqr_t        reset_seqr;
  i2c_seqr_t          i2c_seqr;

  // Declare sequences
  i2c_agent_send_start_seq#(I2C_BYTE_SIZE,
                            I2C_ADDR_SIZE,
                            i2c_seq_item_t)   send_start_byte_seq;
  i2c_agent_write_byte_seq#(I2C_BYTE_SIZE,
                            I2C_ADDR_SIZE,
                            i2c_seq_item_t)   send_data_byte_seq;
  i2c_agent_send_stop_seq#(I2C_BYTE_SIZE,
                            I2C_ADDR_SIZE,
                            i2c_seq_item_t)   send_stop_seq;
  i2c_agent_read_byte_seq #(I2C_BYTE_SIZE,
                            I2C_ADDR_SIZE,
                            i2c_seq_item_t)   read_byte_seq;
  i2c_agent_send_rs_seq   #(I2C_BYTE_SIZE,
                            I2C_ADDR_SIZE,
                            i2c_seq_item_t)   send_repeated_start_seq;

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="i2cspibridge_base_seq");
    super.new(name);
  endfunction : new

  /************************************************************
  *   TASK: Body
  *************************************************************/
  virtual task body();
    // Create sequences
    send_start_byte_seq = i2c_agent_send_start_seq#(I2C_BYTE_SIZE, I2C_ADDR_SIZE, i2c_seq_item_t)
                            ::type_id::create("send_start_byte_seq");
    send_data_byte_seq = i2c_agent_write_byte_seq#(I2C_BYTE_SIZE, I2C_ADDR_SIZE, i2c_seq_item_t)
                            ::type_id::create("send_data_byte_seq");
    send_stop_seq      = i2c_agent_send_stop_seq#(I2C_BYTE_SIZE, I2C_ADDR_SIZE, i2c_seq_item_t)
                            ::type_id::create("send_stop_seq");
    read_byte_seq      = i2c_agent_read_byte_seq#(I2C_BYTE_SIZE, I2C_ADDR_SIZE, i2c_seq_item_t)
                            ::type_id::create("read_byte_seq");
    send_repeated_start_seq = i2c_agent_send_rs_seq#(I2C_BYTE_SIZE, I2C_ADDR_SIZE, i2c_seq_item_t)
                            ::type_id::create("send_repeated_start_seq");

    // Connect sub-sequencer instances to p_sequencer 
    clock_seqr = p_sequencer.clock_seqr;
    reset_seqr = p_sequencer.reset_seqr;
    i2c_seqr   = p_sequencer.i2c_seqr;
    // Set environment config
    m_cfg = p_sequencer.m_cfg;
  endtask : body

  /************************************************************
  *   Common I2C Tasks
  *************************************************************/

  task send_i2c_start(logic rw);
    send_start_byte_seq.i2c_address = TARGET_ADDR;
    send_start_byte_seq.rw_bit      = rw;
    send_start_byte_seq.start(i2c_seqr);
  endtask : send_i2c_start

  task send_i2c_data(logic [I2C_BYTE_SIZE-1:0] data_in);
    send_data_byte_seq.i2c_signal = data_in;
    send_data_byte_seq.start(i2c_seqr);
  endtask : send_i2c_data

  task send_i2c_stop();
    send_stop_seq.start(i2c_seqr);
  endtask : send_i2c_stop

  task read_i2c_data(logic ack);
    read_byte_seq.i2c_ack = ack;
    read_byte_seq.start(i2c_seqr);
  endtask : read_i2c_data

  task send_i2c_repeated_start(logic rw);
    send_repeated_start_seq.i2c_address = TARGET_ADDR;
    send_repeated_start_seq.rw_bit      = rw;
    send_repeated_start_seq.start(i2c_seqr);
  endtask : send_i2c_repeated_start
  
endclass : i2cspibridge_base_seq

`endif // _I2CSPIBRIDGE_BASE_SEQ_SVH
