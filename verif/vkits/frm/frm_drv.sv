//-*-
 verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.6.3)
// ***********************************************************************
// File:   frm_drv.sv
// Author: bhunter
/* About:  <description>
 *************************************************************************/

`ifndef __FRM_DRV_SV__
   `define __FRM_DRV_SV__

`include "frm_frame.sv"

// class: drv_c
// Drives Frame Information
class drv_c extends uvm_driver#(frame_c);
   `uvm_component_utils_begin(frm_pkg::drv_c)
      `uvm_field_string(intf_name, UVM_ALL_ON)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   // var: intf_name
   // The name of the frm_intf.drv_mp interface to connect to
   string intf_name = "drv_vi";

   //----------------------------------------------------------------------------------------
   // Group: TLM Ports

   //----------------------------------------------------------------------------------------
   // Group: Fields

   // var: drv_vi
   // Virtual driver interface
   virtual frm_intf.drv_mp drv_vi;

   //----------------------------------------------------------------------------------------
   // Methods
   function new(string name="drv",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   // func: build_phase
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // get the interface
      `cn_get_intf(virtual frm_intf.drv_mp, "frm_pkg::frm_intf", intf_name, drv_vi);
   endfunction : build_phase

   ////////////////////////////////////////////
   // func: reset_phase
   virtual task reset_phase(uvm_phase phase);
      drv_vi.reset();
   endtask : reset_phase

   ////////////////////////////////////////////
   // func: main_phase
   virtual task main_phase(uvm_phase phase);

      forever begin
         drv_vi.reset();

         seq_item_port.get_next_item(req);

         `cn_info(("Driving this frame: %s", req.convert2string()))

         // wait for frame_bp and frame to both be low
         wait(drv_vi.drv_cb.frame_bp == 'b0 && drv_vi.drv_cb.frame == 'b0);

         // ensure we're on the right clock
         @(drv_vi.drv_cb);

         // drive the frame request
         drv_vi.drv_cb.frame_len_val <= 'b1;
         drv_vi.drv_cb.frame_len <= req.frame_len;
         @(drv_vi.drv_cb);
         `cn_info(("Driven"));
         drv_vi.reset();
         `cn_info(("Reset"));

         // wait for frame
         @(posedge drv_vi.drv_cb.frame);
         req.frame_data = new[req.frame_len];
         foreach(req.frame_data[x]) begin
            req.frame_data[x] = drv_vi.drv_cb.frame_data;
            @(drv_vi.drv_cb);
         end

         seq_item_port.item_done(req);
         `cn_info(("Saw this completed frame: %s", req.convert2string()))
      end
   endtask : main_phase

endclass : drv_c

`endif // __FRM_DRV_SV__
