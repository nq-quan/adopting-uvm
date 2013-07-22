//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2013
// * (utg v0.8)
// ***********************************************************************
// File:   ctx_mon.sv
// Author: bhunter
/* About:  An monitor for CTX
 *************************************************************************/

`ifndef __CTX_MON_SV__
   `define __CTX_MON_SV__

`include "ctx_item.sv"

// class: mon_c
// Monitor all CSR transactions
class mon_c extends uvm_monitor;
   `uvm_component_utils_begin(ctx_pkg::mon_c)
      `uvm_field_string(intf_name, UVM_DEFAULT)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   // field: intf_name
   string intf_name = "ctx_vi";

   //----------------------------------------------------------------------------------------
   // Group: TLM Ports

   // field: Analyzed transactions
   uvm_analysis_port #(item_c) item_port;

   //----------------------------------------------------------------------------------------
   // Group: Fields

   // field: ctx_vi
   // CTX interface
   virtual ctx_intf.mon_mp ctx_vi;

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="mon",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   // func: build_phase
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `cn_get_intf(virtual ctx_intf.mon_mp, "ctx_pkg::ctx_intf", intf_name, ctx_vi);
      item_port = new("item_port", this);
   endfunction : build_phase

   ////////////////////////////////////////////
   // func: run_phase
   virtual task run_phase(uvm_phase phase);
      forever begin
         fork
            monitor();
            @(negedge ctx_vi.mon_cb.rst_n);
         join_any
         disable fork;
      end
   endtask : run_phase

   ////////////////////////////////////////////
   // func: monitor
   // Monitors all transactions
   virtual task monitor();
      byte unsigned bytestream[$];
      byte unsigned bytes[];
      item_c item;
      bit  is_write;

      forever begin
         @(posedge ctx_vi.mon_cb.val);

         // create the new item
         item = item_c::type_id::create("item", this);
         bytestream.delete();

         // first cycle, bit 7 indicates read or write
         bytestream.push_back(ctx_vi.mon_cb.in);
         is_write = ctx_vi.mon_cb.in[7] == 1;
         @(ctx_vi.mon_cb);

         if(is_write) begin
            do begin
               bytestream.push_back(ctx_vi.mon_cb.in);
               @(ctx_vi.mon_cb);
            end while(ctx_vi.mon_cb.val == 1);
         end else begin
            // 3 cycles to perceive data
            repeat(3)
               @(ctx_vi.mon_cb);

            // 4 data cycles
            repeat(4) begin
               bytestream.push_back(ctx_vi.mon_cb.out);
               @(ctx_vi.mon_cb);
            end
         end

         // end of transaction.  unpack into it
         if(bytestream.size() > 5) // max size
            `cn_err(("A bytestream of size %0d is too large.", bytestream.size()))
         else begin
            bytes = new[bytestream.size()](bytestream);
            item.unpack_bytes(bytes);
            `cn_info(("Monitored transaction: %s\n%s", item.convert2string(), cn_pkg::print_ubyte_array(bytes)))
            item_port.write(item);
         end
      end
   endtask : monitor

endclass : mon_c

`endif // __CTX_MON_SV__
