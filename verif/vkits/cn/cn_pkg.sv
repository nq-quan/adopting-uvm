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

`include "cn_8b10b_enc.sv"
`include "cn_assert_macros.sv"
`include "cn_bag.sv"
`include "cn_base_test.sv"
`include "cn_clk_drv.sv"
`include "cn_clk_mon.sv"
`include "cn_dep_node.sv"
`include "cn_fsdb_builtin_logger.sv"
`include "cn_fsdb_logger.sv"
`include "cn_hybrid_report_server.sv"
`include "cn_math_utils.sv"
`include "cn_misc_utils.sv"
`include "cn_msg_vlog.sv"
`include "cn_objection.sv"
`include "cn_print_utils.sv"
`include "cn_reg_bag.sv"
`include "cn_reg_field.sv"
`include "cn_report_server.sv"
`include "cn_rst_drv.sv"
`include "cn_thresh_sem.sv"
`include "cn_string_utils.sv"
`include "cn_uid.sv"
   
endpackage : cn_pkg

