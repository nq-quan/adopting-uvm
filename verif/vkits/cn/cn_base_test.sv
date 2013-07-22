//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// * CAVIUM CONFIDENTIAL AND PROPRIETARY NOTE
// *
// * This software contains information confidential and proprietary to
// * Cavium, Inc. It shall not be reproduced in whole or in part, or
// * transferred to other documents, or disclosed to third parties, or
// * used for any purpose other than that for which it was obtained,
// * without the prior written consent of Cavium, Inc.
// * Copyright 2012, Cavium, Inc.  All rights reserved.
// * (utg v0.8.2)
// ***********************************************************************
// File:   base_test.sv
// Author: perveil
/* About:  A base test to provide abstraction around our uvm phasing guidelines.
 *************************************************************************/

`ifndef __CN_BASE_TEST_SV__
   `define __CN_BASE_TEST_SV__


// (`includes go here)

// class: base_test_c
// (Describe me)
class base_test_c extends uvm_test;
   `uvm_component_utils_begin(cn_pkg::base_test_c)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   //----------------------------------------------------------------------------------------
   // Group: Fields
   // var: main_phase_started
   // An event that is poked when the main_phase has been detected by this test.
   event   main_phase_started;

   //----------------------------------------------------------------------------------------
   // Group: Methods

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="base_test",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   // func: run_phase
   // Waits for the main phase to begin and then starts background sequences.  Per phasing guidelines no objections are raised.  All background sequences
   // must complete in a timely fashion after the ending of the main phase (not enforced here, up to user)
   virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);

      fork
         begin
            // Wait for the main_phase to start (so that we arent's ending transactions during reset, bist, configuration, etc).
            wait(main_phase_started.triggered);
            
            start_background_seqs();
            wait fork; // Wait for ALL child processes (need all vseqs' seqs to complete on all sqrs before we let the phase end).
         end
      join
   endtask : run_phase

   ////////////////////////////////////////////
   // func: main_phase
   // Signals the start of the phase so that waiters can proceed.  Per phasing guidelines an objection is raised at the end of the sequence and then
   // dropped when the last transaction is sent.
   virtual task main_phase(uvm_phase phase);
      super.main_phase(phase);

      // Signal the beginning of the main_phase
      -> main_phase_started;
      
      phase.raise_objection(this);
      fork 
         begin
            start_foreground_seqs();
            wait fork; // Wait for ALL child processes (need all vseqs' seqs to complete on all sqrs before we let the phase end).
         end
      join
      phase.drop_objection(this);
   endtask : main_phase

   ////////////////////////////////////////////
   // func: start_foreground_seqs
   // Override this task to start sequences that should run in the foreground (ie "True" stimulus sequences, not "background" sequences)
   virtual task start_foreground_seqs();
      // Empty, tests should override to do something
   endtask : start_foreground_seqs

   ////////////////////////////////////////////
   // func: start_background_seqs
   // Override this task to start sequences that should run in the background (ie "background" stimulus sequences, not "True" stimulus sequences)
   virtual task start_background_seqs();
      // Empty, tests should override to do something
   endtask : start_background_seqs

endclass : base_test_c

`endif // __CN_BASE_TEST_SV__

