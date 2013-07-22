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
// File:   frm_pkg.sv
// Author: bhunter
/* About:  Contains the framer agent
 *************************************************************************/

`include "uvm_macros.svh"

// package: frm_pkg
// Framer package
package frm_pkg;

   //----------------------------------------------------------------------------------------
   // Group: Imports
   import uvm_pkg::*;

   //----------------------------------------------------------------------------------------
   // Group: Includes
`include "frm_agent.sv"
`include "frm_cfg.sv"
`include "frm_drv.sv"
`include "frm_env.sv"
`include "frm_frame.sv"
`include "frm_intf.sv"
`include "frm_mon.sv"
`include "frm_seq_lib.sv"
`include "frm_sqr.sv"
`include "frm_vseq_lib.sv"
   
endpackage : frm_pkg
   

