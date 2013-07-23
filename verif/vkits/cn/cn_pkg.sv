//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.3.3)
// ***********************************************************************
// File:   cn_pkg.sv
// Author: bhunter
/* About:  UVM Common Global Package
 *************************************************************************/


`include "uvm_macros.svh"
`include "cn_macros.sv"

// package: cn_pkg
package cn_pkg;

   //----------------------------------------------------------------------------------------
   // Imports
   import uvm_pkg::*;

   //----------------------------------------------------------------------------------------
   // Includes

`include "cn_clk_drv.sv"
`include "cn_msgs.sv"
`include "cn_objection.sv"
`include "cn_print_utils.sv"
`include "cn_report_server.sv"
`include "cn_rst_drv.sv"

endpackage : cn_pkg

