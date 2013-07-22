//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.6.3)
// ***********************************************************************
// File:   frm_intf.sv
// Author: bhunter
/* About:  <description>
 *************************************************************************/

`ifndef __FRM_INTF_SV__
   `define __FRM_INTF_SV__

// class: frm_intf
// FRM Framer Interface
interface frm_intf(input logic clk, input logic rst_n);

   import uvm_pkg::*;

   //----------------------------------------------------------------------------------------
   // Group: Signals

   logic [4:0]  frame_len;
   logic        frame_len_val;
   logic        frame;
   logic [31:0] frame_data;
   logic        frame_bp;

   //----------------------------------------------------------------------------------------
   // Group: Clocking blocks

   // var: drv_cb
   // Clocking block for environment drivers
   clocking drv_cb @(posedge clk);
      output    frame_len_val;
      output    frame_len;

      input     frame;
      input     frame_data;
      input     frame_bp;
      input     rst_n;
   endclocking : drv_cb

   // var: mon_cb
   // Clocking block for environment monitors
   clocking mon_cb @(posedge clk);
      input     frame_len_val;
      input     frame_len;
      input     frame;
      input     frame_data;
      input     frame_bp;
      input     rst_n;
   endclocking : mon_cb

   //----------------------------------------------------------------------------------------
   // Group: Modports

   // var: drv_mp
   // Modport for drivers
   modport drv_mp (clocking drv_cb,
                   import reset);

   // var: mon_mp
   // Modport for monitors
   modport mon_mp (clocking mon_cb);

   //----------------------------------------------------------------------------------------
   // Group: Methods

   // func: reset
   // Convenience function for the driver to reset its outputs
   function void reset();
      frame_len_val = 0;
      frame_len = 5'b0;
   endfunction : reset

   //----------------------------------------------------------------------------------------
   // Group: Assertions

   // ensure that frame_data output is not-X when frame is high
   not_x: assert property( @(posedge clk)
                           disable iff(rst_n == 'b0)
                           !(frame && $isunknown(frame_data)))
      else
         `cn_err_intf(("frame_data is an X"))

endinterface : frm_intf

`endif // __FRM_INTF_SV__
