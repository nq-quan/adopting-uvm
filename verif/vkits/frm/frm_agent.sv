//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011, Caviu
// * (utg v0.6.3)
// ***********************************************************************
// File:   frm_agent.sv
// Author: bhunter
/* About:  Framer Agent
 *************************************************************************/

`ifndef __FRM_AGENT_SV__
   `define __FRM_AGENT_SV__
   
`include "frm_drv.sv"
`include "frm_mon.sv"
`include "frm_sqr.sv"

// class: agent_c
// The Framer Agent
class agent_c extends uvm_agent;
   `uvm_component_utils_begin(frm_pkg::agent_c)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   // var: is_active
   // When set to UVM_ACTIVE, the sqr and drv will be present.
   uvm_active_passive_enum is_active = UVM_ACTIVE;
   
   //----------------------------------------------------------------------------------------
   // Group: TLM Ports
   
   //----------------------------------------------------------------------------------------
   // Group: Fields

   // vars: Driver, monitor, and sequencer
   // Driver, monitor, and sequencer found in most agents
   sqr_c sqr;
   drv_c drv;
   mon_c mon;
   
   //----------------------------------------------------------------------------------------
   // Methods
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
   endfunction : build_phase

   ////////////////////////////////////////////
   // func: connect_phase
   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

      if(is_active)
         drv.seq_item_port.connect(sqr.seq_item_export);
   endfunction : connect_phase

endclass : agent_c
   
`endif // __FRM_AGENT_SV__
   