// ************************************************************************
// *                                                                      *
// *  CAVIUM CONFIDENTIAL AND PROPRIETARY NOTE                            *
// *                                                                      *
// *  This software contains information confidential and proprietary     *
// *  to Cavium, Inc. It shall not be reproduced in whole or in part,     *
// *  or transferred to other documents, or disclosed to third parties,   *
// *  or used for any purpose other than that for which it was obtained,  *
// *  without the prior written consent of Cavium, Inc.                   *
// *                                                                      *
// *  Copyright 2010-2012, Cavium, Inc.  All rights reserved.             *
// *                                                                      *
// ************************************************************************
// * Author      : bdobbie
// * Description : Include common to all Verilog files
// ***********************************************************************

`ifndef _CN_DEFINES_VH
 `define _CN_DEFINES_VH

// ----------------------------------------------------------------------
//
// USAGE: Messaging Macros (for use inside procedural blocks)
//
// always @(negedge clk) begin
//    `cn_info_hdl(("csr write to address=0x%x", addr));
//
//    `cn_dbg_hdl(CN_DBG_MED,("bus transaction with src=%d size=%d data=0x%x",
//                            src, size, data));
//    `cn_print_hdl(CN_DBG_HIGH,("| ifb%2d | 0x%x | 0x%x |",
//                               ifbnum, tag, data));
//    `cn_warn_hdl(("unexpected tag=%d", tag));
//
//    `cn_err_hdl(("illegal state=%s", state_ascii));
//
//    `cn_fatal_hdl(("something horrible happened, giving up"));
// end
//
// ----------------------------------------------------------------------
//
// USAGE: Immediate Assertion Macros (for use inside procedural blocks)
//
// always_comb begin
//     `cn_assert_hdl(mask_is_onehot, $onehot(mask),
//                    ("mask=0b%b", mask));
// end
//
// ----------------------------------------------------------------------
//
// USAGE: Concurrent Assertion Macros (for use outside procedural blocks)
//
//  `cn_assert_prop_hdl(xcheck_on_bus_data,
//                      @(posedge clk) disable iff (rst_n !== 1'b1)
//                      bus_val |-> !$isunknown(bus_data),
//                      ("val=%b data=0b%b", bus_val, bus_data));
//
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// Internal defines - used by local macros
// ----------------------------------------------------------------------
 `define cn_stringify(ARG) `"ARG`"
 `define cn_assert_msg(LBL, MSG) $sformatf(`"Assertion 'LBL' failed. %s`", $sformatf MSG)

// ----------------------------------------------------------------------
// Timescale define
// ----------------------------------------------------------------------
 `define cn_timescale `timescale 1ns/1fs

// ----------------------------------------------------------------------
// Random define
// ----------------------------------------------------------------------
 `define cn_rand $urandom

// ----------------------------------------------------------------------
// Testbench defines
// ----------------------------------------------------------------------
 `ifdef TBV
  `define cn_test_idle              `SYS_TB_PATH.tbv__idle
  `define cn_verr_enable            `SYS_TB_PATH.tbv__verr_enable
  `define cn_debug_level            `SYS_TB_PATH.tbv__debug_level
  `define cn_svfcov_enable          `SYS_TB_PATH.tbv__svfcov_enable
  `define cn_posedge_test_idle      posedge `cn_test_idle
  `define cn_posedge_verr_enable    posedge `cn_verr_enable
 `else
  `define cn_test_idle              1'b1
  `define cn_verr_enable            1'b1
  `define cn_debug_level            1'b1
  `define cn_svfcov_enable          1'b1
  `define cn_posedge_test_idle      *
  `define cn_posedge_verr_enable    *
 `endif

// ----------------------------------------------------------------------
// Messaging defines
// ----------------------------------------------------------------------
 `ifdef TBV
  `define CN_UVM_MESSAGES
 `endif

 `ifdef CN_UVM_MESSAGES
