//-*-
 verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.6.3)
// ***********************************************************************
// File:   frm_sqr.sv
// Author: bhunter
/* About:  Frame sequencer
 *************************************************************************/

`ifndef __FRM_SQR_SV__
   `define __FRM_SQR_SV__

   `include "frm_frame.sv"

// class: sqr_c
// Frame sequencer
class sqr_c extends uvm_sequencer#(frame_c);
   `uvm_component_utils_begin(frm_pkg::sqr_c)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   //----------------------------------------------------------------------------------------
   // Group: TLM Ports

   //----------------------------------------------------------------------------------------
   // Group: Fields

   //----------------------------------------------------------------------------------------
   // Methods
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

`endif // __FRM_SQR_SV__
