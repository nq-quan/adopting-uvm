
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
                   ctx_intf ctx_i,
                   res_intf res_i);

   reg                  alu_ctl;
   reg [7:0]            alu_dat;
   reg [4:0]            frame_len;
   reg                  frame_len_val;

   wire                 alu_ready;
   wire [31:0]          alu_result;
   wire                 frame;
   wire                 frame_bp;
   wire [31:0]          frame_data;

   // obj: alu
   alu dut(// Outputs
           .ctx_out                     (ctx_i.out[7:0]),
           .frame                       (frame),
           .frame_bp                    (frame_bp),
           .frame_data                  (frame_data[31:0]),
           .alu_ready                   (res_i.ready),
           .alu_result                  (res_i.result[31:0]),
           // Inputs
           .alu_ctl                     (alu_ctl),
           .alu_dat                     (alu_dat[7:0]),
           .clk                         (tb_clk),
           .ctx_in                      (ctx_i.in[7:0]),
           .ctx_val                     (ctx_i.val),
           .frame_len                   (frame_len[4:0]),
           .frame_len_val               (frame_len_val),
           .rst_n                       (tb_rst_n));

   // proc: initial
   // Clear out the unimportant signals
   initial begin
      frame_len_val = 0;
      frame_len = 0;

      @(posedge tb_rst_n);
   end
endmodule
