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
// File:   global_pkg.sv
// Author: bhunter
/* About:  Components available to all testbenches.
 *************************************************************************/


`include "uvm_macros.svh"
`include "cn_macros.sv"
`include "global_macros.sv"
   
package global_pkg;

   //--------------------------------------------------------------------------
   // Group: Imports
   import uvm_pkg::*;

   //--------------------------------------------------------------------------
   // Group: Includes
`include "global_bug_entry.sv"
`include "global_heartbeat_mon.sv"
`include "global_watchdog.sv"
`include "global_misc_dpi.sv"
`include "global_csr_print_cbs.sv"
`include "global_env.sv"
`include "global_table_printer.sv"
   
endpackage : global_pkg
   

