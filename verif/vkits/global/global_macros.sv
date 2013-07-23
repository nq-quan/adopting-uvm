//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.3.3)
// ***********************************************************************
// * File        : global_macros.sv
// * Author      : jschroeder
// * Description : Global package macros
// ***********************************************************************

`ifndef __GLOBAL_MACROS_SV__
 `define __GLOBAL_MACROS_SV__

   `include "uvm_macros.svh"

   //----------------------------------------------------------------------------------------
   // Group: Macros

   ////////////////////////////////////////////
   // macro: global_heartbeat
   // Called by registered monitors to indicate that the DUT is still alive
   `define global_heartbeat(str) begin global_pkg::env.heartbeat_mon.raise(this, str, `uvm_file, `uvm_line); end

   ////////////////////////////////////////////
   // macro: global_add_to_heartbeat_mon
   // Called by components to register themselves with the heartbeat monitor
   // t : A time field that indicates what the drain time is for this component
   `define global_add_to_heartbeat_mon(t) begin global_pkg::env.heartbeat_mon.register(this, t); end

`endif // __GLOBAL_MACROS_SV__
