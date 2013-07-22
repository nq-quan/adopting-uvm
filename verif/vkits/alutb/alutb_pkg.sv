//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011, Caviu
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
   

