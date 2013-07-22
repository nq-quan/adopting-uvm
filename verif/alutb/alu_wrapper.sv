//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * Copyright 2013,
// * (utg v0.8.2)
// ***********************************************************************
// File:   alutb_tb_top.sv
// Author: bhunter
/* About:  Wraps the ALU block to make the testbench look cleaner
 *************************************************************************/

module alu_wrapper(input logic tb_clk,
                   tb_rst_n,
                   ctx_intf ctx_i);

   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg                  alu_ctl;                // To dut of alu.v
   reg [7:0]            alu_dat;                // To dut of alu.v
   reg [4:0]            frame_len;              // To dut of alu.v
   reg                  frame_len_val;          // To dut of alu.v
   // End of automatics
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 alu_ready;              // From dut of alu.v
   wire [31:0]          alu_result;             // From dut of alu.v
   wire                 frame;                  // From dut of alu.v
   wire                 frame_bp;               // From dut of alu.v
   wire [31:0]          frame_data;             // From dut of alu.v
   // End of automatics

   // obj: alu
   /*
    alu AUTO_TEMPLATE (

    .ctx_\(.*\)   (ctx_i.\1[]),
    .clk          (tb_clk),
    .rst_n        (tb_rst_n),
    .\(.*\) (\1[]),
    ); */
   alu dut(/*AUTOINST*/
           // Outputs
           .ctx_out                     (ctx_i.out[7:0]),        // Templated
           .frame                       (frame),                 // Templated
           .frame_bp                    (frame_bp),              // Templated
           .frame_data                  (frame_data[31:0]),      // Templated
           .alu_ready                   (alu_ready),             // Templated
           .alu_result                  (alu_result[31:0]),      // Templated
           // Inputs
           .alu_ctl                     (alu_ctl),               // Templated
           .alu_dat                     (alu_dat[7:0]),          // Templated
           .clk                         (tb_clk),                // Templated
           .ctx_in                      (ctx_i.in[7:0]),         // Templated
           .ctx_val                     (ctx_i.val),             // Templated
           .frame_len                   (frame_len[4:0]),        // Templated
           .frame_len_val               (frame_len_val),         // Templated
           .rst_n                       (tb_rst_n));              // Templated


   // proc: initial
   // Clear out the unimportant signals
   initial begin
      frame_len_val = 0;
      frame_len = 0;

      @(posedge tb_rst_n);
   end

endmodule

// Local Variables:
// verilog-library-directories:  ("." "../../verif/hdl" "../../rtl/alu")
// verilog-library-extensions:  (".v" ".sv" ".svh")
// End:

