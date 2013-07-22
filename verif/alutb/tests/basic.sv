//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.6.0)
// ***********************************************************************
// File:   basic.sv
// Author: bhunter
/* About:  <description>
 *************************************************************************/

`ifndef __BASIC_SV__
   `define __BASIC_SV__

   `include "base_test.sv"

// class: basic_test_c
// A basic ALU test
class basic_test_c extends base_test_c;
   `uvm_component_utils(basic_test_c)

   //----------------------------------------------------------------------------------------
   // Methods
   function new(string name="test",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   // func: build_phase
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction : build_phase

endclass : basic_test_c

`endif // __BASIC_SV__
