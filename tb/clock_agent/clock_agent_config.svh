//-------------------------------------------------------------
// Create Date  :   2024-10-09
// Author       :   John Rufino Macasaet
// E-Mail       :   j_macasaet@vtech-inc.co.jp
// File Name    :   clock_agent_config.svh
// Description  :   Clock Agent Configuration Object
//-------------------------------------------------------------
`ifndef _CLOCK_AGENT_CONFIG_SVH
  `define _CLOCK_AGENT_CONFIG_SVH

class clock_agent_config extends uvm_component;
  `uvm_component_param_utils(clock_agent_config)

  // Active/Passive Agent Setting
  protected uvm_active_passive_enum is_active;

  /************************************************************
  *   FUNCTION: Constructor
  *************************************************************/
  function new(string name="clock_agent_config", uvm_component parent=null);
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

endclass : clock_agent_config

`endif //_CLOCK_AGENT_CONFIG_SVH