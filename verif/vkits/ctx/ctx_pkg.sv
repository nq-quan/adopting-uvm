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
// * (c) 2013, Cavium, Inc.  All rights reserved.                      
// * (utg v0.8)
// ***********************************************************************
// File:   ctx_pkg.sv
// Author: bhunter
/* About:  Package file for CTX vkit
 *************************************************************************/

`include "uvm_macros.svh"

// package: ctx_pkg
// A simple CSR protocol bus.
package ctx_pkg;

   //----------------------------------------------------------------------------------------
   // Group: Imports
   import uvm_pkg::*;

   //----------------------------------------------------------------------------------------
   // Group: Types

   //----------------------------------------------------------------------------------------
   // Group: Includes

`include "ctx_agent.sv"
`include "ctx_drv.sv"
`include "ctx_item.sv"
`include "ctx_mon.sv"
`include "ctx_reg_adapter.sv"
`include "ctx_types.sv"
`include "ctx_seq_lib.sv"
`include "ctx_sqr.sv"
   
endpackage : ctx_pkg
   

