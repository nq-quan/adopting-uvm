//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011, Caviu
// * (utg v0.4.1)
// ***********************************************************************
// File:   cn_fsdb_logger.sv
// Author: bhunter
/* About:  Log Transactions to FSDB
 *************************************************************************/

`ifndef __CN_FSDB_LOGGER_SV__
   `define __CN_FSDB_LOGGER_SV__

// class: fsdb_logger_c
// Logs monitored transactions to FSDB by calling their convert2string function
class fsdb_logger_c #(type TYPE=uvm_sequence_item) extends uvm_subscriber#(TYPE);
   `uvm_component_param_utils_begin(cn_pkg::fsdb_logger_c#(TYPE))
      `uvm_field_string(stream_name, UVM_ALL_ON)
      `uvm_field_int(severity, UVM_ALL_ON | UVM_DEC)
      `uvm_field_int(enabled,  UVM_ALL_ON)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   // var: stream_name
   // The stream name to log to
   string stream_name;

   // var: severity
   // The severity to log at
   int    severity = 1;

   // var: enabled
   // Set by <new>.
   bit    enabled;
   
   //----------------------------------------------------------------------------------------
   // Group: Fields
   
   //----------------------------------------------------------------------------------------
   // Methods
   function new(string name="fsdb_logger",
                uvm_component parent=null);
      super.new(name, parent);
      enabled = ($test$plusargs("fsdbLogOff") == 0);
   endfunction : new

   ////////////////////////////////////////////
   // func: build_phase
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(stream_name == "")
         stream_name = get_name();
   endfunction : build_phase
   
   ////////////////////////////////////////////
   // func: write
   // Receives the transaction and writes it to the FSDB
   virtual function void write(TYPE t);
   `ifdef HAVE_VERDI_WAVE_PLI
      if (enabled) begin
         string s;
         case(severity)
            1: s = t.convert2string();
            default: s = t.sprint();
         endcase
         $fsdbLog("trans", , severity, stream_name, s);
      end
   `endif // HAVE_VERDI_WAVE_PLI
   endfunction : write
endclass : fsdb_logger_c
   
`endif // __CN_FSDB_LOGGER_SV__
