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
// * (utg v0.3.3)
// ***********************************************************************
// File:   alutb_cfg.sv
// Author: bhunter
/* About:  ALUTB Environment Configuration
 *************************************************************************/


`ifndef __ALUTB_CFG_SV__
   `define __ALUTB_CFG_SV__

// class: cfg_c
// ALUTB Configuration Class
class cfg_c extends uvm_object;
   //----------------------------------------------------------------------------------------
   // Group: Types

   `uvm_object_utils_begin(alutb_pkg::cfg_c)
      `uvm_field_object(reg_block, UVM_REFERENCE)
   `uvm_object_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   // var: reg_block
   // Register block for this environment
   rand alu_csr_pkg::reg_block_c reg_block;

   constraint innocuous_cnstr {
      reg_block.CONST.K_VAL.value == 1;
      reg_block.CONST.C_VAL.value == 0;
   }

   //----------------------------------------------------------------------------------------
   // Group: Fields

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="cfg");
      super.new(name);
      cg = new();
   endfunction : new

   //----------------------------------------------------------------------------------------
   // Group: Functional Coverage

   // var: cg
   // Functional coverage group (TODO)
   covergroup cg;
   endgroup : cg
      
endclass : cfg_c
   
`endif // __ALUTB_CFG_SV__
