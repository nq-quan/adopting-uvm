//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-
// ***********************************************************************
// *
// * legal mumbo jumbo
// *
// * Copyright 2012,
// * (utg v0.8.2)
// ***********************************************************************
// * File        : cn_uid.sv
// * Author      : perveil + jschroeder
// * Description : Common package ID object.
// ***********************************************************************

// File: uid_c

`ifndef __CN_UID_SV__
   `define __CN_UID_SV__

// Class: uid_pool_c
// This dumb class is just a uid_array wrapper.  I needed a way to call set_scope_cn_uid_dpi() at the beginning of time
// even if there weren't any uid_c's ever instantiated.  I built this class so that it can be instantiated statically inside
// uid_c and it's new() could then make the call to setup the dpi.
class uid_pool_c extends uvm_object;
   `uvm_object_utils(cn_pkg::uid_pool_c)

   function new(string name="");
      super.new(name);
      set_scope_cn_uid_dpi();
   endfunction

   int uid_array[string];
endclass


// Class: uid_c
// Object that represents a unique identification for a transaction.
// Transactions can include a <uid_c> field for ID purposes, and call
// <convert2string> on it to print out a useful identification string in the
// logfile.
//
// *extends uvm_object*
//
// <uid_c> objects are designed to be globally unique, and are identified by
// a string "prefix" and an integral "ID". The prefix identifies the ID pool
// from which a <uid_c's> ID is allocated, and the ID uniquely identifies the
// <uid_c> within that pool. Prefixes, or pool names, are typically used to
// identify the type of transaction that is carrying the <uid_c>, such as
// "PCIE" or "NCB", though there are no restrictions on this.
//
// When a <uid_c> is newly created, its prefix must be specified, and its ID is
// then allocated sequentially from the pool specified by the prefix. Each ID
// pool allocates IDs sequentially, independently of the others. The
// combination of prefix and ID uniquely identifies the <uid_c>. Thus, we may
// see <uid_cs> like the following in a simulation:
//
//| PCIE:000000, PCIE:000001, NCB:000000, PCIE:000002, NCB:000001, ...
//
// A DUT will often receive a transaction and, as a result, transmit one or more
// of the same or different type of transaction. For example, an AXI
// interconnection will receive an AXI transaction on one port and retransmit
// the transaction on a different port. In these cases, the verification
// environment should associate the received and transmitted transaction
// objects via their <uid_cs>. In the case where one received transaction
// results in only one transmitted transaction, the reference to the <uid_c>
// object itself should simply be copied from the received transaction to the
// transmitted object. For example:
//
//| class axi_interconnect_scoreboard_c extends uvm_component;
//|    ...
//|    axi_pkg::request_c received_request;
//|    axi_pkg::request_c transmitted_request;
//|    ...
//|    (Scoreboard sees a transmitted request on an output port and matches
//|       it to a previously received request.)
//|    ...
//|    transmitted_request.uid = received_request.uid;
//|    ...
//
// When the received request and transmit request are printed in the logfile,
// they can be easily associated, since they will print the same UID
// identification string.
//
// When a DUT receives a transaction and then transmits multiple transactions
// as a result, then the transmitted transactions should be allocated <uid_cs>
// that are sub-IDs of the received transactions's <uid_c>. For example, a
// shim receives AXI requests and generates mutiple NCB requests as a result:
//
//| class shim_scoreboard_c extends uvm_component;
//|    ...
//|    axi_pkg::request_c received_request;
//|    ncb_pkg::trans_c transmitted_request0, transmitted_request1;
//|    (Scoreboard sees a transmitted request on the NCB port and identifies it
//|       as one resulting from a previously received AXI request.)
//|    ...
//|    transmitted_request0.uid = received_request.uid.new_subid("NCB");  // Creates the new "NCB" subid and pulls the first id from the new pool
//|    transmitted_request1.uid = transmitted_request0.uid.next_uid();    // Pulls a new id from transmitted_request0.uid's pool (ie the new "NCB" subid we just created)
//|    ...
//
//  Or alternatively:
//|    transmitted_request0.uid = received_request.uid.new_subid("NCB");  // Creates the new "NCB" subid and pulls the first id from the new pool
//|    transmitted_request1.uid = received_request.uid.new_subid("NCB");  // Pulls a new id from the "NCB" subid of received_request
//
// Note the difference between the two examples.
//
// In the first example, transmitted_request0.uid is assigned a new uid whose id pool is that of the combination of received_request.uid and "NCB".
// transmitted_request1.uid uses transmitted_request0.uid.next_uid() because transmitted_request0 is already using the new combined pool (AXI:000237 NCB").
// Calling transmitted_request0.new_subid("NCB") would have resulted in an id looking like "AXI:000237 NCB:000000 NCB:000000" (note the second NCB:000000).
//
// In the second example, both transmitted_requests' uids are created by received_request.uid.new_subid("NCB").  Since received_request.uid is pulling from
// the "AXI:000237" pool, then calling new_subid("NCB") any number of times will always result in the new uid pulling from the "AXI:000237 NCB" pool.
//
// For either example, when the transactions are printed in the log the IDs will look like:
//
// | AXI:000237              (the original AXI request that was received)
// | AXI:000237 NCB:000000   (the first NCB request sent as a result)
// | AXI:000237 NCB:000001   (the second NCB request sent as a result)
//
// Thus, each NCB request will have a unique ID, and it can be readily
// associated with the AXI request that caused it.
//
// NOTICE:: It is very unwise to use the '.' (period) character in your uid's name or subid.  While technically not illegal, it
// will likely break config file constraints that use wildcards on the C side of things.  Right now I'm not enforcing this with code
// (so as to not incur a character scan of every prefix at creation time), but I can add it later if it gets to be a problem.

class uid_c extends uvm_object;

   `uvm_object_utils_begin(cn_pkg::uid_c)
      `uvm_field_string(prefix, UVM_ALL_ON)
      `uvm_field_int(my_id, UVM_ALL_ON | UVM_DEC)
   `uvm_object_utils_end

   //--------------------------------------------------------------------------
   // Group: Fields

   // public

   // Field: my_id
   // ID number of this <uid_c> object, within its <prefix> group.
   int            my_id;

   // Field: prefix
   // A name identifying the type of transaction. It is used to identify a
   // pool of ID numbers from which IDs are assigned. IDs are allocated
   // to new <uid_c> objects sequentially starting at 0. Each pool does its
   // own allocations independently of other pools, so the combination of
   // <prefix> and <my_id> uniquely identifies a <uid_c> object.
   string         prefix;

   // Top level pools from which IDs are allocated. Array of IDs, indexed by
   // prefix name.
   static uid_pool_c uid_pool = new();

   // field: parent_id
   // If this is a sub-id, then this parent will be set to it's parent
   uid_c parent_id;

   //--------------------------------------------------------------------------
   // Group: methods

   ////////////////////////////////////////////
   // Constructor: new
   // While this constructor fits the requirements of a uvm_object constructor
   // that would allow the use of the factory, it does have other optional
   // arguments.
   //
   // Arguments:
   //   name - The prefix name that will be set in the new <uid_c>, and which
   //     identifies the ID pool from which the ID will be allocated.
   //   preset_id_ (optional, and discouraged) - Can be used to force the
   //     <my_id> field to a previously allocated value, instead of allocating
   //     a new ID. This has the effect of creating a <uid_c> which has the
   //     same identification string as another. If not specified, a newly
   //     allocated ID value will be used for <my_id>. (The preferable method to
   //     "copy" a <uid_c> is to not copy it at all, but to share the object
   //     itself.)
   function new(string name="", int _preset_id=-1);
      super.new();

      // If name is "" then do nothing.  Allows creation of uid copies (the tlm bridge new()s the uid and then copies it's fields over from the c-side)
      if (name.len() == 0)
        return;

      // Set the <prefix> field.
      prefix = name;

      if (_preset_id != -1) begin
         assert (uid_pool.uid_array.exists(prefix)) else begin
            `cn_fatal(("preset_id (%0d) when no ID's assigned yet (prefix=%s).", _preset_id, prefix))
         end
         assert (_preset_id <= uid_pool.uid_array[prefix]) else begin
            `cn_fatal(("preset_id (%0d) is invalid (last=%0d prefix=%s)", _preset_id, uid_pool.uid_array[prefix], prefix))
         end
      end

      if (_preset_id == -1) begin
         // _preset_id was not specified (the usual case), allocate a new ID
         // from the pool.
         my_id = get_id(prefix);
      end
      else begin
         // If _preset_id was specified, we're reusing a previously allocated
         // ID, just assign it, and don't get an ID from the pool.
         my_id = _preset_id;
      end

   endfunction : new

   ////////////////////////////////////////////
   // Function: new_subid
   // Returns a new uid from the uid pool specified by the combination of this uid and _prefix
   //
   function uid_c new_subid(string _prefix="");
      string new_name = $sformatf("%s.%s", convert2string(), _prefix);
      new_subid = new(new_name);
      new_subid.parent_id = this;
      return new_subid;
   endfunction : new_subid


   ////////////////////////////////////////////
   // Function: get_id
   // Returns a new id from the uid pool specified by _prefix
   //
   static function int get_id(string _prefix);
      // If this is the first time we've seen this prefix, create a new pool.
      if (! uid_pool.uid_array.exists(_prefix)) begin
         uid_pool.uid_array[_prefix] = -1;
      end

      uid_pool.uid_array[_prefix]++;
      return uid_pool.uid_array[_prefix];
   endfunction : get_id

   ////////////////////////////////////////////
   // Function: next_uid
   // Returns a new uid_c with the next id from this uid_c's current pool.
   //
   function uid_c next_uid();
      next_uid = new(prefix);
      return next_uid;
   endfunction : next_uid;

   ////////////////////////////////////////////
   // Function: get
   // Get the <my_id> number of the last object allocated from the same pool
   // as this one.
   //
   // Returns:
   //   The ID number of the last object allocated from this pool.
   function int get();
      return uid_pool.uid_array[prefix];
   endfunction: get

   ////////////////////////////////////////////
   // Function: set
   // Directly clobbers the <my_id> field. (Use with care, if at all....)
   //
   // Arguments:
   //   id - The ID value to put in the <my_id> field.
   function void set(int id);
      my_id = id;
   endfunction: set

   ////////////////////////////////////////////
   // Function: set_prefix
   // Directly set the <prefix> field. (Why you would want to do this instead
   // of specifying it correctly in <new> or <new_subid>....)
   //
   // Arguments:
   //   my_prefix - Prefix value to put in the <prefix> field.
   function void set_prefix(string my_prefix);
      prefix = my_prefix;
   endfunction

   ////////////////////////////////////////////
   // Function: root
   // Return the root <uid_c> of this object. The root <uid_c> is the top of
   // the <parent_id> chain (i.e., the ancestor that has no parent).
   //
   // Returns:
   //   The root <uid_c> of this object.
   function uid_c root();
      root = this;
      while (root.parent_id != null)
         root = root.parent_id;
   endfunction

   ////////////////////////////////////////////
   // Function: convert2string
   // Implementation of the standard UVM convert2string method. Returns a short
   // string that uniquely identifies a <uid_c> and which is suitable for
   // including as part of a transaction object's "one-liner" description in
   // the logfile.
   virtual function string convert2string();
      return ($sformatf("%s:%06d", prefix, my_id));
   endfunction

endclass

import "DPI-C" function void set_scope_cn_uid_dpi();
export "DPI-C" function cn_uid_get_id_dpi;

function automatic int cn_uid_get_id_dpi(string _prefix);
   return uid_c::get_id(_prefix);
endfunction


`endif // __CN_UID_SV__