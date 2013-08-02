<@section_border>
   // Group: Methods
   function new(string name="<name>",
                uvm_component parent=null);
      super.new(name, parent);
<new_function?>
   endfunction : new

<@method_border>
   // func: build_phase
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
<build_phase?>
   endfunction : build_phase

<@method_border>
   // func: connect_phase
   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
<connect_phase?>
   endfunction : connect_phase

<@method_border>
   // func: end_of_elaboration_phase
   virtual function void end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
<end_of_elaboration_phase?>
   endfunction : end_of_elaboration_phase

<@method_border>
   // func: run_phase
   virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);
<run_phase?>
   endtask : run_phase

