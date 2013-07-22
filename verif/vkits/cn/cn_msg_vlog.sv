//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// ***********************************************************************
// * File        : cn_msg_vlog.sv
// * Author      : bdobbie
// * Description : Holds message registration from the verilog
// ***********************************************************************

`ifndef __CN_MSG_VLOG__
 `define __CN_MSG_VLOG__

`include "cn_msgs.sv"
`include "cn_string_utils.sv"

// Class: msg_vlog_c
// An object to represent verilog heirachy for printing
class msg_vlog_c extends uvm_component;

   // This is a uvm component but does use the component macros because it
   // should never be used with factory overrides.

   // Variable: scope_registry
   //
   // The scope_registry is an associative array of tag_name strings indexed by
   // tag_scope strings.  The scope_registry should only be accessed from the
   // root msg_vlog_c instance.
   string scope_registry[string];


   // Constructor: new
   function new(string name="vlog",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   // Func: get_vlog_root
   //
   // Gets the singleton root msg_vlog_c.
   static function msg_vlog_c get_vlog_root();
      if(msg_vlog_root == null) begin
         msg_vlog_root = new();
      end

      return msg_vlog_root;
   endfunction : get_vlog_root

   // Func: register_leaf
   //
   // Registers a cn_msg_tag instance by storing its scope and name
   function msg_vlog_c register_leaf(string _scope, string _name);
      msg_vlog_c root;
      string subscopes[$];
      string tag_scope;
      string tag_name;

      `cn_dbg(UVM_HIGH,("msg_vlog_c::register_leaf called with (scope='%s',_name='%s')",
                        _scope,_name))

      if (get_parent() != uvm_root::get())
        `cn_fatal(("register_leaf() can only be called on the the root msg_vlog_c instance"))

      root = get_vlog_root();

      // split the scope into subscopes
      cn_pkg::split_string(_scope, ".", subscopes);
      if (subscopes.size == 0)
        `cn_fatal(("illegal subscope queue with size of zero"))

      // trim the 'cn_msg_tag' subscope off the end
      if (subscopes[$] != "cn_msg_tag")
        `cn_fatal(("scope should end in 'cn_msg_tag', not %s",subscopes[$]))
      subscopes.pop_back();

      // form the tag_scope by joining the remaining subscopes
      tag_scope = cn_pkg::join_string(subscopes, ".");

      // default the name to the scope's leaf if no name specified
      if (_name == "")
        tag_name = subscopes[$];
      else
        tag_name = _name;

      // put tag_name into a hash indexed by tag_scope
      scope_registry[tag_scope] = tag_name;

      `cn_dbg(UVM_HIGH,("msg_vlog_c added scope_registry[%s]='%s'",
                        tag_scope,tag_name))

      return root;
   endfunction : register_leaf

   // Func: get_vlog_leaf
   //
   // Adds a new leaf to the vlog root to represent a portion of the verilog
   // heirarchy
   function msg_vlog_c get_vlog_leaf(string _scope);
      msg_vlog_c root;
      msg_vlog_c leaf;
      string subscopes[$];
      string tagscopes[$];
      string chk_scope;
      string chk_name;
      string chk_subnames[$];

      `cn_dbg(UVM_HIGH,("msg_vlog_c::get_vlog_leaf called with (_scope='%s')",
                        _scope))

      if (get_parent() != uvm_root::get())
        `cn_fatal(("get_vlog_leaf() can only be called on the root msg_vlog_c instance"))

      root = get_vlog_root();

      // split the scope into subscopes
      cn_pkg::split_string(_scope, ".", subscopes);
      if (subscopes.size == 0)
        `cn_fatal(("illegal subscope queue with size of zero"))

      // trim the 'cn_msg_tag' subscope off the end
      if (subscopes[$] == "cn_msg_tag")
        subscopes.pop_back();
      else
        `cn_fatal(("scope should end in 'cn_msg_tag', not %s",subscopes[$]))

      // reverse iterate through subscopes to build up condensed hierarchy
      while (subscopes.size()) begin
         chk_scope = cn_pkg::join_string(subscopes, ".");

         if (root.scope_registry.exists(chk_scope)) begin

            `cn_dbg(UVM_HIGH,("msg_vlog_c found scope_registry[%s]='%s'",
                              chk_scope,root.scope_registry[chk_scope]))

            // get chk_name from the scope_registry
            chk_name = root.scope_registry[chk_scope];

            // IDEA: check for '^' at beginning of chk_name, and snap it to the root

            // futher split chk_name by '.' before pushing into tagscopes array
            cn_pkg::split_string(chk_name, ".", chk_subnames);
            while (chk_subnames.size()) begin
               tagscopes.push_front(chk_subnames[$]);
               chk_subnames.pop_back();
               `cn_dbg(UVM_HIGH,("msg_vlog_c added a tagscope of '%s' for '%s'",
                                 tagscopes[0],chk_name))
            end

         end else begin

            `cn_dbg(UVM_HIGH,("msg_vlog_c scope_registry[%s] not found",
                              chk_scope))

         end
         subscopes.pop_back();
      end

      `cn_dbg(UVM_HIGH,("msg_vlog_c calculated a compressed scope of '%s'",
                        cn_pkg::join_string(tagscopes, ".")))

      // check for a compressed scope of size zero
      if (tagscopes.size() == 0)
        `cn_fatal(("calculated a compressed scope of size zero"))

      // check that vlog is the root of the compressed scope
      if (tagscopes[0] != "vlog")
        `cn_fatal(("vlog must be the root of the compressed scope='%s'",
                   cn_pkg::join_string(tagscopes, ".")))

      // check that vlog doesn't appear elsewhere in the compressed scope
      foreach (tagscopes[s])
        if (s > 0 && tagscopes[s] == "vlog")
          `cn_fatal(("vlog is only allowed at the root of the compressed scope='%s'",
                     cn_pkg::join_string(tagscopes, ".")))

      // iterate through tagscopes to build up component hierarchy
      foreach (tagscopes[s]) begin
         if (tagscopes[s].len() == 0) begin

            `cn_fatal(("illegal subscope element with length of zero"))

         end else if (tagscopes[s] == "vlog") begin

            `cn_dbg(UVM_HIGH,("msg_vlog_c with name '%s' exists, because it's the root",
                              tagscopes[s]))
            leaf = root;

         end else if (leaf.has_child(tagscopes[s])) begin

            `cn_dbg(UVM_HIGH,("msg_vlog_c with name '%s' exists, child of '%s'",
                              tagscopes[s],leaf.get_full_name()))
            $cast(leaf, leaf.get_child(tagscopes[s]));

         end else begin

            `cn_dbg(UVM_HIGH,("msg_vlog_c with name '%s' created, child of '%s'",
                              tagscopes[s],leaf.get_full_name()))
            leaf = new(tagscopes[s], leaf);

         end
      end

      // return resulting leaf
      return leaf;
   endfunction : get_vlog_leaf

endclass : msg_vlog_c

static msg_vlog_c msg_vlog_root;

`endif
