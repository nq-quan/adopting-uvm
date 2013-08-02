
// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2013
// * (utg v0.10)
// ***********************************************************************
// File:   res_intf.sv
// Author: bhunter
/* About:  ALU Results Interface
 *************************************************************************/

`ifndef __RES_INTF_SV__
   `define __RES_INTF_SV__

// class: res_intf
// (Describe me)
interface res_intf(input logic clk, input logic rst_n);
   import uvm_pkg::*;

   //----------------------------------------------------------------------------------------
   // Group: Signals

   // var: ready
   // ALU ready signal
   logic ready;

   // var: result
   // ALU result signal
   logic [31:0] result;

   //----------------------------------------------------------------------------------------
   // Group: Clocking blocks

   clocking mon_cb @(posedge clk);
      input ready;
      input result;
      input rst_n;
   endclocking : mon_cb

   clocking drv_cb @(posedge clk);
      output ready;
      output result;
      input rst_n;
   endclocking : drv_cb

   //----------------------------------------------------------------------------------------
   // Group: Modports

   modport mon_mp(clocking mon_cb);
   modport drv_mp(clocking drv_cb);

   //----------------------------------------------------------------------------------------
   // Group: Methods

   //----------------------------------------------------------------------------------------
   // Group: Assertions
   not_x : assert property( @(posedge clk)
                           disable iff (rst_n == 0)
                           !(ready && $isunknown(result)))
   else
      `cn_err_intf(("result is an X when ready is high."))

endinterface : res_intf

`endif // __RES_INTF_SV__
