
// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.3.4)
// ***********************************************************************
// File:   global_watchdog.sv
// Author: bhunter
/* About:  Global watchdog and deadlock checker
 *************************************************************************/

`ifndef __GLOBAL_WATCHDOG_SV__
   `define __GLOBAL_WATCHDOG_SV__

// class: watchdog_c
class watchdog_c extends uvm_component;
   `uvm_component_utils_begin(global_pkg::watchdog_c)
      `uvm_field_int(watchdog_time,  UVM_ALL_ON | UVM_DEC)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   // var: watchdog_time
   // The time, in ns, at which the test will timeout
   int watchdog_time = 100000;

   // var: timeout_occurred
   // Set to 1 on deadlock
   bit timeout_occurred = 0;

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="watchdog",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   // func: start_of_simulation_phase
   // At the start of simulation, check for plusargs to override any modifications to the watchdog_time
   virtual function void start_of_simulation_phase(uvm_phase phase);
      int  cl_wdog_time;
      int  cl_wdogx_time;

      super.start_of_simulation_phase(phase);

      if($value$plusargs("wdog=%d", cl_wdog_time))
        watchdog_time = cl_wdog_time;


      if($value$plusargs("wdogx=%d", cl_wdogx_time))
        watchdog_time *= cl_wdogx_time;


      `cn_dbg(UVM_LOW,("Global Watchdog Timer set to %0dns.", watchdog_time))
   endfunction : start_of_simulation_phase

   ////////////////////////////////////////////
   virtual task run_phase(uvm_phase phase);
      if(watchdog_time == 0)
         return;

      `cn_info(("Waiting for watchdog timeout at %0dns...", watchdog_time))
      #(watchdog_time * 1ns);

      `cn_err(("Watchdog Timeout! Objection report: %s", objector_report()));
      `cn_info(("Jumping to extract phase..."))

      timeout_occurred = 1;
      uvm_domain::jump_all(uvm_extract_phase::get());
   endtask : run_phase

   ////////////////////////////////////////////
   virtual function void final_phase(uvm_phase phase);
      if(timeout_occurred)
         `cn_fatal(("Exiting due to watchdog timeout."))
   endfunction : final_phase

   ////////////////////////////////////////////
   // func: objector_report
   // Prints out the list of objectors
   virtual function string objector_report();
      string s;
      uvm_object objectors[$];
      uvm_phase current_phase = env.get_current_phase();  // note: env is the global_env, since we're in the global_pkg

      if(current_phase == null) return "ERROR: Could not identify current phase/objection";
      current_phase.get_objection().get_objectors(objectors);

      s = {s,$sformatf("\n\nCurrently Executing Phase :   %s\n", current_phase.get_name())};
      s = {s,"\n-------------------------------------------------------------------------------\n"};
      s = {s,"                           List of Objectors   \n"};
      s = {s,"-------------------------------------------------------------------------------\n"};
      s = {s,"Hierarchical Name                              Class Type\n"};
      s = {s,"-------------------------------------------------------------------------------\n"};
      foreach(objectors[j]) begin
         s = {s, $sformatf("%-47s%s\n", objectors[j].get_full_name(), objectors[j].get_type_name())};
            end
      s = {s,"-------------------------------------------------------------------------------\n\n\n"};
      return s;

      // for each phase in schedule, print objectors
   endfunction : objector_report
endclass : watchdog_c

`endif // __GLOBAL_WATCHDOG_SV__
