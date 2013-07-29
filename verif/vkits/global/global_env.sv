
// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.3.3)
// ***********************************************************************
// File:   global_env.sv
// Author: bhunter
/* About:  Global Environment
 *************************************************************************/


`ifndef __GLOBAL_ENV_SV__
   `define __GLOBAL_ENV_SV__

   `define DEFAULT_TOPO_DEPTH  4

`include "global_watchdog.sv"
`include "global_heartbeat_mon.sv"

// class: env_c
// The Global environment, instantiated in all testbenches at the global scope.
class env_c extends uvm_env;
   `uvm_component_utils_begin(global_pkg::env_c)
      `uvm_field_int(run_count,   UVM_DEFAULT | UVM_DEC)
      `uvm_field_int(topo_depth,  UVM_DEFAULT | UVM_DEC)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   // var: run_count
   // The number of times that this simulation will loop over the run-time phases
   int run_count = 1;

   // var: topo_depth
   // The depth of topology printing (-1 means that it was not set in config_db)
   int topo_depth = -1;

   //----------------------------------------------------------------------------------------
   // Group: Fields

   // var: watchdog
   // Looks for deadlocks or watchdog timeouts.  Calls global_stop_request on either.
   watchdog_c watchdog;

   // var: heartbeat
   // Monitors heartbeat of registered components during main and shutdown phases
   heartbeat_mon_c heartbeat_mon;

   // var: current_phase
   // This holds the current run-time phase of the test
   local uvm_phase current_phase;

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="env",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   // func: build_phase
   // Connect the hearbeat mon and wdog
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      watchdog = watchdog_c::type_id::create("watchdog", this);
      heartbeat_mon = heartbeat_mon_c::type_id::create("heartbeat_mon", this);
   endfunction : build_phase

   ////////////////////////////////////////////
   // func: start_of_simualtion_phase
   virtual function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);

      // plusargs override configured value
      // configured value overrides DEFAULT_TOPO_DEPTH
      if(!$value$plusargs("UVM_TOPO_DEPTH=%d", topo_depth)) begin
         if(topo_depth == -1)
            topo_depth = (get_report_verbosity_level())? `DEFAULT_TOPO_DEPTH:0;
         else
            topo_depth = 0;
      end

      if(topo_depth)
         print_topology(uvm_top, topo_depth);
   endfunction

   ////////////////////////////////////////////
   // funcs: Changes the current_phase field
   virtual function void phase_started(uvm_phase phase);
      super.phase_started(phase);
      current_phase = phase;
      `cn_info(("Entered phase: %s", current_phase.get_name()))
   endfunction : phase_started

   ////////////////////////////////////////////
   // Func: phase_ready_to_end
   // Callback when a phase ready to ends
   virtual function void phase_ready_to_end(uvm_phase phase);
      super.phase_ready_to_end(phase);

      // at the end of the shutdown phase, consider the run_count
      // this does NOT happen at the end of the post_shutdown phase, because by then
      // the run phase has already terminated
      if(phase.get_imp() == uvm_shutdown_phase::get()) begin
         run_count -= 1;
         if(run_count > 0) begin
            `cn_info(("-------------------------------------------------------"))
            `cn_info(("That was fun! Let's do it again! (%0d more time%s...)", run_count, (run_count > 1? "s":"")))
            `cn_info(("-------------------------------------------------------"))

            if(phase.get_objection().get_objection_count()) begin
               `cn_err(("The shutdown phase was about to end, but it was re-raised:"))
               phase.get_objection().display_objections();
            end
            phase.jump(uvm_pre_reset_phase::get());
         end
      end
   endfunction : phase_ready_to_end

   ////////////////////////////////////////////
   // func: print_topology
   virtual function void print_topology(uvm_object _object,
                                        int _depth,
                                        int _name_width=-1,
                                        int _type_width=-1);

      uvm_table_printer printer = new();
      string topology;

      printer.knobs.depth = _depth;
      printer.knobs.indent = 3;

      topology = _object.sprint(printer);
      `cn_info(("Printing the %s topology at depth %0d:", _object.get_full_name(), _depth))
      $display("%s", topology);
   endfunction : print_topology

   ////////////////////////////////////////////
   // func: get_current_phase
   // Return the currently running phase
   virtual   function uvm_phase get_current_phase();
      return current_phase;
   endfunction : get_current_phase

endclass : env_c

//****************************************************************************************
// instantiate this class so that it is visible to all importers
// The class must be ::create'd by the base test
static env_c env;


`endif // __GLOBAL_ENV_SV__
