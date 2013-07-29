//-*-
 verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2013
// * (utg v0.8)
// ***********************************************************************
// File:   ctx_agent.sv
// Author: bhunter
/* About:  An agent for CTX
 *************************************************************************/

`ifndef __CTX_AGENT_SV__
   `define __CTX_AGENT_SV__

`include "ctx_drv.sv"
`include "ctx_mon.sv"
`include "ctx_sqr.sv"
`include "ctx_item.sv"

// class: agent_c
// CTX Agent
class agent_c extends uvm_agent;
   `uvm_component_utils_begin(ctx_pkg::agent_c)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   // var: is_active
   // When set to UVM_ACTIVE, the sqr and drv will be present.
   uvm_active_passive_enum is_active = UVM_ACTIVE;

   //----------------------------------------------------------------------------------------
   // Group: TLM Ports

   // field: All monitored transactions go out here
   uvm_analysis_port #(item_c) item_port;

   //----------------------------------------------------------------------------------------
   // Group: Fields

   // vars: Driver, monitor, and sequencer
   // Driver, monitor, and sequencer found in most agents
   sqr_c sqr;
   drv_c drv;
   mon_c mon;

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="agent",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   // func: build_phase
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      mon = mon_c::type_id::create("mon", this);
      if(is_active) begin
         drv = drv_c::type_id::create("drv", this);
         sqr = sqr_c::type_id::create("sqr", this);
      end

      item_port = new("item_port", this);
   endfunction : build_phase

   ////////////////////////////////////////////
   // func: connect_phase
   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

      if(is_active)
         drv.seq_item_port.connect(sqr.seq_item_export);

      mon.item_port.connect(item_port);
   endfunction : connect_phase

endclass : agent_c

`endif // __CTX_AGENT_SV__
