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
// File:   ctx_drv.sv
// Author: bhunter
/* About:  A CTX driver
 *************************************************************************/

`ifndef __CTX_DRV_SV__
   `define __CTX_DRV_SV__
   
`include "ctx_item.sv"

// class: drv_c
// (Describe me)
class drv_c extends uvm_driver#(item_c);
   `uvm_component_utils_begin(ctx_pkg::drv_c)
      `uvm_field_string(intf_name, UVM_DEFAULT)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   string intf_name="ctx_vi";
   
   //----------------------------------------------------------------------------------------
   // Group: TLM Ports
   
   //----------------------------------------------------------------------------------------
   // Group: Fields

   // field: ctx_vi
   // Virtual interface
   virtual ctx_intf.drv_mp ctx_vi;

   // field: driving
   // Set when the driver is active
   bit     driving;
   
   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="drv",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   // func: build_phase
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `cn_get_intf(virtual ctx_intf.drv_mp, "ctx_pkg::ctx_intf", intf_name, ctx_vi);
   endfunction : build_phase

   ////////////////////////////////////////////
   // func: run_phase
   virtual task run_phase(uvm_phase phase);
      forever begin
         ctx_vi.reset();
         
         fork
            driver();
            @(negedge ctx_vi.drv_cb.rst_n);
         join_any
         disable fork;
      end
   endtask : run_phase

   ////////////////////////////////////////////
   // func: shutdown_phase
   virtual task shutdown_phase(uvm_phase phase);
      forever begin
         if(driving) begin
            phase.raise_objection(this, "currently driving.");
            @(negedge driving);
            phase.drop_objection(this, "inactive");
         end
         @(driving);
      end
   endtask: shutdown_phase

   ////////////////////////////////////////////
   // func: driver
   // Get all items from the sequencer and drive them
   virtual task driver();
      forever begin
         ctx_vi.reset();
         
         // get the next item to drive
         seq_item_port.try_next_item(req);
         if(!req) begin
            ctx_vi.reset();
            seq_item_port.get_next_item(req);
            @(ctx_vi.drv_cb);
         end

         // drive it
         driving = 1;
         `cn_info(("Driving: %s", req.convert2string()))
         if(req.is_write) begin
            ////////////////////////////////////////////
            // Write Trans
            byte unsigned bytestream[];

            req.pack_bytes(bytestream);

            ctx_vi.drv_cb.val <= 1;
            foreach(bytestream[c]) begin
               ctx_vi.drv_cb.in  <= bytestream[c];
               `cn_info(("Driving: %02X", bytestream[c]))
               @(ctx_vi.drv_cb);
            end
            ctx_vi.drv_cb.val <= 0;
         end else begin
            ////////////////////////////////////////////
            // Read Trans
            data_t data;
            
            // drive addr cycle
            ctx_vi.drv_cb.val <= 1;
            ctx_vi.drv_cb.in  <= {1'b0, req.addr};
            `cn_info(("Driving: %02X", {1'b0, req.addr}))
            @(ctx_vi.drv_cb);

            // wait 4 cycles
            ctx_vi.drv_cb.val <= 0;
            ctx_vi.drv_cb.in  <= 8'b0;

            repeat(4) begin
               `cn_info(("Waiting:"))
               @(ctx_vi.drv_cb);
            end
            
            // collect read data
            repeat(4) begin
               data <<= 8;
               data |= ctx_vi.drv_cb.out;
               `cn_info(("Reading: %02X", ctx_vi.drv_cb.out))
               @(ctx_vi.drv_cb);
            end
            req.data = data;
         end

         `cn_info(("Drove: %s", req.convert2string()))
         seq_item_port.item_done(req);
         seq_item_port.put_response(req);
         driving = 0;
         
         // add a gap between transactions
         @(ctx_vi.drv_cb);
      end
   endtask : driver
endclass : drv_c
   
`endif // __CTX_DRV_SV__
