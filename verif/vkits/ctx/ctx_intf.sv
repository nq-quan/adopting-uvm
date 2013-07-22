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
// File:   ctx_intf.sv
// Author: bhunter
/* About:  An interface for CTX
 *************************************************************************/

`ifndef __CTX_INTF_SV__
   `define __CTX_INTF_SV__

   
// class: ctx_intf
// The interface signals for CSR reads and writes
interface ctx_intf(input logic clk, input logic rst_n);

   //----------------------------------------------------------------------------------------
   // Group: Signals

   logic val;
   logic [7:0] in;
   logic [7:0] out;
   
   //----------------------------------------------------------------------------------------
   // Group: Clocking blocks

   clocking drv_cb @(posedge clk);
      input    rst_n;
      output   val;
      output   in;
      input    out;
   endclocking : drv_cb

   clocking mon_cb @(posedge clk);
      input    rst_n;
      input    val;
      input    in;
      input    out;
   endclocking : mon_cb
   
   //----------------------------------------------------------------------------------------
   // Group: Methods

   ////////////////////////////////////////////
   // func: reset
   function void reset();
      val = 0;
      in  = 0;
   endfunction : reset
   
   //----------------------------------------------------------------------------------------
   // Group: Modports

   modport drv_mp (clocking drv_cb,
                   import reset);
   modport mon_mp (clocking mon_cb);
                   
   //----------------------------------------------------------------------------------------
   // Group: Assertions
   
endinterface : ctx_intf

`endif // __CTX_INTF_SV__
   