//-*-
 verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.6.3)
// ***********************************************************************
// File:   frm_env.sv
// Author: bhunter
/* About:  <description>
 *************************************************************************/

`ifndef __FRM_ENV_SV__
   `define __FRM_ENV_SV__

`include "frm_agent.sv"
`include "frm_frame.sv"

// class: env_c
// FRM Testbench Environment
class env_c extends uvm_env;
   `uvm_component_utils_begin(frm_pkg::env_c)
      `uvm_field_object(cfg,       UVM_REFERENCE)
      `uvm_field_object(reg_block, UVM_REFERENCE)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   // var: cfg
   // environment configurations
   cfg_c cfg;

   // var: reg_block
   // alutb register block (reference to the one in cfg)
   alu_csr_pkg::reg_block_c reg_block;

   // var: is_active
   uvm_active_passive_enum is_active = UVM_ACTIVE;

   //----------------------------------------------------------------------------------------
   // Group: Fields

   // var: alu_agent
   // The ALU agent
   alu_pkg::agent_c alu_agent;

   // field: Drives the CTX traffic
   ctx_pkg::agent_c ctx_agent;

   // var: frm_agent
   // The FRM agent
   agent_c frm_agent;

   //----------------------------------------------------------------------------------------
   // Methods
   function new(string name="env",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   // func: build_phase
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // build frm agent
      frm_agent = agent_c::type_id::create("frm_agent", this);

      // create the ALU agent
      uvm_config_db#(int)::set(this, "alu_agent.drv",    "is_active",       UVM_ACTIVE);
      alu_agent = alu_pkg::agent_c::type_id::create("alu_agent", this);

      // build ctx agent
      ctx_agent = ctx_pkg::agent_c::type_id::create("ctx_agent", this);
   endfunction : build_phase

   ////////////////////////////////////////////
   // func: connect_phase
   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
   endfunction : connect_phase

endclass : env_c

`endif // __FRM_ENV_SV__
