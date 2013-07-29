
// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.6.4)
// ***********************************************************************
// File:   frm_vseq_lib.sv
// Author: bhunter
/* About:  Framer Virtual Sequence Library
 *************************************************************************/

`ifndef __FRM_VSEQ_LIB_SV__
   `define __FRM_VSEQ_LIB_SV__


//
// UNCOMMENT THE FOLLOWING FOR PROBLEM 16-1:
//

/* -----\/----- EXCLUDED -----\/-----
`include "frm_vsqr.sv"

//-****************************************************************************************
// class: basic_vseq_c
class basic_vseq_c extends uvm_sequence;
   `uvm_object_utils(frm_pkg::basic_vseq_c)
   `uvm_declare_p_sequencer(vsqr_c)

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="basic_vseq");
      super.new(name);
   endfunction : new

   ////////////////////////////////////////////
   // func: body
   virtual task body();
      frame_c frame;
      alu_pkg::exer_seq_c alu_exer_seq;

      // create and randomize to see how many ALU transactions to send
       `uvm_create_on(frame, p_sequencer.frm_sqr)
      frame.randomize();
      `cn_info(("Sending this frame: %s", frame.convert2string()))
      fork
         begin : send_frame
            `uvm_send(frame);
            get_response(rsp);
            `cn_info(("Frame completed: %s", rsp.convert2string()))
         end
         `uvm_do_on_with(alu_exer_seq, p_sequencer.alu_sqr, { count == frame.frame_len; })
      join

   endtask : body

endclass : basic_vseq_c
 -----/\----- EXCLUDED -----/\----- */

`endif // __FRM_VSEQ_LIB_SV__
