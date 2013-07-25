class <name>_vseq_c extends uvm_sequence;
   `uvm_object_utils_begin(<pkg_name>_pkg::<name>_vseq_c)
   `uvm_object_utils_end

<@section_border>
   // Fields

<@section_border>
   // Methods

   function new(string name="<name>_vseq");
      super.new(name);
   endfunction : new

<@method_border>
   // func: body
   virtual task body();
   endtask : body
endclass : <name>_vseq_c
   