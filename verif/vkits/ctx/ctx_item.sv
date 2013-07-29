
// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2013
// * (utg v0.8)
// ***********************************************************************
// File:   ctx_mon.sv
// Author: bhunter
/* About:  An monitor for CTX
 *************************************************************************/

`ifndef __CTX_ITEM_SV__
   `define __CTX_ITEM_SV__

   `include "ctx_types.sv"

// class: item_c
// What a transaction looks like on the bus
class item_c extends uvm_sequence_item;
   `uvm_object_utils_begin(ctx_pkg::item_c)
      `uvm_field_int(is_write, UVM_DEFAULT)
      `uvm_field_int(addr,    UVM_DEFAULT | UVM_HEX)
      `uvm_field_int(data,    UVM_DEFAULT | UVM_HEX | UVM_NOPACK)
   `uvm_object_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Fields

   // field: is_write
   // When set, this item is a write. When clear, it's a read
   rand bit is_write;

   // field: addr
   // The address to read/write
   rand addr_t addr;

   // field: data
   // Either write data or read data
   rand data_t data;

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="item");
      super.new(name);
   endfunction : new

   ////////////////////////////////////////////
   // func: do_pack
   // Conditionally pack data bytes
   virtual function void do_pack(uvm_packer packer);
      super.do_pack(packer);

      if(is_write)
         packer.pack_field_int(data, 32);
   endfunction : do_pack

   ////////////////////////////////////////////
   // func: do_unpack
   // Data bytes will be seen for both read and write
   virtual function void do_unpack(uvm_packer packer);
      super.do_unpack(packer);

      data = packer.unpack_field_int(32);
   endfunction : do_unpack

   ////////////////////////////////////////////
   // func: convert2string
   // Single-line printing
   virtual function string convert2string();
      if(is_write)
         return $sformatf("WR %02X => %08X", addr, data);
      else
         return $sformatf("RD %02X <= %08X", addr, data);
   endfunction : convert2string

endclass : item_c

`endif // __CTX_ITEM_SV__

