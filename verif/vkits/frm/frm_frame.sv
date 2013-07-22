//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// * CAVIUM CONFIDENTIAL                                                 
// *                                                                     
// *                         PROPRIETARY NOTE                            
// *                                                                     
// * This software contains information confidential and proprietary to  
// * Cavium, Inc. It shall not be reproduced in whole or in part, or     
// * transferred to other documents, or disclosed to third parties, or   
// * used for any purpose other than that for which it was obtained,     
// * without the prior written consent of Cavium, Inc.                   
// * (c) 2011, Cavium, Inc.  All rights reserved.                      
// * (utg v0.6.3)
// ***********************************************************************
// File:   frm_frame.sv
// Author: bhunter
/* About:  A complete frame
 *************************************************************************/

`ifndef __FRM_FRAME_SV__
   `define __FRM_FRAME_SV__

// class: frame_c
// A complete frame of data from the FRM Framer
class frame_c extends uvm_sequence_item;
   `uvm_object_utils_begin(frm_pkg::frame_c)
      `uvm_field_int(frame_len, UVM_ALL_ON | UVM_DEC)
      `uvm_field_array_int(frame_data, UVM_ALL_ON | UVM_HEX)
   `uvm_object_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Fields

   // var: frame_len
   rand int frame_len;
   constraint frame_len_cnstr { frame_len inside {[1:31]}; }

   // var: frame_data
   // The collected frame data
   bit [31:0] frame_data[];
   
   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="frame");
      super.new(name);
   endfunction : new

   //----------------------------------------------------------------------------------------
   // func: convert2string
   // Single-line printing
   virtual function string convert2string();
      convert2string = $psprintf("FRAME:%0d qwords", frame_len);
   endfunction : convert2string
   
endclass : frame_c
   
`endif // __FRM_FRAME_SV__

