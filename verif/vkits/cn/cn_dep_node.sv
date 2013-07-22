//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// * CAVIUM CONFIDENTIAL                                                 
// *                                                                     
// *                         PROPRIETARY NOTE                            
// *                                                                     
// * This software contains information confidential and proprietary to  
// * Cavium, Inc. It shall not be reproduced in whole or in part, or     
// * transferred to other documents, or disclosed to third parties, or   
// * used for any purpose other than that for which it was obtained,     
// * without the prior written consent of Cavium, Inc.                   
// * (c) 2012, Cavium, Inc.  All rights reserved.                      
// * (utg v0.7.2)
// ***********************************************************************
// File:   cn_dep_node.sv
// Author: perveil
/* About:  A dependency node.  Supports linking to nodes that depend on this node as well as 
           nodes this node depends on.
 
 Nodes have two main properties:
 1. Dependence on other nodes
 2. A "condition", which is a property that must be met (aside from node dependencies)
 
 Nodes are "link"ed together to form dependency graphs.
 Nodes are "resolved" when they depend on no other nodes AND their conditions are met.
 Nodes perform their "action" after they resolve.
  
 Whenever external software detects an event that may cause a condition change it should 
 attempt to resolve nodes via try_resolve().
 
 An example:
 ----------- 
 A predictor makes hypothetical REQ and RSP nodes.  The RSP node depends on the REQ node.
 The REQ node's condition is that a request is actually seen.
 The RSP node's condition is that a response is actually seen.
 
 Whenever the predictor detects a change to a condition (a REQ is seen, for example) it attempts
 to move things along by calling try_resolve().  condition_met() can be a handy way to encapsulate this process.
 
 Since the REQ node depends on no other nodes it can resolve when the condition (REQ seen) is met.
 Since the RSP node depends on the REQ node it is an error if its condition is met (RSP seen) while it still depends on the REQ.

 The REQ node's action may be to make a RSP prediction.
 The RSP node's action may be to check the RSP data vs the prediction.
 
 Typical usage:
 --------------
 dep_node_c is typically derived from and the following functions are overridden:
 1. is_condition_met().  Overridden to return 1 when some outside condition is met.  By default the condition is NEVER met.  If this is done
    in such a way that the variable condition_met is no longer used then it is advisable to override set_condition_met() as well.
 2. do_action().  Overridden to actually do something after the node resolves (when all dependencies and conditions are met).
    By default it does nothing.
 
 
 *************************************************************************/

`ifndef __CN_DEP_NODE_SV__
   `define __CN_DEP_NODE_SV__

    `include "cn_self_test.sv"
   
// (`includes go here)

