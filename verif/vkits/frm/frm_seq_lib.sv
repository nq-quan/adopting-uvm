
// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.6.3)
// ***********************************************************************
// File:   frm_seq_lib.sv
// Author: bhunter
/* About:  Sequences frames.
 *************************************************************************/

`ifndef __FRM_SEQ_LIB_SV__
   `define __FRM_SEQ_LIB_SV__

`include "frm_frame.sv"

typedef class lib_seq_c;

// class: frame_seq_c
// Send a single frame
class frame_seq_c extends uvm_sequence #(frame_c);
   `uvm_object_utils(frm_pkg::frame_seq_c)
   `uvm_add_to_seq_lib(frame_seq_c, lib_seq_c);

   //----------------------------------------------------------------------------------------
   // Methods

   function new(string name="frame_seq");
      super.new(name);
   endfunction : new

   ////////////////////////////////////////////
   // func: body
   virtual task body();
      frame_c frame;

      `cn_seq_raise;
      `uvm_do(frame);
      get_response(rsp);
      `cn_seq_drop;
   endtask : body
endclass : frame_seq_c

//****************************************************************************************
class lib_seq_c extends uvm_sequence_library #(frame_c);
   `uvm_object_utils(frm_pkg::lib_seq_c)
   `uvm_sequence_library_utils(lib_seq_c)

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="lib_seq");
      super.new(name);
      init_sequence_library();
   endfunction : new

endclass : lib_seq_c


`endif // __FRM_SEQ_LIB_SV__
