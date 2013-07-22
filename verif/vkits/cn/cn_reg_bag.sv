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
// * (utg v0.8)
// ***********************************************************************
// File:   cn_bag.sv
// Author: perveil
/* About:  A convenience class to provide bag-like operations for register collections.
 *************************************************************************/

`ifndef __CN_REG_BAG_SV__
`define __CN_REG_BAG_SV__

`include "cn_bag.sv"
// class: reg_bag_c
// A conveninece class to provide bag-like operations for register collections
class reg_bag_c;

   //----------------------------------------------------------------------------------------
   // Group: Constants
   
   //----------------------------------------------------------------------------------------
   // Group: Fields
   // var: offset_bag
   // The bag of register offsets
   local cn_bag_c #(uvm_reg_addr_t) offset_bag;

   // var: reg_aa
   // A mapping between uvm_regs and their associated offsets
   local uvm_reg reg_aa[uvm_reg_addr_t];
   
   //----------------------------------------------------------------------------------------
   // Group: Constraints

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="reg_bag");
      offset_bag = new("reg_bag__offset_bag");
   endfunction : new

   //Adds all of the registers from _reg_block to the bag.
   function void push(uvm_reg_block _reg_block);
      uvm_reg reg_q[$];
      
      // Gather up all the regs.  reg_q is non-deterministic at this point (stupid uvm/vcs).
      _reg_block.get_registers(reg_q);
      
      // Sort by offset.  HAVE TO ADD TO THE BAG IN A DETERMINISTIC MANNER OR YOU DON'T GET DETERMINISTIC RESULTS!
      reg_q.sort() with (item.get_offset());   

      // Add the offsets to the bag now that req_q is determistic.  Keep a mapping of offset to reg too.
      foreach (reg_q [i]) begin
         uvm_reg_addr_t offset = reg_q[i].get_offset();
         offset_bag.push(offset);
         reg_aa[offset] = reg_q[i];
      end
   endfunction

   //Returns true if bag is empty.
   function int empty();
      return (offset_bag.empty());
   endfunction
   
   //Returns number of entries in the bag.
   function int unsigned size();
      return offset_bag.size();
   endfunction

   //Set recycle on empty flag. When set, if a pop() empties the bag, all entries in the marked list will get dumped into the bag.
   function void set_recycle_on_empty(int _enable);
      offset_bag.set_recycle_on_empty(_enable);
   endfunction

   //Returns a random entry from the bag.  Does NOT remove entry.
   function uvm_reg peek();
      uvm_reg_addr_t offset = offset_bag.peek();
      return reg_aa[offset];
   endfunction

   //Returns a random entry from the bag.  Entry is removed from the bag.  If bag is empty, returns 0.
   function int pop(output uvm_reg _reg);
      uvm_reg_addr_t offset;
      int pop_result;
      
      pop_result = offset_bag.pop(offset);
      if (pop_result) begin
         _reg = reg_aa[offset];
      end

      return pop_result;
   endfunction

   //Remove all elements from the bag of the specified value.  Returns the number of removed items.
   function int remove(uvm_reg _reg);
      uvm_reg_addr_t offset = _reg.get_offset();
      int remove_result;
      
      remove_result = offset_bag.remove(offset);
      if (reg_aa.exists(offset)) begin
         reg_aa.delete(offset);
      end

      return remove_result;
   endfunction

   // func: remove_q
   // Removes all items in excl_q from the reg_bag
   virtual function void remove_q(uvm_reg _excl_q[$]);
      foreach (_excl_q [i]) begin
         remove(_excl_q[i]);
      end
   endfunction : remove_q
   
   //Returns size of the marked list
   function int marked_size();
      return offset_bag.marked_size();
   endfunction
   
   ////////////////////////////////////////////
   // func: convert2string
   // Single-line printing function
   virtual function string convert2string();
      return offset_bag.convert2string();
   endfunction : convert2string

endclass : reg_bag_c

`endif // __CN_REG_BAG_SV__

