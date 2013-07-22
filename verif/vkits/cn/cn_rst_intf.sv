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
// File:   cn_rst_intf.sv
// Author: bhunter
/* About:  Standard Reset Interface.
 *************************************************************************/


`ifndef __CN_RST_INTF_SV__
   `define __CN_RST_INTF_SV__

// class: cn_rst_intf
interface cn_rst_intf();

   //----------------------------------------------------------------------------------------
   // Group: Signals

   logic rst_n;
   logic dcok;
   logic start_bist;
   logic clear_bist;
   logic bist_complete;
   logic clk;

   //----------------------------------------------------------------------------------------
   // Group: Clocking blocks
   clocking cb @(posedge clk);
      output     rst_n;
      output     dcok;
      output     start_bist;
      output     clear_bist;
      input      bist_complete;
   endclocking : cb

endinterface : cn_rst_intf
   
`endif // __CN_RST_INTF_SV__
