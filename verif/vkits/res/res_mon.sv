
// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2013
// * (utg v0.10)
// ***********************************************************************
// File:   res_mon.sv
// Author: bhunter
/* About:  Monitors results.
 *************************************************************************/

`ifndef __RES_MON_SV__
   `define __RES_MON_SV__

   `include "res_types.sv"

// class: mon_c
// Monitors ALU results
class mon_c extends uvm_monitor;
   `uvm_component_utils_begin(res_pkg::mon_c)
      `uvm_field_string(intf_name, UVM_DEFAULT)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   // var: intf_name;
   // The interface name
   string intf_name = "<UNKNOWN>";

   //----------------------------------------------------------------------------------------
   // Group: TLM Ports

   // var: result_port
   // Monitored results go out here
   uvm_analysis_port#(result_t) result_port;

   //----------------------------------------------------------------------------------------
   // Group: Fields

   // var: vi;
   // Virtual interface
   virtual res_intf.mon_mp vi;

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="[name]",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   // func: build_phase
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `cn_get_intf(virtual res_intf.mon_mp, "res_pkg::intf", intf_name, vi)
      result_port = new("result_port", this);
   endfunction : build_phase

   ////////////////////////////////////////////
   // func: end_of_elaboration_phase
   virtual function void end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
      `global_add_to_heartbeat_mon();
   endfunction : end_of_elaboration_phase

   ////////////////////////////////////////////
   // func: run_phase
   virtual task run_phase(uvm_phase phase);
      forever begin
         @(posedge vi.mon_cb.rst_n);

         fork
            monitor();
         join_none

         @(negedge vi.mon_cb.rst_n);
         disable fork;
      end
   endtask : run_phase

   ////////////////////////////////////////////
   // func: monitor
   // Collect all them results
   virtual task monitor();
      forever begin
         @(posedge vi.mon_cb.ready);
         `global_heartbeat("results seen")

         while(vi.mon_cb.ready) begin
            `cn_info(("Monitored %08X", vi.mon_cb.result))
            result_port.write(vi.mon_cb.result);
            @(vi.mon_cb);
         end
      end
   endtask : monitor

endclass : mon_c

`endif // __RES_MON_SV__
