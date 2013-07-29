
// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.3.3)
// ***********************************************************************
// File:   cn_rst_drv.sv
// Author: bhunter
/* About:  Standard Reset Driver.

 Usage:

 1. Instantiate the reset wire and interface, and make the assignment:

       wire tb_rst_n;
       cn_rst_intf tb_rst_i();
       assign tb_rst_n = tb_rst_i.rst_n;

 2. Set the interface into the configuration database using the base name of the wire:

       initial begin
          uvm_resource_db#(virtual cn_rst_intf)::set("cn_pkg::rst_intf", "tb_rst_vi", tb_rst_i);

 3. Instantiate the reset driver in the base_test.  Configure it in the build_phase.
    Ensure that the intf_name configuration option is the same as used in the testbench.

       cn_pkg::rst_drv_c tb_rst_drv;

       virtual function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          // Create the reset driver
          uvm_config_db#(string)::set(this, "tb_rst_drv", "intf_name", "tb_rst_vi");
          uvm_config_db#(int)::set this,   ("tb_rst_drv", "drive_dcok", 1);
          tb_rst_drv = cn_pkg::rst_drv_c::type_id::create("tb_rst_drv", this);
          tb_rst_drv.randomize();
       endfunction : build_phase

    You may either set the configuration options before the call to
    ::create, or randomize them with constraints after the call.  To
    randomize outside the set of 'sane' constraints, be sure to turn
    its constraint mode off.

 *************************************************************************/

`ifndef __CN_RST_DRV_SV__
   `define __CN_RST_DRV_SV__

