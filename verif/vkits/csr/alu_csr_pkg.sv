//-*-
 verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2013
// * (utg v0.8)
// ***********************************************************************
// File:   alu_csr_pkg.sv
// Author: bhunter
/* About:  ALU CSR package
 *************************************************************************/

`ifndef __ALU_CSR_PKG__SV__
   `define __ALU_CSR_PKG__SV__

package alu_csr_pkg;

   import uvm_pkg::*;

//****************************************************************************************
class const_reg_c extends uvm_reg;

   `uvm_object_utils(alu_csr_pkg::const_reg_c)

   rand uvm_reg_field C_VAL;
   rand uvm_reg_field K_VAL;
   rand uvm_reg_field RSVD0;

   function new(string name="const_reg");
      super.new(.name(name), .n_bits(64), .has_coverage(UVM_CVR_ALL));
   endfunction

   function void build();
      C_VAL = uvm_reg_field::type_id::create(.name("C_VAL"), .parent(null), .contxt(get_full_name()));
      K_VAL = uvm_reg_field::type_id::create(.name("K_VAL"), .parent(null), .contxt(get_full_name()));
      RSVD0 = uvm_reg_field::type_id::create(.name("RSVD0"), .parent(null), .contxt(get_full_name()));

      C_VAL.configure(.parent(this), .size(8), .lsb_pos(0),.access("RW"), .volatile(0), .reset(8'h0),.has_reset(1), .is_rand(1), .individually_accessible(0));
      C_VAL.set_reset(8'h0, "SOFT");
      K_VAL.configure(.parent(this), .size(8), .lsb_pos(8),.access("RW"), .volatile(0), .reset(8'h1),.has_reset(1), .is_rand(1), .individually_accessible(0));
      K_VAL.set_reset(8'h1, "SOFT");
      RSVD0.configure(.parent(this), .size(48), .lsb_pos(16),.access("RO"), .volatile(0), .reset(48'h0),.has_reset(1), .is_rand(1), .individually_accessible(0));
   endfunction
endclass

//****************************************************************************************
class result_reg_c extends uvm_reg;

   `uvm_object_utils(alu_csr_pkg::result_reg_c)

   rand uvm_reg_field SOR;
   rand uvm_reg_field RSVD0;


   function new(string name="%(reg_class_name)s");
      super.new(.name(name), .n_bits(64), .has_coverage(UVM_CVR_ALL));
   endfunction

   function void build();
      SOR = uvm_reg_field::type_id::create(.name("SOR"), .parent(null), .contxt(get_full_name()));
      RSVD0 = uvm_reg_field::type_id::create(.name("RSVD0"), .parent(null), .contxt(get_full_name()));

      SOR.configure(.parent(this), .size(32), .lsb_pos(0),.access("RC"), .volatile(1), .reset(32'h0),.has_reset(1), .is_rand(1), .individually_accessible(0));
      SOR.set_reset(32'h0, "SOFT");
      SOR.set_compare(UVM_NO_CHECK);
      RSVD0.configure(.parent(this), .size(32), .lsb_pos(32),.access("RO"), .volatile(0), .reset(32'h0),.has_reset(1), .is_rand(1), .individually_accessible(0));
   endfunction

endclass


//****************************************************************************************
class reg_block_c extends uvm_reg_block;
   `uvm_object_utils(alu_csr_pkg::reg_block_c)

   const uvm_reg_addr_t base = `UVM_REG_ADDR_WIDTH'h0;
   const uvm_reg_addr_t step = `UVM_REG_ADDR_WIDTH'h4;
   const string map_name = "csr_map";
   uvm_reg_map csr_map;

   rand const_reg_c CONST;
   rand result_reg_c RESULT;

   function new(string name="csr_reg_block");
      super.new(name);
   endfunction

   virtual 	function uvm_reg_addr_t get_base_addr(int index=0);
      return base + (index * step);
   endfunction

   virtual 	function void init_map(ref uvm_reg_map mp, input uvm_reg_addr_t offset = 0);
      mp.add_reg(CONST, offset + `UVM_REG_ADDR_WIDTH'h20);
      mp.add_reg(RESULT, offset + `UVM_REG_ADDR_WIDTH'h24);
   endfunction

   virtual 	function uvm_reg_map build_map(string name, uvm_reg_addr_t base_addr = `UVM_REG_ADDR_WIDTH'h0, int unsigned n_bytes = 8, uvm_endianness_e endian = UVM_LITTLE_ENDIAN, bit byte_addressing = 1'b1);
      uvm_reg_map mp;
      mp = create_map(name,base_addr,n_bytes,endian,byte_addressing);
      init_map(mp);
      return mp;
   endfunction

   virtual 	function void build();
      int 	index_list[];
      CONST = const_reg_c::type_id::create("CONST");
      CONST.configure(this);
      CONST.build();

      RESULT = result_reg_c::type_id::create("RESULT");
      RESULT.configure(this);
      RESULT.build();

      csr_map = build_map(map_name);
      csr_map.set_base_addr(get_base_addr());
      default_map = csr_map;
   endfunction

endclass

endpackage : alu_csr_pkg

`endif
