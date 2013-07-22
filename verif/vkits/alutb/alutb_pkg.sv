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
// File:   alutb_pkg.sv
// Author: bhunter
/* About:  ALUTB package
 *************************************************************************/


`include "uvm_macros.svh"

// package: alutb_pkg
// The ALUT Testbench Tutorial package
package alutb_pkg;

   //----------------------------------------------------------------------------------------
   // Group: Imports
   import uvm_pkg::*;

   //----------------------------------------------------------------------------------------
   // Group: Includes
`include "alutb_cfg.sv"
`include "alutb_env.sv"

endpackage : alutb_pkg
   

