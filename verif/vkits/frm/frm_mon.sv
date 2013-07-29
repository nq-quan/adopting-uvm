
// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.6.3)
// ***********************************************************************
// File:   frm_mon.sv
// Author: bhunter
/* About:  Framer interface monitor
 *************************************************************************/

`ifndef __FRM_MON_SV__
   `define __FRM_MON_SV__

`include "frm_frame.sv"

// class: mon_c
// Monitors the frame requests and frame data
class mon_c extends uvm_monitor;
   `uvm_component_utils_begin(frm_pkg::mon_c)
      `uvm_field_string(intf_name, UVM_ALL_ON)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   // var: intf_name
   // The name of the frm_intf.mon_mp interface to connect to
   string intf_name = "mon_vi";

   //----------------------------------------------------------------------------------------
   // Group: TLM Ports

   // var: request_port
   // Drives monitored requests (without data) to listeners
   uvm_analysis_port#(frame_c) request_port;

   // var: frame_port
   // Drives monitored frames (with data) to listeners
   uvm_analysis_port#(frame_c) frame_port;

   //----------------------------------------------------------------------------------------
   // Group: Fields

   // var: mon_vi
   // Virtual monitor interface
   virtual frm_intf.mon_mp mon_vi;

   // var: frame_req
   // The current frame request
   frame_c frame_req;

   //----------------------------------------------------------------------------------------
   // Methods
   function new(string name="mon",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   // func: build_phase
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      request_port = new("request_port", this);
      frame_port = new("frame_port", this);

      // get the interface
      `cn_get_intf(virtual frm_intf.mon_mp, "frm_pkg::frm_intf", intf_name, mon_vi);
   endfunction : build_phase

   ////////////////////////////////////////////
   // func: run_phase
   virtual task run_phase(uvm_phase phase);
      forever begin
         @(posedge mon_vi.mon_cb.rst_n);
         fork
            monitor_reqs();
            monitor_frames();
            @(negedge mon_vi.mon_cb.rst_n);
         join_any
         disable fork;
      end
   endtask : run_phase

   ////////////////////////////////////////////
   // func: monitor_reqs
   // Monitors requests, making sure there's only 1 at a time
   virtual task monitor_reqs();
      frame_req = null;
      forever begin
         @(posedge mon_vi.mon_cb.frame_len_val);
         if(frame_req)
            `cn_err(("There is already an outstanding frame request of length %0d, but saw frame_len_val go high.",
                     frame_req.frame_len))
         frame_req = frame_c::type_id::create("frame");
         frame_req.frame_len = mon_vi.mon_cb.frame_len;
         request_port.write(frame_req);
      end
   endtask : monitor_reqs

   ////////////////////////////////////////////
   // func: monitor_frames()
   // Monitors all frames, pairing up with existing requests
   virtual task monitor_frames();
      forever begin
         @(posedge mon_vi.mon_cb.frame);
         if(frame_req == null)
            `cn_err(("Saw frame go high, but there was no corresponding request."))
         else begin
            // allocate frame data
            frame_req.frame_data = new[frame_req.frame_len];
            for(int idx=0; idx < frame_req.frame_len; idx++) begin
               if(mon_vi.mon_cb.frame == 0)
                  `cn_err(("Saw frame go low, but there were only %0d of %0d data words.",
                           idx, frame_req.frame_len))
               else
                  frame_req.frame_data[idx] = mon_vi.mon_cb.frame_data;
               @(mon_vi.mon_cb);
            end

            if(mon_vi.mon_cb.frame == 1)
               `cn_err(("Frame received %0d words, but frame is still high.", frame_req.frame_len))
            else begin
               frame_port.write(frame_req);
               `cn_info(("Monitored this complete frame:\n%s", frame_req.sprint()))
            end
            frame_req = null;
         end
      end
   endtask : monitor_frames
endclass : mon_c

`endif // __FRM_MON_SV__
