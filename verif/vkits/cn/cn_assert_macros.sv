//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// * CAVIUM CONFIDENTIAL AND PROPRIETARY NOTE
// *
// * This software contains information confidential and proprietary to
// * Cavium, Inc. It shall not be reproduced in whole or in part, or
// * transferred to other documents, or disclosed to third parties, or
// * used for any purpose other than that for which it was obtained,
// * without the prior written consent of Cavium, Inc.
// * Copyright 2012, Cavium, Inc.  All rights reserved.
// * (utg v0.8.2)
// ***********************************************************************
// File:   cn_assert_macros.sv
// Author: bhunter
/* About:  Assertion macros for interfaces.
    NOTE:  Use of these assertions REQUIRES that the uvm_pkg::* is imported
           within the interface!
 *************************************************************************/

`ifndef __CN_ASSERT_MACROS_SV__
   `define __CN_ASSERT_MACROS_SV__

   `include "cn_msgs.sv"

////////////////////////////////////////////
// macro: `cn_assert_setup
// This macro should be included in any interface that uses macros from this file
   `define cn_assert_setup \
      logic disable_asserts; \
      initial disable_asserts=0; \
      always @(disable_asserts) \
         `cn_info_intf(("Assertions are now %s", (disable_asserts==0? "ENABLED":"DISABLED")))
   
////////////////////////////////////////////
// macro: `cn_assert_x_check
// Check that a clocked signal is never an X when reset is high
   `define cn_assert_x_check(SIGNAL, CLK, RST_N) \
      begin \
         assert property (@(posedge CLK) \
                          disable iff (RST_N==0 || $isunknown(RST_N) || disable_asserts) \
                          (!$isunknown(SIGNAL))) else  \
            `cn_err_intf(("SIGNAL is an X.")) \
      end

////////////////////////////////////////////
// macro: `cn_assert_async_x_check
// Check that an asynchronous signal is never an X when reset is high
   `define cn_assert_async_x_check(SIGNAL, RST_N) \
      begin \
         assert property ( \
                          disable iff (RST_N==0 || $isunknown(RST_N) || disable_asserts) \
                          (!$isunknown(SIGNAL))) else  \
            `cn_err_intf(("Async SIGNAL is an X.")) \
      end

////////////////////////////////////////////
// macro: `cn_assert_val_x_check
// Check that a clocked signal is never an X when reset is high and a valid signal is true
   `define cn_assert_val_x_check(SIGNAL, CLK, RST_N, VAL) \
      begin \
         assert property (@(posedge CLK) \
                          disable iff (RST_N==0 || $isunknown(RST_N) || !(VAL) || disable_asserts) \
                          (!$isunknown(SIGNAL))) else  \
            `cn_err_intf(("Async SIGNAL is an X even though VAL is true")) \
      end

////////////////////////////////////////////
// macro: `cn_assert_val_cond_check
// Assert that a condition is true whenever a valid is also true
   `define cn_assert_val_cond_check(COND, CLK, RST_N, VAL) \
      begin \
         assert property (@(posedge CLK) \
                          disable iff (RST_N==0 || $isunknown(RST_N) || !(VAL) || disable_asserts) \
                          (COND)) else  \
            `cn_err_intf(("Async SIGNAL is an X even though VAL is true")) \
      end

////////////////////////////////////////////
// macro: `cn_assert_one_within
// Assert that if signal A rises that signal B will be a 1 within CLK_MIN and CLK_MAX
   `define cn_assert_one_within(SIGA, SIGB, CLK_MIN, CLK_MAX, CLK, RST_N)                                    \
      assert property (@(posedge CLK)                                                                        \
                       disable iff (RST_N == 0 || $isunknown(RST_N) || disable_asserts)                      \
                       ($rose(SIGA) |-> ##[CLK_MIN:CLK_MAX] (SIGB == 1))) else                               \
         `cn_err_intf(("``SIGA`` changed but ``SIGB`` was not a 1 within [%0d:%0d] clocks.",                 \
                       CLK_MIN, CLK_MAX))

////////////////////////////////////////////
// macro: `cn_assert_one_within
// Assert that if signal A rises that signal B will be a 1 within CLK_MIN and CLK_MAX
   `define cn_assert_one_within_named(SIGA, SIGB, CLK_MIN, CLK_MAX, CLK, RST_N)                                    \
      cn_assrt_one_SIGA``_SIGB : `cn_assert_one_within(SIGA, SIGB, CLK_MIN, CLK_MAX, CLK, RST_N)

`endif // __CN_ASSERT_MACROS_SV__

