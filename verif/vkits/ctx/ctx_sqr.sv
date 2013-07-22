//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2013, Caviu
// * (utg v0.8)
// ***********************************************************************
// File:   ctx_sqr.sv
// Author: bhunter
/* About:  An sequencer for CTX
 *************************************************************************/

`ifndef __CTX_SQR_SV__
   `define __CTX_SQR_SV__

   
`include "ctx_item.sv"

// class: sqr_c
// Sequences items to driver
class sqr_c extends uvm_sequencer#(item_c);
   `uvm_component_utils_begin(ctx_pkg::sqr_c)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   //----------------------------------------------------------------------------------------
   // Group: TLM Ports
   
   //----------------------------------------------------------------------------------------
   // Group: Fields

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="sqr",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   // func: build_phase
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction : build_phase

   ////////////////////////////////////////////
   // func: connect_phase
   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
   endfunction : connect_phase

   ////////////////////////////////////////////
   // func: end_of_elaboration_phase
   virtual function void end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
   endfunction : end_of_elaboration_phase

   ////////////////////////////////////////////
   // func: run_phase
   virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);
   endtask : run_phase

endclass : sqr_c
   
`endif // __CTX_SQR_SV__
   