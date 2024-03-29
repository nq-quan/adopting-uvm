
// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.3.3)
// ***********************************************************************
// File:   alutb_env.sv
// Author: bhunter
/* About:  ALUTB Environment
 *************************************************************************/


`ifndef __ALUTB_ENV_SV__
   `define __ALUTB_ENV_SV__

   `include "alutb_cfg.sv"

// class: env_c
// ALUTB Environment class
class env_c extends uvm_env;
   `uvm_component_utils_begin(alutb_pkg::env_c)
      `uvm_field_object(cfg,       UVM_REFERENCE)
      `uvm_field_object(reg_block, UVM_REFERENCE)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   // var: cfg
   // environment configurations
   cfg_c cfg;

   // var: reg_block
   // alu register block (reference to the one in cfg)
   alu_csr_pkg::reg_block_c reg_block;

   //----------------------------------------------------------------------------------------
   // Group: Fields

   // field: Drives the CTX traffic
   ctx_pkg::agent_c ctx_agent;

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="env",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   // func: build_phase
   // Build all the agents
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // build ctx agent
      if(ctx_agent == null)
         ctx_agent = ctx_pkg::agent_c::type_id::create("ctx_agent", this);
   endfunction : build_phase

   ////////////////////////////////////////////
   // func: connect_phase
   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
   endfunction : connect_phase

endclass : env_c

`endif // __ALUTB_ENV_SV__
