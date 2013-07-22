//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2012, Caviu
// * (utg v0.8.1)
// ***********************************************************************
// File:   cn_reg_field.sv
// Author: bhunter
/* About:  It may be desirable to maintain the originally randomized 
           desired values of a register field through a reset.  In such 
           a case, use a set_type_override with this version of the class 
           instead.
 *************************************************************************/

`ifndef __CN_REG_FIELD_SV__
   `define __CN_REG_FIELD_SV__

// class: reg_field_c
// Overrides the typical register field to have the reset() function NOT modify the m_desired field.
class reg_field_c extends uvm_reg_field;
   `uvm_object_utils(cn_pkg::reg_field_c)

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="cn_pkg::reg_field");
      super.new(name);
   endfunction : new

   ////////////////////////////////////////////
   // func: reset
   // Maintain the original m_desired value through a reset
   virtual function void reset(string kind = "HARD");
      uvm_reg_data_t curr_desired = get();
      super.reset(kind);
      set(curr_desired, `__FILE__, `__LINE__);
   endfunction: reset

endclass : reg_field_c

`endif // __CN_REG_FIELD_SV__
