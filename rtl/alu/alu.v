//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// ************************************************************************
// *
// * legal mumbo jumbo
// *
// *  Copyright 2013
// ************************************************************************

module alu(/*AUTOARG*/
   // Outputs
   frame_data, frame_bp, frame, ctx_out, alu_ready, alu_result,
   // Inputs
   rst_n, frame_len_val, frame_len, ctx_val, ctx_in, clk, alu_dat, alu_ctl
   );

   /*AUTOINPUT*/
   // Beginning of automatic inputs (from unused autoinst inputs)
   input		alu_ctl;		// To math of alu_math.v
   input [7:0]		alu_dat;		// To math of alu_math.v
   input		clk;			// To csr of alu_csr.v, ...
   input [7:0]		ctx_in;			// To csr of alu_csr.v
   input		ctx_val;		// To csr of alu_csr.v
   input [4:0]		frame_len;		// To framer of alu_framer.v
   input		frame_len_val;		// To framer of alu_framer.v
   input		rst_n;			// To csr of alu_csr.v, ...
   // End of automatics

   /*AUTOOUTPUT*/
   // Beginning of automatic outputs (from unused autoinst outputs)
   output [7:0]		ctx_out;		// From csr of alu_csr.v
   output		frame;			// From framer of alu_framer.v
   output		frame_bp;		// From framer of alu_framer.v
   output [31:0]	frame_data;		// From framer of alu_framer.v
   // End of automatics

   output               alu_ready;
   output [31:0]        alu_result;

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [7:0]		c_val;			// From csr of alu_csr.v
   wire [7:0]		k_val;			// From csr of alu_csr.v
   // End of automatics

   /* alu_csr AUTO_TEMPLATE (
    );*/
   alu_csr csr
      (/*AUTOINST*/
       // Outputs
       .ctx_out				(ctx_out[7:0]),
       .k_val				(k_val[7:0]),
       .c_val				(c_val[7:0]),
       // Inputs
       .clk				(clk),
       .rst_n				(rst_n),
       .ctx_val				(ctx_val),
       .ctx_in				(ctx_in[7:0]),
       .alu_ready			(alu_ready),
       .alu_result			(alu_result[31:0]));

   /* alu_math AUTO_TEMPLATE (
       // Outputs
       .result                          (alu_result[31:0]),
       .ready                           (alu_ready),
       .overflow                        (alu_overflow),
       // Inputs
       .ctl                             (alu_ctl),
       .dat                             (alu_dat[7:0]),
       .kval                            (alu_kval[7:0]),
       .cval                            (alu_cval[7:0]));
    );*/
   alu_math math
      (/*AUTOINST*/
       // Outputs
       .result				(alu_result[31:0]),	 // Templated
       .ready				(alu_ready),		 // Templated
       // Inputs
       .clk				(clk),
       .rst_n				(rst_n),
       .ctl				(alu_ctl),		 // Templated
       .dat				(alu_dat[7:0]),		 // Templated
       .k_val				(k_val[7:0]),
       .c_val				(c_val[7:0]));

   /* alu_framer AUTO_TEMPLATE (
    .alu_data (alu_result[31:0]),
        );*/
   alu_framer framer
      (/*AUTOINST*/
       // Outputs
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

// Local Variables:
// verilog-library-directories:("." "../../rtl/include")
// End:
