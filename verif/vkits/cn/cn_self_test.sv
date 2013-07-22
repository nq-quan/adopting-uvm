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
// * (c) 2012, Cavium, Inc.  All rights reserved.                      
// * (utg v0.7)
// ***********************************************************************
// File:   cn_self_test.sv
// Author: bhunter
/* About:  Used by files that need self-testing code.
 *************************************************************************/

`ifdef __SELF_TEST__

`ifndef __CN_SELF_TEST_SV__
   `define __CN_SELF_TEST_SV__

import uvm_pkg::*;

package cn_pkg;
   import uvm_pkg::*;
   `include "cn_msgs.sv"
   `include "cn_report_server.sv"
endpackage
   
module top;
   initial begin
      cn_pkg::report_server_c        report_server;
      
      // all "%t" shall print out in ns format with 9 digits and 3 decimal places
      $timeformat(-9,3,"ns",13);

      report_server = cn_pkg::report_server_c::type_id::create();

      // replace uvm_report_server with cn_report_server_c
      uvm_pkg::uvm_report_server::set_server(report_server);

      run_test();
   end
endmodule : top

`endif // __CN_SELF_TEST_SV__
`endif // __SELF_TEST__
