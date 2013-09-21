<@header>
<@ifndef>

// (`includes go here)

// class: <class_name>
// (Describe me)
class <class_name> extends uvm_<template>;
   `uvm_object_utils_begin(<vkit_name>_pkg::<class_name>)
   `uvm_object_utils_end

<@section_border>
   // Group: Fields

   // (put reg maps here. capitalize instance names)
   uvm_reg_map <MAP>;

   // (put reg files here.  capitalize instance names. If there is more than one,
   // distinguish them with name of csr_pkg)
   rand <csr_pkg>_csr_pkg::reg_file_c REG_FILE;

<@section_border>
   // Group: Methods

   function new(string name="<name>");
      super.new(name, .has_coverage(UVM_NO_COVERAGE));
   endfunction : new

<@method_border>
   virtual function build();

      // create reg map
      // (Settings below work for RSL)
      <MAP> = create_map(.name("<MAP>"),
                         .base_addr(0),
                         .n_bytes(8),
                         .endian(UVM_BIG_ENDIAN),
                         .byte_addressing(1));
      default_map = <MAP>;

      // create reg file
      REG_FILE = <csr_pkg>_csr_pkg::reg_file_c::type_id::create("REG_FILE", null, get_full_name());
      REG_FILE.configure(this, null);
      REG_FILE.build();

      // (set the offset accordingly)
      REG_FILE.map(<MAP>, .offset(0));
   endfunction : build

endclass : <class_name>

<@endif>