// class: dep_node_c
// (Describe me)
class dep_node_c extends uvm_object;
   `uvm_object_utils_begin(cn_pkg::dep_node_c)
      `uvm_field_int(condition_met, UVM_ALL_ON)
      `uvm_field_int(cares_about_condition, UVM_ALL_ON)
      `uvm_field_int(did_action, UVM_ALL_ON)
   `uvm_object_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Fields
   // var: condition_met
   // Used by the default is_condition_met() to determine whether the condition is met or not.  
   bit condition_met;

   // var: cares_about_condition
   // If 0 then the condition check is skipped (ie the condition will be considered always met and will
   // not throw errors when the node resolves.  This allows the creation of "meta" nodes... nodes
   // that have no condition but still have dependencies.
   bit cares_about_condition;
   
   // var: depends_on_me
   // Associative array keyed off of a reference to a dep_node_c.  Is a collection of nodes
   // that depend on this node.
   dep_node_c depends_on_me[dep_node_c];

   // var: i_depend_on
   // Associative array keyed off of a reference to a dep_node_c.  Is a collection of nodes
   // that this node depends on.
   dep_node_c i_depend_on[dep_node_c];

   // var: did_action
   // Is set whenever the node as performed it's action.  Is used to prevent do_action from taking effect
   // multiple times.
   bit did_action;
   
   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="dep_node");
      super.new(name);

      // By default the condition is not met.  
      condition_met = 0;
      // By default we care about conditions
      cares_about_condition = 1;
   endfunction : new


   // func: link
   // Adds _depender as a node who now depends on this _provider
   static function void link(dep_node_c _depender, dep_node_c _provider);
      // Don't allow depending on oneself.
      if (_depender == _provider)
        return;
      
      _provider.depends_on_me[_depender] = _depender;
      _depender.i_depend_on[_provider]   = _provider;
   endfunction : link

   // func: link_queue
   // Adds _depender as a node who now depends on every node in _provider_q
   static function void link_queue(dep_node_c _depender, dep_node_c _provider_q[$]);
      // Don't allow depending on oneself.  It's safe, but meaningless.
      foreach (_provider_q [index]) begin
         link(_depender, _provider_q[index]);
      end
   endfunction : link_queue

   // func: unlink
   // Breaks the link between this node and _depender
   function void unlink(dep_node_c _depender);
      if (!depends_on_me.exists(_depender)) begin
         `cn_err(("Trying to unlink %s from %s, but they aren't linked to begin with!", _depender.convert2string(), this.convert2string()))
         return;
      end
      depends_on_me.delete(_depender);
   endfunction : unlink
   
   // func: resolved
   // A node this node depends on has resolved, unconnect our end and attempt to resolve
   function void resolved(dep_node_c _resolved_node);
      `cn_dbg(UVM_HIGH,("Inside resolved (from %s).", _resolved_node.get_name()))
      // _resolved_node is done so I don't depend on him any more
      i_depend_on.delete(_resolved_node);
      try_resolve();
   endfunction : resolved
   

   // func: try_resolve
   // Checks to see if this node still depends on other nodes.  If not, perform the node's action
   // and broadcast that it is resolved.  Note that do_action() will only be called once per node so
   // calling try_resolve on a resolved node is safe.
   function void try_resolve();
      if (is_condition_met()) begin
         if (i_depend_on.size() == '0) begin
            // Not waiting on anybody.  Do our thing, but only once (makes it safe to call try_resolve on a resolved node)
            if (!did_action) begin
               do_action();
            end
            
            // Tell everybody who depends on us that we've resolved
            foreach (depends_on_me[i]) begin
               depends_on_me[i].resolved(this);
            end
            
            // Since nobody depends on me anymore, clear my array.
            depends_on_me.delete();
         end
         else begin
            if (cares_about_condition) begin
               // The condition was met before all dependencies were resolved.  Error
               `cn_err(("%s: condition is met before dependencies resolved", this.convert2string()))
            end
         end
      end // try_resolve()
   endfunction : try_resolve

   // func: force_resolve()
   // Resolves the node whether dependancies are met or not.  No errors will be thrown for condition reasons.
   function void force_resolve();
      // Tweak this node so that the standard try_resolve will succeed
      // Make upstream nodes forget about us
      foreach (i_depend_on [index]) begin
         i_depend_on[index].unlink(this);
      end

      // Don't depend on anyone any more, delete our array
      i_depend_on.delete();

      // We're going to resolve regardless of condition
      cares_about_condition = 0;
      
      // We should look like any other done node now, try to resolve.
      try_resolve();
   endfunction : force_resolve

   // func: do_action
   // Performs the "meat" of the node.  Called whenever this node is resolved.
   virtual function void do_action();
      did_action = 1;
      `cn_dbg(UVM_HIGH,("Inside do_action"))
   endfunction : do_action


   // func: is_condition_met
   // Returns 1 if the node's "condition" has been satisfied.  Dependence on other nodes is not considered here.
   virtual function bit is_condition_met();
      `cn_dbg(UVM_HIGH,("Inside is_condition_met"))
      return condition_met || !cares_about_condition;
   endfunction : is_condition_met

   // func: set_condition_met
   // The "condition" for this node has been satisfied.  Sets the appropriate internal flags and attempts to resolve.
   virtual function void set_condition_met();
      if (condition_met) begin
         `cn_err(("Condition is already met for this node, but it is being satisfied again: %s", convert2string()))
      end

      condition_met = 1;
      try_resolve();
   endfunction : set_condition_met
   
   virtual function string get_id_str();
      return get_name();
   endfunction : get_id_str
   
   // func: convert2string
   // Single-line printing function
   virtual function string convert2string();
      convert2string = $sformatf("%s ->", get_id_str());
      if (i_depend_on.size()) begin
         foreach (i_depend_on[i]) begin
            $sformat(convert2string, "%s %s", convert2string, i_depend_on[i].get_id_str());
         end
      end
      else begin
         $sformat(convert2string, "%s (nobody)", convert2string);
      end
      return convert2string;
   endfunction : convert2string
   
endclass : dep_node_c
   
//****************************************************************************************
//* SELF-TEST
//****************************************************************************************
`ifdef __SELF_TEST__
class self_test_c extends uvm_test;
   `uvm_component_utils(cn_pkg::self_test_c)

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="self_test",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   // func: run_phase
   virtual task run_phase(uvm_phase phase);      
      // (do stuff!)
      // Make some dep nodes
      dep_node_c node_a = new("node_a");
      dep_node_c node_b = new("node_b");
      dep_node_c node_c = new("node_c");

      // Set the verbosity to UVM_HIGH so I can see my messages
      uvm_top.set_report_verbosity_level_hier(UVM_HIGH);
      
      // Make nodes b and c depend on a
      dep_node_c::link(node_a, node_b);
      dep_node_c::link(node_a, node_c);

      // Try and resolve node b.  Should throw error (condition met but deps not)
      `cn_info(("Trying to resolve node b, should throw error"))
      node_b.try_resolve();

      // Try and resolve node a.  Should work (and cause nodes b and c to resolve as well)
      `cn_info(("Trying to resolve node a, should cause b and c to resolve as well."))
      node_a.try_resolve();


   endtask : run_phase

endclass : self_test_c
`endif // __SELF_TEST__
`endif // __CN_DEP_NODE_SV__