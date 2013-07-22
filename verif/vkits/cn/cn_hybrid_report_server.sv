//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2012, Caviu
// *
// ***********************************************************************
// File:   cn_hybrid_report_server.sv
// Author: fnj
/* About:  Overrides the cavium report server class for hybrid testbenches

Pure UVM testbenches override the uvm report server to better model how our
logfiles should look.  The factory override is done in tbv_common.v at time
zero.
 
 *************************************************************************/

`ifndef __CN_HYBRID_REPORT_SERVER_SV__
 `define __CN_HYBRID_REPORT_SERVER_SV__

 `include "cn_report_server.sv"

class hybrid_report_server_c extends report_server_c;
   `uvm_object_utils(cn_pkg::hybrid_report_server_c)

   //----------------------------------------------------------------------------------------
   // Methods
   function new(string name="");
      super.new(name);
   endfunction

   ////////////////////////////////////////////
   virtual function void report(uvm_severity severity,
                                string name,
                                string id,
                                string message,
                                int verbosity_level,
                                string filename,
                                int line,
                                uvm_report_object client
                                );

      uvm_severity_type sv = uvm_severity_type'(severity);
      
      // Force fatal, error, and warning reports to have verbosity NONE so they can't get
      // supressed.  The `cn_err/cn_fatal macros always set verbosity to NONE,
      // but third-party IP that calls uvm_report_error might not.
      if(severity inside {UVM_ERROR, UVM_FATAL, UVM_WARNING})
        verbosity_level = 0;

      // We neeed this check because it catches disabled messages
      if(!client.uvm_report_enabled(verbosity_level, severity, id)) begin
         return;
      end

      case(sv)
        UVM_INFO:    begin $cnUvmInfo (id, message, filename, line, (verbosity_level/2)); end
        UVM_ERROR:   begin $cnUvmErr  (id, message, filename, line                 ); end
        UVM_WARNING: begin $cnUvmWarn (id, message, filename, line                 ); end
        UVM_FATAL:   begin $cnUvmFatal(id, message, filename, line                 ); end
      endcase

   endfunction : report
endclass : hybrid_report_server_c

`endif // __CN_HYBRID_REPORT_SERVER_SV__
