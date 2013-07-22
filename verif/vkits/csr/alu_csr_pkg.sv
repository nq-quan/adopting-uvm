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
// File:   alu_csr_pkg.sv
// Author: bhunter
/* About:  ALU CSR package
 *************************************************************************/

`ifndef __ALU_CSR_PKG__SV__
   `define __ALU_CSR_PKG__SV__

package alu_csr_pkg;

   import uvm_pkg::*;

//****************************************************************************************
class const_reg_c extends csr_cn_pkg::cn_reg_c;

   `uvm_object_utils(alu_csr_pkg::const_reg_c)

   rand uvm_reg_field C_VAL;
   rand uvm_reg_field K_VAL;
   rand uvm_reg_field RSVD0;

   local uvm_reg_data_t m_current;
   local uvm_reg_data_t m_data;
   local uvm_reg_data_t m_be;
   local bit            m_is_read;

   covergroup cg_bits;
      option.per_instance = 1;
      C_VAL_b0: coverpoint {m_current[0],m_data[0]} iff (!m_is_read && m_be[0]);
      C_VAL_b1: coverpoint {m_current[1],m_data[1]} iff (!m_is_read && m_be[0]);
      C_VAL_b2: coverpoint {m_current[2],m_data[2]} iff (!m_is_read && m_be[0]);
      C_VAL_b3: coverpoint {m_current[3],m_data[3]} iff (!m_is_read && m_be[0]);
      C_VAL_b4: coverpoint {m_current[4],m_data[4]} iff (!m_is_read && m_be[0]);
      C_VAL_b5: coverpoint {m_current[5],m_data[5]} iff (!m_is_read && m_be[0]);
      C_VAL_b6: coverpoint {m_current[6],m_data[6]} iff (!m_is_read && m_be[0]);
      C_VAL_b7: coverpoint {m_current[7],m_data[7]} iff (!m_is_read && m_be[0]);
      K_VAL_b8: coverpoint {m_current[8],m_data[8]} iff (!m_is_read && m_be[0]);
      K_VAL_b9: coverpoint {m_current[9],m_data[9]} iff (!m_is_read && m_be[0]);
      K_VAL_b10: coverpoint {m_current[10],m_data[10]} iff (!m_is_read && m_be[0]);
      K_VAL_b11: coverpoint {m_current[11],m_data[11]} iff (!m_is_read && m_be[0]);
      K_VAL_b12: coverpoint {m_current[12],m_data[12]} iff (!m_is_read && m_be[0]);
      K_VAL_b13: coverpoint {m_current[13],m_data[13]} iff (!m_is_read && m_be[0]);
      K_VAL_b14: coverpoint {m_current[14],m_data[14]} iff (!m_is_read && m_be[0]);
      K_VAL_b15: coverpoint {m_current[15],m_data[15]} iff (!m_is_read && m_be[0]);
   endgroup

   covergroup cg_vals;
      option.per_instance = 1;
      C_VAL: coverpoint C_VAL.value[7:0];
      K_VAL: coverpoint K_VAL.value[7:0];
   endgroup

   function new(string name="const_reg");
      super.new(.name(name), .n_bits(64), .has_coverage(UVM_CVR_ALL));
      if (has_coverage(UVM_CVR_REG_BITS)) begin
         cg_bits = new();
      end
      if (has_coverage(UVM_CVR_FIELD_VALS)) begin
         cg_vals = new();
      end
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

   virtual function void sample(uvm_reg_data_t data,
                                uvm_reg_data_t byte_en,
                                bit            is_read,
                                uvm_reg_map    map);
      if (get_coverage(UVM_CVR_REG_BITS)) begin
         m_current = get();
         m_data    = data;
         m_be      = byte_en;
         m_is_read = is_read;
         cg_bits.sample();
      end
      sample_values();
   endfunction

   virtual function void sample_values();
      super.sample_values();
      if (get_coverage(UVM_CVR_FIELD_VALS)) begin
         cg_vals.sample();
      end
   endfunction
endclass

//****************************************************************************************   
class result_reg_c extends csr_cn_pkg::cn_reg_c;

   `uvm_object_utils(alu_csr_pkg::result_reg_c)

   rand uvm_reg_field SOR;
   rand uvm_reg_field RSVD0;

   local uvm_reg_data_t m_current;
   local uvm_reg_data_t m_data;
   local uvm_reg_data_t m_be;
   local bit            m_is_read;

   covergroup cg_bits;
      option.per_instance = 1;
      SOR_b0:   coverpoint {m_current[0],m_data[0]} iff (!m_is_read && m_be[0]);
      SOR_b1:   coverpoint {m_current[1],m_data[1]} iff (!m_is_read && m_be[0]);
      SOR_b2:   coverpoint {m_current[2],m_data[2]} iff (!m_is_read && m_be[0]);
      SOR_b3:   coverpoint {m_current[3],m_data[3]} iff (!m_is_read && m_be[0]);
      SOR_b4:   coverpoint {m_current[4],m_data[4]} iff (!m_is_read && m_be[0]);
      SOR_b5:   coverpoint {m_current[5],m_data[5]} iff (!m_is_read && m_be[0]);
      SOR_b6:   coverpoint {m_current[6],m_data[6]} iff (!m_is_read && m_be[0]);
      SOR_b7:   coverpoint {m_current[7],m_data[7]} iff (!m_is_read && m_be[0]);
      SOR_b8:   coverpoint {m_current[8],m_data[8]} iff (!m_is_read && m_be[0]);
      SOR_b9:   coverpoint {m_current[9],m_data[9]} iff (!m_is_read && m_be[0]);
      SOR_b10:  coverpoint {m_current[10],m_data[10]} iff (!m_is_read && m_be[0]);
      SOR_b11:  coverpoint {m_current[11],m_data[11]} iff (!m_is_read && m_be[0]);
      SOR_b12:  coverpoint {m_current[12],m_data[12]} iff (!m_is_read && m_be[0]);
      SOR_b13:  coverpoint {m_current[13],m_data[13]} iff (!m_is_read && m_be[0]);
      SOR_b14:  coverpoint {m_current[14],m_data[14]} iff (!m_is_read && m_be[0]);
      SOR_b15:  coverpoint {m_current[15],m_data[15]} iff (!m_is_read && m_be[0]);
      SOR_b16:  coverpoint {m_current[16],m_data[16]} iff (!m_is_read && m_be[0]);
      SOR_b17:  coverpoint {m_current[17],m_data[17]} iff (!m_is_read && m_be[0]);
      SOR_b18:  coverpoint {m_current[18],m_data[18]} iff (!m_is_read && m_be[0]);
      SOR_b19:  coverpoint {m_current[19],m_data[19]} iff (!m_is_read && m_be[0]);
      SOR_b20:  coverpoint {m_current[20],m_data[20]} iff (!m_is_read && m_be[0]);
      SOR_b21:  coverpoint {m_current[21],m_data[21]} iff (!m_is_read && m_be[0]);
      SOR_b22:  coverpoint {m_current[22],m_data[22]} iff (!m_is_read && m_be[0]);
      SOR_b23:  coverpoint {m_current[23],m_data[23]} iff (!m_is_read && m_be[0]);
      SOR_b24:  coverpoint {m_current[24],m_data[24]} iff (!m_is_read && m_be[0]);
      SOR_b25:  coverpoint {m_current[25],m_data[25]} iff (!m_is_read && m_be[0]);
      SOR_b26:  coverpoint {m_current[26],m_data[26]} iff (!m_is_read && m_be[0]);
      SOR_b27:  coverpoint {m_current[27],m_data[27]} iff (!m_is_read && m_be[0]);
      SOR_b28:  coverpoint {m_current[28],m_data[28]} iff (!m_is_read && m_be[0]);
      SOR_b29:  coverpoint {m_current[29],m_data[29]} iff (!m_is_read && m_be[0]);
      SOR_b30:  coverpoint {m_current[30],m_data[30]} iff (!m_is_read && m_be[0]);
      SOR_b31:  coverpoint {m_current[31],m_data[31]} iff (!m_is_read && m_be[0]);
   endgroup

   covergroup cg_vals;
      option.per_instance = 1;
      SOR:  coverpoint SOR.value[31:0];
   endgroup


   function new(string name="%(reg_class_name)s");
      super.new(.name(name), .n_bits(64), .has_coverage(UVM_CVR_ALL));
      if (has_coverage(UVM_CVR_REG_BITS)) begin
         cg_bits = new();
      end
      if (has_coverage(UVM_CVR_FIELD_VALS)) begin
         cg_vals = new();
      end
   endfunction

   function void build();
      SOR = uvm_reg_field::type_id::create(.name("SOR"), .parent(null), .contxt(get_full_name()));
      RSVD0 = uvm_reg_field::type_id::create(.name("RSVD0"), .parent(null), .contxt(get_full_name()));

      SOR.configure(.parent(this), .size(32), .lsb_pos(0),.access("RC"), .volatile(1), .reset(32'h0),.has_reset(1), .is_rand(1), .individually_accessible(0));
      SOR.set_reset(32'h0, "SOFT");
      SOR.set_compare(UVM_NO_CHECK);
      RSVD0.configure(.parent(this), .size(32), .lsb_pos(32),.access("RO"), .volatile(0), .reset(32'h0),.has_reset(1), .is_rand(1), .individually_accessible(0));
   endfunction

   virtual function void sample(uvm_reg_data_t data,
                                uvm_reg_data_t byte_en,
                                bit            is_read,
                                uvm_reg_map    map);
      if (get_coverage(UVM_CVR_REG_BITS)) begin
         m_current = get();
         m_data    = data;
         m_be      = byte_en;
         m_is_read = is_read;
         cg_bits.sample();
      end
      sample_values();
   endfunction

   virtual function void sample_values();
      super.sample_values();
      if (get_coverage(UVM_CVR_FIELD_VALS)) begin
         cg_vals.sample();
      end
   endfunction
endclass


//****************************************************************************************   
class reg_block_c extends csr_cn_pkg::cn_reg_block_c;
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

      set_coverage(coverage_enable >> 1);
   endfunction

endclass

endpackage : alu_csr_pkg

`endif
