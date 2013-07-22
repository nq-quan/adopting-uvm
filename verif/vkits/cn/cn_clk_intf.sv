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
// File:   cn_clk_intf.sv
// Author: bhunter
/* About:  Clock Interface
 *************************************************************************/


`ifndef __CN_CLK_INTF_SV__
   `define __CN_CLK_INTF_SV__

// class: cn_clk_intf
// A simple interface holding the clock wire, and it's ideal clock
interface cn_clk_intf();

   //----------------------------------------------------------------------------------------
   // Group: Signals

   logic clk;
   logic clk_ideal;

endinterface : cn_clk_intf
   
`endif // __CN_CLK_INTF_SV__
