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
// * (c) 2013, Cavium, Inc.  All rights reserved.                      
// * (utg v0.8)
// ***********************************************************************
// File:   ctx_reg_adapter.sv
// Author: bhunter
/* About:  Register adapter for CTX
 *************************************************************************/

`ifndef __CTX_REG_ADAPTER_SV__
   `define __CTX_REG_ADAPTER_SV__


   
// class: reg_adapter_c
// (Description)
class reg_adapter_c extends uvm_reg_adapter;
   `uvm_object_utils(ctx_pkg::reg_adapter_c)

   //----------------------------------------------------------------------------------------
   // Group: Methods

   function new(string name="reg_adapter");
      super.new(name);
   endfunction : new

   ////////////////////////////////////////////
   // func: reg2bus
   virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
      item_c item = new("item");

      item.is_write = (rw.kind == UVM_WRITE);
      item.addr = rw.addr[6:0];
      if(item.is_write)
         item.data = rw.data;
      return item;
   endfunction : reg2bus

   ////////////////////////////////////////////
   // func: bus2reg
   virtual function void bus2reg(uvm_sequence_item bus_item, 
                                 ref uvm_reg_bus_op rw);
      item_c item;

      if($cast(item, bus_item)) begin
         rw.kind = (item.is_write)? UVM_WRITE : UVM_READ;
         rw.addr = item.addr;
         rw.data = item.data;
         rw.status = UVM_IS_OK;
      end
   endfunction : bus2reg
      
endclass : reg_adapter_c
   
`endif // __CTX_REG_ADAPTER_SV__
