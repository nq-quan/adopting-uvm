<@header>
<@ifndef>

`include "<vkit_name>_drv.sv"
`include "<vkit_name>_mon.sv"
`include "<vkit_name>_sqr.sv"
// (`includes go here)

// class: <class_name>
// (Description)
class <class_name> extends uvm_agent;
   `uvm_component_utils_begin(<vkit_name>_pkg::<class_name>)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
   `uvm_component_utils_end

<@section_border>
   // Group: Configuration Fields

   // var: is_active
   // When set to UVM_ACTIVE, the sqr and drv will be present.
   uvm_active_passive_enum is_active = UVM_ACTIVE;

<@section_border>
   // Group: TLM Ports

<@section_border>
   // Group: Fields

   // vars: Driver, monitor, and sequencer
   // Driver, monitor, and sequencer found in most agents
   sqr_c sqr;
   drv_c drv;
   mon_c mon;

<@phases>
<$build_phase>

      mon = mon_c::type_id::create("mon", this);
      if(is_active) begin
         drv = drv_c::type_id::create("drv", this);
         sqr = sqr_c::type_id::create("sqr", this);
      end
<$end>
<$connect_phase>

      if(is_active)
         drv.seq_item_port.connect(sqr.seq_item_export);
<$end>
endclass : <class_name>

<@endif>
