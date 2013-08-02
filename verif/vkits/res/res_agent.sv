
// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2013
// * (utg v0.10)
// ***********************************************************************
// File:   res_agent.sv
// Author: bhunter
/* About:  Only holds the monitor for now.
 *************************************************************************/

`ifndef __RES_AGENT_SV__
   `define __RES_AGENT_SV__

`include "res_types.sv"
`include "res_mon.sv"

// class: agent_c
// (Description)
class agent_c extends uvm_agent;
   `uvm_component_utils_begin(res_pkg::agent_c)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   // var: is_active
   // Someday maybe this agent will be active, but it's only passive for now
   uvm_active_passive_enum is_active = UVM_PASSIVE;

   //----------------------------------------------------------------------------------------
   // Group: TLM Ports

   // var: result_port
   // Monitored results go out here
   uvm_analysis_port#(result_t) result_port;

   //----------------------------------------------------------------------------------------
   // Group: Fields

   // var: mon
   // Monitor instance
   mon_c mon;

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="[name]",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   // func: build_phase
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      mon = mon_c::type_id::create("mon", this);
      result_port = new("result_port", this);
   endfunction : build_phase

   ////////////////////////////////////////////
   // func: connect_phase
   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      mon.result_port.connect(result_port);
   endfunction : connect_phase

endclass : agent_c

`endif // __RES_AGENT_SV__
