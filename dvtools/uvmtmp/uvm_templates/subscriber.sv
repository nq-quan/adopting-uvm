<@header>
<@ifndef>

// (`includes go here)

// class: <class_name>
// (Describe me)
class <class_name> extends uvm_<template>#(<subscription_type>);
   `uvm_component_utils_begin(<vkit_name>_pkg::<class_name>)
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
endclass : <class_name>

<@endif>
