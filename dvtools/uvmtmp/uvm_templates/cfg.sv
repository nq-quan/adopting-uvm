<@header>
<@ifndef>

// (`includes go here)
   `include "<vkit_name>_reg_block.sv"

// class: <class_name>
// (Describe me)
class <class_name> extends uvm_object;
   `uvm_object_utils_begin(<vkit_name>_pkg::<class_name>)
      `uvm_field_int(coverage_enable, UVM_ALL_ON)
      `uvm_field_object(reg_block, UVM_REFERENCE)
   `uvm_object_utils_end

<@section_border>
   // Group: Fields

   // Field: coverage_enable
   // Is functional coverage collection enabled?
   int coverage_enable;

   // Register block for this environment
   rand reg_block_c reg_block;

<@section_border>
   // Group: Methods
   function new(string name="<name>");
      super.new(name);
      `cn_svfcov_cg_new(cg)
   endfunction : new

<@section_border>
   // Group: Functional Coverage

   // prop: cg
   // Covergroup for configuration options
   covergroup cg;
   endgroup : cg

endclass : <class_name>

<@endif>
