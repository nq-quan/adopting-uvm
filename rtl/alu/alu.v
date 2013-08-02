// ************************************************************************
// *
// * legal mumbo jumbo
// *
// *  Copyright 2013
// ************************************************************************

module alu(
   // Outputs
   frame_data, frame_bp, frame, ctx_out, alu_ready, alu_result,
   // Inputs
   rst_n, frame_len_val, frame_len, ctx_val, ctx_in, clk, alu_dat, alu_ctl
   );

   input		alu_ctl;
   input [7:0]		alu_dat;
   input		clk;
   input [7:0]		ctx_in;
   input		ctx_val;
   input [4:0]		frame_len;
   input		frame_len_val;
   input		rst_n;


   output [7:0]		ctx_out;
   output		frame;
   output		frame_bp;
   output [31:0]	frame_data;

   output               alu_ready;
   output [31:0]        alu_result;

   wire [7:0]		c_val;
   wire [7:0]		k_val;

   alu_csr csr
      (// Outputs
       .ctx_out				(ctx_out[7:0]),
       .k_val				(k_val[7:0]),
       .c_val				(c_val[7:0]),
       // Inputs
       .clk				(clk),
       .ctx_val				(ctx_val),
       .rst_n           (rst_n),
       .ctx_in				(ctx_in[7:0]),
       .alu_ready			(alu_ready),
       .alu_result			(alu_result[31:0]));

   alu_math math
      (// Outputs
       .result				(alu_result[31:0]),	 // Templated
       .ready				(alu_ready),		 // Templated
       // Inputs
       .clk				(clk),
       .rst_n				(rst_n),
       .ctl				(alu_ctl),		 // Templated
       .dat				(alu_dat[7:0]),		 // Templated
       .k_val				(k_val[7:0]),
       .c_val				(c_val[7:0]));

   alu_framer framer
      (// Outputs
       .frame				(frame),
       .frame_data			(frame_data[31:0]),
       .frame_bp			(frame_bp),
       // Inputs
       .clk				(clk),
       .rst_n				(rst_n),
       .frame_len			(frame_len[4:0]),
       .frame_len_val			(frame_len_val),
       .alu_data			(alu_result[31:0]),	 // Templated
       .alu_ready			(alu_ready));

endmodule
