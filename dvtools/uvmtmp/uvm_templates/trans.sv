<@header>
<@ifndef>
   
// (`includes go here)

// class: <template>_c
// (Describe me)
class <template>_c extends uvm_transaction;
   `uvm_object_utils_begin(<pkg_name>_pkg::<template>_c)
   `uvm_object_utils_end

<@section_border>
   // Group: Fields

<@section_border>
   // Group: Methods
   function new(string name="<template>");
      super.new(name);
   endfunction : new

<@method_border>
   // func: convert2string
   // Single-line printing
   virtual function string convert2string();
      return "TBD";
   endfunction : convert2string
   
endclass : <template>_c
   

<@endif>
