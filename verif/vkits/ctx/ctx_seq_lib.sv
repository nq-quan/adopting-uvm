
// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2013
// * (utg v0.8)
// ***********************************************************************
// File:   ctx_seq_lib.sv
// Author: bhunter
/* About:  An sequence library for CTX
 *************************************************************************/

`ifndef __CTX_SEQ_LIB_SV__
   `define __CTX_SEQ_LIB_SV__


   `include "ctx_item.sv"
   `include "ctx_types.sv"

//****************************************************************************************
// class: rd_seq_c
// A read sequence
class rd_seq_c extends uvm_sequence #(item_c);
   `uvm_object_utils_begin(ctx_pkg::rd_seq_c)
      `uvm_field_int(addr, UVM_DEFAULT | UVM_HEX)
      `uvm_field_int(data, UVM_DEFAULT | UVM_HEX)
   `uvm_object_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Fields

   // field: addr
   rand addr_t addr;

   // field: result data
   data_t data;

   //----------------------------------------------------------------------------------------
   // Group: Methods

   function new(string name="rd_seq");
      super.new(name);
   endfunction : new

   ////////////////////////////////////////////
   // func: body
   virtual task body();
      item_c item;

      `cn_seq_raise;

      `uvm_create(item)
      item.is_write = 0;
      item.addr = addr;
      `uvm_send(item)
      data = item.data;

      `cn_seq_drop;
   endtask : body

endclass : rd_seq_c

//****************************************************************************************
// class: rd_seq_c
// A write sequence
class wr_seq_c extends uvm_sequence #(item_c);
   `uvm_object_utils_begin(ctx_pkg::wr_seq_c)
      `uvm_field_int(addr, UVM_DEFAULT | UVM_HEX)
      `uvm_field_int(data, UVM_DEFAULT | UVM_HEX)
   `uvm_object_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Fields

   // field: addr
   rand addr_t addr;

   // field: write data
   rand data_t data;

   //----------------------------------------------------------------------------------------
   // Group: Methods

   function new(string name="rd_seq");
      super.new(name);
   endfunction : new

   ////////////////////////////////////////////
   // func: body
   virtual task body();
      item_c item;

      `cn_seq_raise;

      `uvm_create(item)
      item.is_write = 1;
      item.addr = addr;
      item.data = data;
      `uvm_send(item)

      `cn_seq_drop;
   endtask : body

endclass : wr_seq_c


`endif // __CTX_SEQ_LIB_SV__
