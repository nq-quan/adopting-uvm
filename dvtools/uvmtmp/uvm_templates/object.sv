<@header>
<@ifndef>

// (`includes go here)

// class: <class_name>
// (Describe me)
class <class_name> extends uvm_object;
   `uvm_object_utils_begin(<vkit_name>_pkg::<class_name>)
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

endclass : <class_name>

<@endif>
