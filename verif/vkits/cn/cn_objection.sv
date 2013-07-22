//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.6.4)
// ***********************************************************************
// File:   cn_objection.sv
// Author: bhunter
/* About:  Mimics UVM's objections, but removes all the component hierarchy stuff.
 *************************************************************************/

`ifndef __CN_OBJECTION_SV__
   `define __CN_OBJECTION_SV__

// class: objection_c
// A simpler objection class that removes hierarchy-related things.
class objection_c extends uvm_object;
   `uvm_object_utils_begin(cn_pkg::objection_c)
      `uvm_field_int(dbg_level,         UVM_DEFAULT | UVM_DEC)
      `uvm_field_int(count,             UVM_DEFAULT | UVM_DEC)
      `uvm_field_int(last_raised_time,  UVM_DEFAULT)
      `uvm_field_int(last_dropped_time, UVM_DEFAULT)
   `uvm_object_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Fields

   // var: dbg_level
   // The debug level of this objection
   int dbg_level = 500;

   // var: count
   // The current objection count, goes up when raised and down when dropped
   local int unsigned count;

   // var: last_raised_time
   // The last time this objection was raised
   time last_raised_time;

   // var: last_dropped_time
   // The last time this objection was dropped
   time last_dropped_time;

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="objection");
      super.new(name);
   endfunction : new

   ////////////////////////////////////////////
   // func: get_count
   function int unsigned get_count();
      return count;
   endfunction : get_count

   ////////////////////////////////////////////
   // func: raise
   function void raise(string _descr = "",
                       int unsigned _count = 1,
                       string _filename = "",
                       int _lineno = 0);
      string str;
      count += _count;
      str = $sformatf("Objection raised by %0d to %0d", _count, count);
      if(_descr != "")
         str = {str, " due to ", _descr};
      if(_filename != "") begin
         str = {str, " [", _filename};
         if(_lineno)
            str = $sformatf("%s:%0d", str, _lineno);
         str = {str, "]"};
      end
      `cn_dbg(dbg_level, (str))

      last_raised_time = $realtime();
   endfunction : raise

   ////////////////////////////////////////////
   // func: drop
   function void drop(string _descr = "",
                      int unsigned _count = 1,
                      string _filename = "",
                      int _lineno = 0);
      string str;
      count -= _count;
      str = $sformatf("Objection dropped by %0d to %0d", _count, count);
      if(_descr != "")
         str = {str, " due to ", _descr};
      if(_filename != "") begin
         str = {str, " [", _filename};
         if(_lineno)
            str = $sformatf("%s:%0d", str, _lineno);
         str = {str, "]"};
      end
      `cn_dbg(dbg_level, (str))

      last_dropped_time = $realtime();
   endfunction : drop

   ////////////////////////////////////////////
   // func: clear
   function void clear(string _descr = "",
                       string _filename = "",
                       int _lineno = 0);
      string str;
      count = 0;
      str = "Objection cleared to 0";
      if(_descr != "")
         str = {str, " due to ", _descr};
      if(_filename != "") begin
         str = {str, " [", _filename};
         if(_lineno)
            str = $sformatf("%s:%0d", str, _lineno);
         str = {str, "]"};
      end
      `cn_dbg(dbg_level, (str))

      last_dropped_time = $realtime();
   endfunction : clear

   ////////////////////////////////////////////
   // func: convert2string
   // Single-line printing function
   virtual function string convert2string();
      convert2string = $sformatf("%s objection @%0d", get_name(), count);
      if(last_raised_time)
         convert2string = $sformatf("%s last raised: %t", convert2string, last_raised_time);
      if(last_dropped_time)
         convert2string = $sformatf("%s last dropped: %t", convert2string, last_dropped_time);
   endfunction : convert2string

endclass : objection_c

`endif // __CN_OBJECTION_SV__
