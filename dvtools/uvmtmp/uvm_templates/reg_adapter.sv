<@header>
<@ifndef>

// (`includes go here)
   
// class: <template>_c
// (Description)
class <template>_c extends uvm_<template>;
   `uvm_object_utils(<pkg_name>_pkg::<template>_c)

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
      
endclass : <template>_c
   
<@endif>
