//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011, Caviu
// * (utg v0.3.3)
// ***********************************************************************
// * File        : cn_macros.sv
// * Author      : bhunter
// * Description : UVM common macros
// ***********************************************************************

`ifndef __CN_MACROS_SV__
 `define __CN_MACROS_SV__

   `include "uvm_macros.svh"
   
   //----------------------------------------------------------------------------------------
   // Includes
   `include "cn_msgs.sv"

////////////////////////////////////////////
// macro: `cn_seq_raise
// Handy macro to ensure that all sequences raise the phase's objection if they are the default phase.
   `define cn_seq_raise \
      begin \
         if(starting_phase) \
            starting_phase.raise_objection(this); \
      end

////////////////////////////////////////////
// macro: `cn_seq_drop
// Handy macro to ensure that all sequences drop the phase's objection if they are the default phase.
   `define cn_seq_drop \
      begin \
         if(starting_phase) \
            starting_phase.drop_objection(this); \
      end

////////////////////////////////////////////
// macro: `cn_set_intf
   `define cn_set_intf(TYPE, RSRC, NAME, INSTANCE) \
      begin \
         uvm_resource_db#(TYPE)::set(RSRC, NAME, INSTANCE); \
      end

////////////////////////////////////////////
// macro: `cn_get_intf
   `define cn_get_intf(TYPE, RSRC, NAME, VARIABLE) \
      begin \
         if(!uvm_resource_db#(TYPE)::read_by_name(RSRC, NAME, VARIABLE)) \
            `cn_fatal(("%s.%s interface not found in resource database.", RSRC, NAME)); \
      end

////////////////////////////////////////////
// NOTE: there is sometimes a race with a static object, so if the config DB is not yet set, grab
// the command line and set it.
// macro: `cn_svfcov_new
   `define cn_svfcov_cg_new(CGRP) \
      begin \
        if (!uvm_resource_db#(int)::read_by_name("uvm_root", "coverage_enable", coverage_enable, this)) begin \
           integer svfcov; \
           coverage_enable = ($value$plusargs("svfcov=%d", svfcov)); \
           `cn_dbg(UVM_DEBUG, ("read_by_name was null for uvm_root, coverage_enable, getting from the command line")) \
           uvm_config_db#(int)::set(uvm_top, "*", "coverage_enable", svfcov); \
        end \
        if (coverage_enable) begin \
           CGRP = new(); \
           CGRP.set_inst_name({get_full_name(), ".CGRP"}); \
           `cn_dbg(UVM_DEBUG, ("%s.CGRP will collect coverage during this run.", get_full_name() )) \
        end \
        else \
        `cn_dbg(UVM_DEBUG, ("%s.CGRP will NOT collect coverage during this run.", get_full_name() )) \
      end
         
`endif // __CN_MACROS_SV__