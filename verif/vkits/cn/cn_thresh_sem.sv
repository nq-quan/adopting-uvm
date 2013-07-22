//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * Copyright 2013,
// * (utg v0.8.2)
// ***********************************************************************
// File:   cn_thresh_sem.sv
// Author: perveil
/* About:  A "threshold" semaphore.  When the threshold is hit all waiters are awoken.
 *************************************************************************/

`ifndef __CN_THRESH_SEM_SV__
   `define __CN_THRESH_SEM_SV__


// class: thresh_sem_c
// A "threshold" semaphore.  When the threshold is hit all waiters are awoken.  Calls to get() after
// the threshold has been hit will immediately return.
class thresh_sem_c extends uvm_object;
   `uvm_object_utils_begin(cn_pkg::thresh_sem_c)
      `uvm_field_int(threshold, UVM_ALL_ON)
      `uvm_field_int(count, UVM_ALL_ON)
   `uvm_object_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Fields
   // var: threshold
   // The number of puts that must occur before all waiters are awoken
   int unsigned threshold;
   
   // var: count
   // The current number of puts that have occurred so far
   local int unsigned count;
   
   // var: wakeup_event
   // An event that triggers when the threshold has been reached
   local event wakeup_event;
   
   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="thresh_sem");
      super.new(name);
   endfunction : new

   // func: put
   // Increments the count.  If the threshold is reached then waiting threads will be awoken.
   virtual     function void put();
      ++count;
      if (count == threshold) begin
         -> wakeup_event;
      end
   endfunction : put

   // func: get
   // If the threshold has already been hit then this function returns immediately.  Otherwise it blocks until the
   // threshold has been met
   task get();
      if (count >= threshold) begin
         return;
      end
      else begin
         @wakeup_event;
      end
   endtask : get

   ////////////////////////////////////////////
   // func: convert2string
   // Single-line printing function
   virtual function string convert2string();
      return $sformatf("threshold: %d count: %d", threshold, count);
   endfunction : convert2string

endclass : thresh_sem_c

`endif // __CN_THRESH_SEM_SV__

