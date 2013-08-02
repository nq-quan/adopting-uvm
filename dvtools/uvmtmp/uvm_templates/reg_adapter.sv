<@header>
<@ifndef>

// (`includes go here)

// class: <class_name>
// (Description)
class <class_name> extends uvm_<template>;
   `uvm_object_utils(<vkit_name>_pkg::<class_name>)

<@section_border>
   // Group: Methods

   function new(string name="reg_adapter");
      super.new(name);
   endfunction : new

   ////////////////////////////////////////////
   // func: reg2bus
   virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
   endfunction : reg2bus

   ////////////////////////////////////////////
   // func: bus2reg
   virtual function void bus2reg(uvm_sequence_item bus_item,
                                 ref uvm_reg_bus_op rw);
   endfunction : bus2reg

endclass : <class_name>

<@endif>
