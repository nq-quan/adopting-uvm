//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011, Caviu
// * (utg v0.4.1)
// ***********************************************************************
// File:   cn_fsdb_builtin_logger.sv
// Author: bhunter
/* About:  Log Built-ins to FSDB
 *************************************************************************/

`ifndef __CN_FSDB_BUILTIN_LOGGER_SV__
   `define __CN_FSDB_BUILTIN_LOGGER_SV__

// class: fsdb_builtin_logger_c
// Can be used to log monitored items to FSDB.  As a virtual class with a pure
// virtual write function, it MUST be derived from to be used, and its write
// method must be filled in accordingly.
virtual class fsdb_builtin_logger_c #(type TYPE=uvm_sequence_item) extends uvm_subscriber#(TYPE);
/* -----\/----- EXCLUDED -----\/-----
   `uvm_component_param_utils_begin(cn_pkg::fsdb_builtin_logger_c#(TYPE))
      `uvm_field_string(stream_name, UVM_ALL_ON)
      `uvm_field_int(severity, UVM_ALL_ON | UVM_DEC)
   `uvm_component_utils_end
 -----/\----- EXCLUDED -----/\----- */

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   // var: stream_name
   // The stream name to log to
   string stream_name;

   // var: severity
   // The severity to log at
   int    severity = 1;

   //----------------------------------------------------------------------------------------
   // Group: Fields
   
   // var: enabled
   // Set by <new>.
   bit    enabled;
   
   //----------------------------------------------------------------------------------------
   // Methods
   function new(string name="fsdb_builtin_logger",
                uvm_component parent=null);
      super.new(name, parent);
      enabled = ($test$plusargs("fsdbLogOff") == 0);
   endfunction : new

   ////////////////////////////////////////////
   // func: build_phase
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      if(uvm_config_db#(int)::exists(this, "", "severity", 0) == 1'b1)
         uvm_config_db#(int)::get(this, "*", "severity", severity);

      if(uvm_config_db#(string)::exists(this, "", "stream_name", 0) == 1'b1)
         uvm_config_db#(string)::get(this, "*", "stream_name", stream_name);
      else
         stream_name = get_name();
   endfunction : build_phase
   
   ////////////////////////////////////////////
   // func: write
   // Receives the transaction and writes it to the FSDB
   pure virtual function void write(TYPE t);
endclass : fsdb_builtin_logger_c
   
`endif // __CN_FSDB_BUILTIN_LOGGER_SV__