`define write_vi(SIGNAL, VALUE) \
   if(clocked) begin \
      rst_vi.cb.SIGNAL <= VALUE; \
   end else begin \
      rst_vi.SIGNAL = VALUE; \
   end

// class: rst_drv_c
class rst_drv_c extends uvm_driver;
   `uvm_component_utils_begin(cn_pkg::rst_drv_c)
      `uvm_field_string(intf_name,            UVM_ALL_ON)
      `uvm_field_int(active_low,              UVM_ALL_ON)
      `uvm_field_int(x_time_ps,               UVM_ALL_ON | UVM_DEC)
      `uvm_field_int(reset_time_ps,           UVM_ALL_ON | UVM_DEC)
      `uvm_field_int(drive_dcok,              UVM_ALL_ON)
      `uvm_field_int(dcok_time_ps,            UVM_ALL_ON | UVM_DEC)
      `uvm_field_int(drive_start_bist,        UVM_ALL_ON)
      `uvm_field_int(drive_clear_bist,        UVM_ALL_ON)
      `uvm_field_int(use_bist_complete,       UVM_ALL_ON)
      `uvm_field_int(start_bist_time_ps,      UVM_ALL_ON | UVM_DEC)
      `uvm_field_int(drain_time_ps,           UVM_ALL_ON | UVM_DEC)
      `uvm_field_int(clocked,                 UVM_ALL_ON)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Configuration Fields

   // var: intf_name
   // Name in the resource database under which the vintf is stored. The scope
   // under which it is stored is "cn_pkg::rst_intf".
   string intf_name = "rst_i";

   // var: active_low
   // When set, the reset signal will start low and go high.  When clear, it's the opposite.
   bit active_low = 1;

   // var: x_time_ps
   // The length of time that reset signal will stay at x at the beginning of time
   rand int unsigned x_time_ps;

   // var: reset_time_ps
   // The length of time that reset will stay active
   rand int unsigned reset_time_ps;

   // var: drive_dcok
   // When set, dcok will be driven to coincide with the expiration of x_time_ps + dcok_time_ps
   // Otherwise, ignore dcok as it will not be set
   bit drive_dcok = 0;

   // var: drive_start_bist
   // When set, start_bist will be driven to coincide with the expiration of reset_phase + start_bist_time_ps
   // Otherwise, ignore start_bist as it will not be set
   bit drive_start_bist = 0;

   // var: drive_clear_bist
   // When set, clear_bist will be driven at the beginning of the test
   bit drive_clear_bist = 0;

   // var: use_bist_complete
   // When set, wait on bist_complete before dessarting reset. If this is set, reset will be active for
   // bist_complete + reset_time_ps. If this is not set, reset_time_ps will have to be programmed for
   // enough time for bist to finish. If it is set, reset_time_ps can be small.
   bit use_bist_complete = 0;

   // var: dcok_time_ps
   // The length of time that dcok will be 0 when reset is not X
   rand int unsigned dcok_time_ps;

   // var: start_bist_time_ps
   // The length of time after the start of the reset phase to wait before asserting start_bist
   rand int unsigned start_bist_time_ps;

   bit clocked = 0;

   // Base constraints.  Turn these off if you wish to override them
   constraint sane_cnstr {
      x_time_ps >= 0;
      x_time_ps < 100000;
      reset_time_ps >= 0;
      reset_time_ps < 1000000;
      dcok_time_ps >= 0;
      dcok_time_ps < 1000000;
      start_bist_time_ps >= 0;
      start_bist_time_ps < 1000000;
   }

   // var: drain_time
   // The amount of time after reset is asserted to continue the reset phase
   rand int unsigned drain_time_ps;
   constraint drain_time_cnstr {
      drain_time_ps inside {[1000:50000]};
   }

   //----------------------------------------------------------------------------------------
   // Fields

   // var: rst_vi
   // Reset interface
   virtual cn_rst_intf rst_vi;

   //----------------------------------------------------------------------------------------
   // Methods
   function new(string name="rst_drv",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // get the interface
      `cn_get_intf(virtual cn_rst_intf, "cn_pkg::rst_intf", intf_name, rst_vi)
   endfunction : build_phase

   ////////////////////////////////////////////
   // func: pre_reset_phase
   // TODO: Add DCOK phase to phase schedule?
   virtual task pre_reset_phase(uvm_phase phase);
      phase.raise_objection(this);
      `cn_info(("Starting reset driver on interface %s. active_low=%0d, x_time_ps=%0d, reset_time_ps=%0d, drive_dcok=%0d dcok_time_ps=%0d drive_start_bist=%0d start_bist_time_ps=%0d use_bist_complete=%0d",
                intf_name, active_low, x_time_ps, reset_time_ps, drive_dcok, dcok_time_ps, drive_start_bist, start_bist_time_ps, use_bist_complete))

      if(drive_dcok) begin
         `write_vi(dcok,'b0)
      end

      if(drive_start_bist) begin
         `write_vi(start_bist,'b0)
      end

      if(x_time_ps) begin
         `write_vi(rst_n,'bx)
         #(x_time_ps * 1ps);
      end
      `write_vi(rst_n,~active_low)

      if(drive_clear_bist) begin
         `write_vi(clear_bist,!$test$plusargs("bist") || $test$plusargs("bistskip"))
      end

      if(drive_dcok) begin
         #(dcok_time_ps * 1ps);
         `write_vi(dcok,'b1)
      end
      phase.drop_objection(this);
   endtask : pre_reset_phase

   ////////////////////////////////////////////
   // func: reset_phase
   // Drive DCOK and reset
   virtual task reset_phase(uvm_phase phase);
      phase.raise_objection(this);
      `cn_info(("reset phase run count %0d", phase.get_run_count()))
      // if reset phase has been exec more than once
      // this means testbench is doing a reset by phase.jump(reset_phase)
      // In this case, assert reset signal in reset phase.

      if (phase.get_run_count() > 1 ) begin
         `write_vi(rst_n,~active_low)
      end
      if(drive_start_bist) begin
         #(start_bist_time_ps * 1ps);
         `write_vi(start_bist,'b1)
      end

      if(use_bist_complete) begin
         if(clocked) begin
            @(posedge rst_vi.cb.bist_complete);
         end else begin
            @(posedge rst_vi.bist_complete);
         end
      end
      #(reset_time_ps * 1ps);
      `write_vi(rst_n,active_low)

      #(drain_time_ps * 1ps);
      `cn_info(("Reset driver on interface %s complete.", intf_name))
      phase.drop_objection(this);
   endtask : reset_phase

endclass : rst_drv_c

`undef write_vi

`endif // __CN_RST_DRV_SV__
