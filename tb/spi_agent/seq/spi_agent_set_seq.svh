//-------------------------------------------------------------
// Create Date  :   2024-11-07
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   spi_agent_set_seq.svh
// Description  :   SPI Agent Set Sequence
//-------------------------------------------------------------
`ifndef _SPI_AGENT_SET_SEQ_SVH
  `define _SPI_AGENT_SET_SEQ_SVH
class spi_agent_set_seq#(
    parameter BYTE_WIDTH,
    type      SEQ_ITEM_T= spi_agent_seq_item#(BYTE_WIDTH)
  ) extends spi_agent_base_seq#(SEQ_ITEM_T);
  `uvm_object_param_utils(spi_agent_set_seq#(BYTE_WIDTH,SEQ_ITEM_T))

  // Define Variables to set Seq Item manually
  logic [BYTE_WIDTH-1:0] spi_signal;

  /******************************************************
  *   FUNCTION: Constructor
  ******************************************************/
  function new(string name="spi_agent_set_seq");
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

    // Create clocks with defined settings in the variables
    start_item(command);
      command.spi_op = SPI_WRITE;
      // FIXME foreach(command.spi_signal[i]) begin
      //   command.spi_signal[i] = spi_signal[i];
      // end
    finish_item(command);
  endtask : body
  
endclass : spi_agent_set_seq
`endif // _SPI_AGENT_SET_SEQ_SVH