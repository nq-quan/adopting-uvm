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
// File:   frm_cfg.sv
// Author: bhunter
/* About:  FRM Testbench Configuration Class
 *************************************************************************/

`ifndef __FRM_CFG_SV__
   `define __FRM_CFG_SV__
   
// class: cfg_c
// FRM Testbench Configuration Class
class cfg_c extends uvm_object;
   `uvm_object_utils_begin(frm_pkg::cfg_c)
      `uvm_field_object(reg_block, UVM_REFERENCE)
   `uvm_object_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Fields

   // var: reg_block
   // Register block for this environment
   rand alu_csr_pkg::reg_block_c reg_block;

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="cfg");
      super.new(name);
   endfunction : new

endclass : cfg_c

`endif // __FRM_CFG_SV__
   