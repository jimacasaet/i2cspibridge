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
  // Declare config object
  i2cspibridge_config m_cfg;
  
  // Declare the P Sequencer
  `uvm_declare_p_sequencer(i2cspibridge_virtual_sequencer)
  // Register with the factory
  `uvm_object_param_utils_begin(i2cspibridge_base_seq)
    `uvm_field_object(m_cfg, UVM_ALL_ON)
  `uvm_object_utils_end

  // Declare subsequencer handles
  clock_seqr_t        clock_seqr;
  reset_seqr_t        reset_seqr;
  i2c_seqr_t          i2c_seqr;

  // Declare sequences
  clock_agent_set_seq#(N_CLK, 
                       clock_seq_item_t)      set_clock_seq;

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
    set_clock_seq = clock_agent_set_seq#(N_CLK, clock_seq_item_t)
                    ::type_id::create("set_clock_seq");

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
    `uvm_info("Stop I2C", $sformatf("Sending I2C Start to I2C Dev = 0x%0h with %0s", TARGET_ADDR, (rw?"READ":"WRITE")), UVM_HIGH)
    send_start_byte_seq.i2c_address = TARGET_ADDR;
    send_start_byte_seq.rw_bit      = rw;
    send_start_byte_seq.start(i2c_seqr);
  endtask : send_i2c_start

  task send_i2c_data(logic [I2C_BYTE_SIZE-1:0] data_in);
    `uvm_info("Write I2C Data", $sformatf("Sending I2C Data = 0x%0h", data_in), UVM_HIGH)
    send_data_byte_seq.i2c_signal = data_in;
    send_data_byte_seq.start(i2c_seqr);
  endtask : send_i2c_data

  task send_i2c_stop();
    `uvm_info("Stop I2C", $sformatf("Sending I2C Stop Condition"), UVM_HIGH)
    send_stop_seq.start(i2c_seqr);
  endtask : send_i2c_stop

  task read_i2c_data(logic ack);
    `uvm_info("Read I2C", $sformatf("Reading I2C with %0s",(ack?"ACK":"NACK")), UVM_HIGH)
    read_byte_seq.i2c_ack = ack;
    read_byte_seq.start(i2c_seqr);
  endtask : read_i2c_data

  task send_i2c_repeated_start(logic rw);
    send_repeated_start_seq.i2c_address = TARGET_ADDR;
    send_repeated_start_seq.rw_bit      = rw;
    send_repeated_start_seq.start(i2c_seqr);
    `uvm_info("Send I2C RS", $sformatf("Sent I2C Repeated Start"), UVM_HIGH)
  endtask : send_i2c_repeated_start

  task change_scl_freq(i2c_freq_e T_SCL);
    set_clock_seq.clock_sel[CLK_CLK]    = 0;
    set_clock_seq.clock_init[CLK_CLK]   = 1;
    set_clock_seq.clock_period[CLK_CLK] = T_CLK;
    set_clock_seq.phase_shift[CLK_CLK]  = 0;
    set_clock_seq.duty_cycle[CLK_CLK]   = 50;

    set_clock_seq.clock_sel[CLK_SCL]    = 1;
    set_clock_seq.clock_init[CLK_SCL]   = 1;
    set_clock_seq.clock_period[CLK_SCL] = T_SCL;
    set_clock_seq.phase_shift[CLK_SCL]  = 0;
    set_clock_seq.duty_cycle[CLK_SCL]   = 50;
    set_clock_seq.start(clock_seqr);
    `uvm_info("Change SCL Freq", $sformatf("Changed the I2C Clock Period to %0d", T_SCL), UVM_HIGH)
  endtask : change_scl_freq
  
endclass : i2cspibridge_base_seq

`endif // _I2CSPIBRIDGE_BASE_SEQ_SVH
