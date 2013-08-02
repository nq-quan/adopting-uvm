class <name>_seq_c extends uvm_sequence #(<reqType>, <rspType>);
   `uvm_object_utils_begin(<vkit_name>_pkg::<name>_seq_c)
   `uvm_object_utils_end

<@section_border>
   // Group: Fields

<@section_border>
   // Group: Methods

   function new(string name="<name>_seq");
      super.new(name);
   endfunction : new

<@method_border>
   // func: body
   virtual task body();
   endtask : body
endclass : <name>_seq_c