typedef enum { CN_DBG_NONE   = uvm_pkg::UVM_NONE,	// 0
	       CN_DBG_LOW    = uvm_pkg::UVM_LOW,	// 100
	       CN_DBG_MED    = uvm_pkg::UVM_MEDIUM,	// 200
	       CN_DBG_HIGH   = uvm_pkg::UVM_HIGH,	// 300
	       CN_DBG_FULL   = uvm_pkg::UVM_FULL,	// 400
	       CN_DBG_DEBUG  = uvm_pkg::UVM_DEBUG	// 500
} cn_msg_verbosity;
 `endif

 `ifdef SYNTHESIS
  // Hide messages from synthesis
  `define cn_info_hdl(MSG)          do begin end while(0)
  `define cn_dbg_hdl(LVL, MSG)      do begin end while(0)
  `define cn_print_hdl(LVL, MSG)    do begin end while(0)
  `define cn_warn_hdl(MSG)          do begin end while(0)
  `define cn_err_hdl(MSG)           do begin end while(0)
  `define cn_fatal_hdl(MSG)         do begin end while(0)
  `define cn_msg_tag(TAG)           localparam unused__cn_msg = 1'b0
 `elsif CAVIUM_CDC
  // Hide messages from CDC analysis
  `define cn_info_hdl(MSG)          do begin end while(0)
  `define cn_dbg_hdl(LVL, MSG)      do begin end while(0)
  `define cn_print_hdl(LVL, MSG)    do begin end while(0)
  `define cn_warn_hdl(MSG)          do begin end while(0)
  `define cn_err_hdl(MSG)           do begin end while(0)
  `define cn_fatal_hdl(MSG)         do begin end while(0)
  `define cn_msg_tag(TAG)           localparam unused__cn_msg = 1'b0
 `elsif CN_LINT
  // Lint will recognize $ignore system task and give us some checking of args
  `define cn_info_hdl(MSG)          $ignore ($sformatf MSG)
  `define cn_dbg_hdl(LVL, MSG)      $ignore ($sformatf MSG)
  `define cn_print_hdl(LVL, MSG)    $ignore ($sformatf MSG)
  `define cn_warn_hdl(MSG)          $ignore ($sformatf MSG)
  `define cn_err_hdl(MSG)           $ignore ($sformatf MSG)
  `define cn_fatal_hdl(MSG)         $ignore ($sformatf MSG)
  `define cn_msg_tag(TAG)           localparam unused__cn_msg = 1'b0
 `elsif CN_LEGACY_MESSAGES
  // Provide a method to use legacy vpi messaging scheme
  `define cn_info_hdl(MSG)          $cnLegacyInfo  ($sformatf MSG)
  `define cn_dbg_hdl(LVL, MSG)      $cnLegacyDbg   ($sformatf MSG)
  `define cn_print_hdl(LVL, MSG)    $cnLegacyDbg   ($sformatf MSG)
  `define cn_warn_hdl(MSG)          $cnLegacyWarn  ($sformatf MSG)
  `define cn_err_hdl(MSG)           $cnLegacyErr   ($sformatf MSG)
  `define cn_fatal_hdl(MSG)         $cnLegacyFatal ($sformatf MSG)
  `define cn_msg_tag(TAG)           localparam unused__cn_msg = 1'b0
 `elsif CN_UVM_MESSAGES
   // Default to uvm-native messaging scheme
  `define cn_info_hdl(MSG) \
      /* VCS coverage off */ \
      do begin \
	 if (1'b1 && \
	     cn_msg_tag.msg_leaf.uvm_report_enabled (uvm_pkg::UVM_NONE, uvm_pkg::UVM_INFO   , cn_msg_tag.full_name)) \
	     cn_msg_tag.msg_leaf.uvm_report_info    (cn_msg_tag.full_name, $sformatf("%s [%m]", $sformatf MSG), 0                , `uvm_file, `uvm_line); \
      end while (0) \
      /* VCS coverage on */
  `define cn_dbg_hdl(LVL, MSG) \
      /* VCS coverage off */ \
      do begin \
	 if (1'b1 /*`cn_debug_level*/ && \
	     cn_msg_tag.msg_leaf.uvm_report_enabled (LVL              , uvm_pkg::UVM_INFO   , cn_msg_tag.full_name)) \
	     cn_msg_tag.msg_leaf.uvm_report_info    (cn_msg_tag.full_name, $sformatf("%s [%m]", $sformatf MSG), LVL              , `uvm_file, `uvm_line); \
      end while(0) \
      /* VCS coverage on */
  `define cn_print_hdl(LVL, MSG) \
      /* VCS coverage off */ \
      do begin \
	 if (1'b1 /*`cn_debug_level*/ && \
	     cn_msg_tag.msg_leaf.uvm_report_enabled (LVL              , uvm_pkg::UVM_INFO   , cn_msg_tag.full_name)) \
	     $display($sformatf MSG); \
      end while(0) \
      /* VCS coverage on */
  `define cn_warn_hdl(MSG) \
      /* VCS coverage off */ \
      do begin \
	 if (`cn_verr_enable && \
	     cn_msg_tag.msg_leaf.uvm_report_enabled (uvm_pkg::UVM_NONE, uvm_pkg::UVM_WARNING, cn_msg_tag.full_name)) \
	     cn_msg_tag.msg_leaf.uvm_report_warning (cn_msg_tag.full_name, $sformatf("%s [%m]", $sformatf MSG), uvm_pkg::UVM_NONE, `uvm_file, `uvm_line); \
      end while (0) \
      /* VCS coverage on */
  `define cn_err_hdl(MSG) \
      /* VCS coverage off */ \
      do begin \
	 if (`cn_verr_enable && \
	     cn_msg_tag.msg_leaf.uvm_report_enabled (uvm_pkg::UVM_NONE, uvm_pkg::UVM_ERROR  , cn_msg_tag.full_name)) \
	     cn_msg_tag.msg_leaf.uvm_report_error   (cn_msg_tag.full_name, $sformatf("%s [%m]", $sformatf MSG), uvm_pkg::UVM_NONE, `uvm_file, `uvm_line); \
      end while (0) \
      /* VCS coverage on */
  `define cn_fatal_hdl(MSG) \
      /* VCS coverage off */ \
      do begin \
	 if (1'b1 && \
	     cn_msg_tag.msg_leaf.uvm_report_enabled (uvm_pkg::UVM_NONE, uvm_pkg::UVM_FATAL  , cn_msg_tag.full_name)) \
	     cn_msg_tag.msg_leaf.uvm_report_fatal   (cn_msg_tag.full_name, $sformatf("%s [%m]", $sformatf MSG), uvm_pkg::UVM_NONE, `uvm_file, `uvm_line); \
      end while (0) \
      /* VCS coverage on */
  `define cn_msg_tag(TAG)           cn_msg_tag #(.MSG_TAG(TAG)) cn_msg_tag ()
 `else
  // Failsafe, most simple format
  `define cn_info_hdl(MSG)          $display ("INFO  : %s [%m]", $sformatf MSG)
  `define cn_dbg_hdl(LVL, MSG)      $display ("DEBUG : %s [%m]", $sformatf MSG)
  `define cn_print_hdl(LVL, MSG)    $display (        "%s"     , $sformatf MSG)
  `define cn_warn_hdl(MSG)          $display ("WARN  : %s [%m]", $sformatf MSG)
  `define cn_err_hdl(MSG)           $display ("ERROR : %s [%m]", $sformatf MSG)
  `define cn_fatal_hdl(MSG)         $display ("FATAL : %s [%m]", $sformatf MSG)
  `define cn_msg_tag(TAG)           localparam unused__cn_msg = 1'b0
 `endif

// ----------------------------------------------------------------------
// Assertion defines
// ----------------------------------------------------------------------

// Assertion with message reporting, used inside a block.
// Add trailing ; where the macro is used
 `ifdef USE_ASSERTIONS
  `define cn_assert_blk(LBL, ARG, MSG) \
    LBL : assert (ARG) \
      else `cn_err_hdl(( `cn_assert_msg(LBL,MSG) ))
 `else // Need to consume the semicolon following this macro - also check for duplicate labels
  `define cn_assert_blk(LBL,ARG,MSG) \
      do begin end while(0)
 `endif

// Assertion with message reporting, used in top of a module.
// Add trailing ; where the macro is used
 `ifdef USE_ASSERTIONS
  `define cn_assert_prop(LBL, ARG, MSG) \
    LBL : assert property (ARG) \
      else `cn_err_hdl(( `cn_assert_msg(LBL, MSG) ))
 `else // Need to consume the semicolon following this macro - also check for duplicate labels
  `define cn_assert_prop(LBL, ARG, MSG) \
      localparam unused__assert_``LBL = 1'b0
 `endif

// Common Assertion Patterns
 `define cn_assert_clk(LBL, CLK, RST, ARG, MSG) \
   `cn_assert_prop (LBL, \
		    @(posedge CLK) disable iff (RST !== 1'b1) \
		    ARG, MSG)

 `define cn_assert_verr_enable(LBL, ARG, MSG) \
   `cn_assert_prop (LBL, \
		    @(posedge `cn_verr_enable) \
		    ARG, MSG)

 `define cn_assert_test_idle(LBL, ARG, MSG) \
   `cn_assert_prop (LBL, \
 		    @(posedge `cn_test_idle) \
   		    ARG, MSG)

// ----------------------------------------------------------------------
// Coverage defines
// ----------------------------------------------------------------------

  // Don't put `cn_svfcov_enable in the condition, because that screws up
  // condition coverage merging across test benches.
  `define cn_svfcov_new(GRP) \
   initial do begin \
      bit svfcov_enable; \
      svfcov_enable = `cn_svfcov_enable; \
      if (svfcov_enable == 1'b1) begin \
         `cn_info_hdl((`"Functional coverage enabled: GRP`")); \
         GRP = new(); \
      end \
   end while (0)

   // conditionally instantiate a covergroup:
   `define cn_svfcov_new_cond(GRP, COND) \
   initial do begin \
      bit svfcov_enable; \
      svfcov_enable = `cn_svfcov_enable; \
      if (svfcov_enable == 1'b1 && (COND)) begin \
	 `cn_info_hdl((`"Functional coverage enabled: GRP`")); \
	 GRP = new(); \
      end \
   end while (0)

// Simple covergroup (similar to cn_assert_prop)
// Must be used inside cn_lint_off/on CN_TB_MON CN_COVERAGE
// Add trailing ; where the macro is used
 `ifdef USE_ASSERTIONS
  `define cn_simple_svfcov(LBL, ARG) \
      covergroup LBL; \
         c: coverpoint ARG; \
      endgroup \
      LBL u_``LBL; \
      `cn_svfcov_new(u_``LBL)
 `else
  `define cn_simple_svfcov(LBL, ARG) \
      localparam unused__svfcov_``LBL = 1'b0
 `endif

// Simple covergroup with clock and active low reset (similar to cn_assert_clk)
// Must be used inside cn_lint_off/on CN_TB_MON CN_COVERAGE
// Add trailing ; where the macro is used
 `ifdef USE_ASSERTIONS
  `define cn_simple_svfcov_clk(LBL, CLK, RST, ARG) \
      covergroup LBL @(posedge CLK); \
         c: coverpoint ARG iff (RST !== 1'b1); \
      endgroup \
      LBL u_``LBL; \
      `cn_svfcov_new(u_``LBL)
 `else
  `define cn_simple_svfcov_clk(LBL, CLK, RST, ARG) \
      localparam unused__svfcov_``LBL = 1'b0
 `endif

`endif // Guard
