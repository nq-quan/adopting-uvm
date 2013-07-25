<@header>
<@ifndef>
   
// (`includes go here)

// class: <name>_c
// (Describe me)
class <name>_c extends uvm_object;
   `uvm_object_utils_begin(<pkg_name>_pkg::<name>_c)
      // (object fields declared here)
   `uvm_object_utils_end

<@section_border>
   // Group: Fields
   
<@section_border>
   // Group: Methods
   function new(string name="<name>");
      super.new(name);
   endfunction : new

<@method_border>
   // func: convert2string
   // Single-line printing function
   virtual function string convert2string();
      return $psprintf("(put stuff here)");
   endfunction : convert2string
   
endclass : <name>_c
   
<@endif>
