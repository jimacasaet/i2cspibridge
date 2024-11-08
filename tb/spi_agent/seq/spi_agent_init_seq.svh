//-------------------------------------------------------------
// Create Date  :   2024-11-07
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   spi_agent_init_seq.svh
// Description  :   SPI Agent Initialize Sequence
//-------------------------------------------------------------
`ifndef _SPI_AGENT_INIT_SEQ_SVH
  `define _SPI_AGENT_INIT_SEQ_SVH
class spi_agent_init_seq#(
    parameter BYTE_WIDTH,
    type      SEQ_ITEM_T= spi_agent_seq_item#(BYTE_WIDTH)
  ) extends spi_agent_base_seq#(SEQ_ITEM_T);
  `uvm_object_param_utils(spi_agent_init_seq#(BYTE_WIDTH, SEQ_ITEM_T))

  // Define Variables to init Seq Item manually
  logic [BYTE_WIDTH-1:0] spi_signal;

  /******************************************************
  *   FUNCTION: Constructor
  ******************************************************/
  function new(string name="spi_agent_init_seq");
    super.new(name);
  endfunction : new

  /******************************************************
  *   TASK: Body
  ******************************************************/
  task body();
    // Instantiate the sequence item
    SEQ_ITEM_T  command;

    // Create the sequence item
    command = SEQ_ITEM_T::type_id::create("command");

    // Create clocks with defined init settings in the variables
    start_item(command);
      command.spi_op = SPI_WRITE;
      // FIXME foreach(command.spi_signal[i]) begin
      //   command.spi_signal[i] = 0;
      // end
    finish_item(command);
  endtask : body
  
endclass : spi_agent_init_seq
`endif // _SPI_AGENT_INIT_SEQ_SVH