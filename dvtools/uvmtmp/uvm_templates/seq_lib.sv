<@header>
<@ifndef>

// (`includes go here)

// Forward declaration of library sequence
typedef class lib_seq_c;

<@class_border>
// class:
// (your first sequence!)
<@seq>

<@class_border>
class lib_seq_c extends uvm_sequence_library #(<reqType>);
   `uvm_object_utils(<vkit_name>_pkg::lib_seq_c)
   `uvm_sequence_library_utils(lib_seq_c)

<@section_border>
   // Group: Methods
   function new(string name="lib_seq");
      super.new(name);
      init_sequence_library();
   endfunction : new

endclass : lib_seq_c


<@endif>
