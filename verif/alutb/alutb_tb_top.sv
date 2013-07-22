//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// * CAVIUM CONFIDENTIAL AND PROPRIETARY NOTE
// *
// * This software contains information confidential and proprietary to
// * Cavium, Inc. It shall not be reproduced in whole or in part, or
// * transferred to other documents, or disclosed to third parties, or
// * used for any purpose other than that for which it was obtained,
// * without the prior written consent of Cavium, Inc.
// * Copyright 2013, Cavium, Inc.  All rights reserved.
// * (utg v0.8.2)
// ***********************************************************************
// File:   alutb_tb_top.sv
// Author: bhunter
/* About:  <description>
 *************************************************************************/

import uvm_pkg::*;

`include "cn_defines.vh"

module alutb_tb_top;
   //----------------------------------------------------------------------------------------
   // Group: Interfaces

   // obj: tb_clk_i
   // Testbench clock interface
   cn_clk_intf tb_clk_i();
   wire tb_clk = tb_clk_i.clk;

   // obj: tb_rst_i
   // Testbench reset interface
   cn_rst_intf tb_rst_i();
   wire tb_rst_n = tb_rst_i.rst_n;

   // obj: ctx_i
   // CTX Interface
   ctx_intf ctx_i(.clk(tb_clk), .rst_n(tb_rst_n));

   //----------------------------------------------------------------------------------------
   // Group: DUT

   // obj: dut_wrapper
   alu_wrapper alu_wrapper(/*AUTOINST*/
                           // Interfaces
                           .ctx_i               (ctx_i),
                           // Inputs
                           .tb_clk              (tb_clk),
                           .tb_rst_n            (tb_rst_n));

   //----------------------------------------------------------------------------------------
   // Group: Procedural Blocks

   ////////////////////////////////////////////
   // func: pre_run_test
   // Set interface names before run_test is called
   function void pre_run_test();
      `cn_set_intf(virtual cn_clk_intf    , "cn_pkg::clk_intf"  , "tb_clk_vi", tb_clk_i);
      `cn_set_intf(virtual cn_rst_intf    , "cn_pkg::rst_intf"  , "tb_rst_vi", tb_rst_i);
      `cn_set_intf(virtual ctx_intf.drv_mp , "ctx_pkg::ctx_intf" , "ctx_vi"   , ctx_i.drv_mp);
      `cn_set_intf(virtual ctx_intf.mon_mp , "ctx_pkg::ctx_intf" , "ctx_vi"   , ctx_i.mon_mp);
   endfunction : pre_run_test

   `include "tb_common.v"
endmodule : alutb_tb_top

// Local Variables:
// verilog-library-extensions:(".v" ".sv")
// verilog-library-directories:("." "../../verif/hdl" "../../rtl/alu")
// verilog-auto-ignore-concat:t
// End:
