//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   spi_agent_config.svh
// Description  :   SPI Agent Configuration Object
//-------------------------------------------------------------
`ifndef _SPI_AGENT_CONFIG_SVH
  `define _SPI_AGENT_CONFIG_SVH

class spi_agent_config extends uvm_component;
  `uvm_component_param_utils(spi_agent_config)

  // Active/Passive Agent Setting
  protected uvm_active_passive_enum is_active;

  // Agent Synchronous Setting
  // is_sync=1, Synchronous (i.e. change at clock edge)
  // is_sync=0, Asynchronous
  rand logic is_sync;

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="spi_agent_config", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  /************************************************************
  *   FUNCTION: Set Agent Type (Active/Passive)
  *************************************************************/
  function void set_active_passive(uvm_active_passive_enum active_passive_setting);
    this.is_active = active_passive_setting;
  endfunction : set_active_passive

  /************************************************************
  *   FUNCTION: Get Agent Type (Active/Passive)
  *************************************************************/
  function uvm_active_passive_enum get_active_passive();
    return is_active;
  endfunction : get_active_passive

endclass : spi_agent_config

`endif //_SPI_AGENT_CONFIG_SVH