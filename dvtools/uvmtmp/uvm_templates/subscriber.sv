<@header>
<@ifndef>
   
// (`includes go here)

// class: <name>_c
// (Describe me)
class <name>_c extends uvm_<template>#(<subscription_type>);
   `uvm_component_utils_begin(<pkg_name>_pkg::<name>_c)
   `uvm_component_utils_end

<@section_border>
   // Group: Configuration Fields

<@section_border>
   // Group: TLM Ports
   
<@section_border>
   // Group: Fields

<@phases>
<@method_border>
   // func: write
   // Receives the <subscription_type>
   virtual function void write(<subscription_type> t);
   endfunction : write
endclass : <name>_c
   
<@endif>
   