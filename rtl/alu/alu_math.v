//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// ************************************************************************
// *
// * legal mumbo jumbo
// *
// *  Copyright 2013
// ************************************************************************

module alu_math
   (/*AUTOARG*/
   // Outputs
   result, ready,
   // Inputs
   clk, rst_n, ctl, dat, k_val, c_val
   );

   input clk;
   input rst_n;
   input ctl;
   input [7:0] dat;
   input [7:0] k_val;
   input [7:0] c_val;

   output [31:0] result;
   output        ready;

   /*AUTOWIRE*/

   // states
   parameter IDLE       = 4'h0;
   parameter OP_A_MSB   = 4'h1;
   parameter OP_A_LSB   = 4'h2;
   parameter OP_B_MSB   = 4'h3;
   parameter OP_B_LSB   = 4'h4;
   parameter COMPUTE_1  = 4'h5;
   parameter COMPUTE_2  = 4'h6;
   parameter COMPUTE_3  = 4'h7;
   parameter RESULT     = 4'h8;

   // operations
   parameter ADD_A_B = 0;
   parameter SUB_A_B = 1;
   parameter SUB_B_A = 2;
   parameter MUL_A_B = 3;
   parameter DIV_A_B = 4;
   parameter DIV_B_A = 5;
   parameter INC_A   = 6;
   parameter INC_B   = 7;
   parameter CLR_RES = 8;
   parameter ACCUM   = 9;

   reg [3:0]     state;
   reg [3:0]     nxt_state;

   reg           ctl_r;
   reg [7:0]     dat_r;
   reg [7:0]     k_val_r;
   reg [7:0]     c_val_r;

   reg [3:0]     operation;
   reg [15:0]    aval;
   reg [15:0]    bval;

   reg [31:0]    nxt_result;
   reg [31:0]    result;
   reg           ready;

   // register inputs
   always @(posedge clk) begin
      ctl_r <= ctl;
      dat_r <= dat;
      k_val_r <= k_val;
      c_val_r <= c_val;
   end

   // state machine
   always @(posedge clk) begin
      if(~rst_n)
         state <= IDLE;
      else
         state <= nxt_state;
   end

   always @(/*AS*/ctl_r or dat_r or operation or state) begin
      nxt_state = state;
      case(state)
         IDLE: begin
            if (ctl_r == 1) begin
               case(dat_r)
                  ADD_A_B, SUB_A_B, SUB_B_A, MUL_A_B, DIV_A_B, DIV_B_A, INC_A, ACCUM:
                     nxt_state = OP_A_MSB;
                  INC_B:
                     nxt_state = OP_B_MSB;
                  CLR_RES:
                     nxt_state = COMPUTE_1;
                  default:
                     `cn_err_hdl(("Illegal operation %0x detected. Ignoring it.", dat_r))
               endcase
            end
         end

         OP_A_MSB: begin
            nxt_state = OP_A_LSB;
         end

         OP_A_LSB: begin
            if(operation == INC_A || operation == ACCUM)
               nxt_state = COMPUTE_1;
            else
               nxt_state = OP_B_MSB;
         end

         OP_B_MSB: begin
            nxt_state = OP_B_LSB;
         end

         OP_B_LSB: begin
            nxt_state = COMPUTE_1;
         end

         COMPUTE_1: begin
            nxt_state = (operation == ADD_A_B || operation == SUB_A_B || operation == SUB_B_A ||
                         operation == INC_A || operation == INC_B || operation == CLR_RES ||
                         operation == ACCUM) ? RESULT : COMPUTE_2;
         end

         COMPUTE_2: begin
            if(operation == MUL_A_B) begin
               nxt_state = RESULT;
            end else
               nxt_state = COMPUTE_3;
         end

         COMPUTE_3: begin
            nxt_state = RESULT;
         end

         RESULT : begin
            nxt_state = IDLE;
         end

         default: begin
            if(rst_n)
               `cn_err_hdl(("Illegal state %0d", state))
            nxt_state = IDLE;
         end
      endcase
   end

   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
         result     <= 32'h0;
         nxt_result <= 32'b0;
         ready      <= 1'b0;
         operation  <= 4'b0;
      end else begin
         nxt_result <= (state == COMPUTE_1 && operation == ADD_A_B)?  (k_val_r * (aval+bval) + c_val_r) :
                       (state == COMPUTE_1 && operation == SUB_A_B)?  (k_val_r * (aval-bval) + c_val_r) :
                       (state == COMPUTE_1 && operation == SUB_B_A)?  (k_val_r * (bval-aval) + c_val_r) :
                       (state == COMPUTE_1 && operation == INC_A)?    (k_val_r * (aval+1)    + c_val_r) :
                       (state == COMPUTE_1 && operation == INC_B)?    (k_val_r * (bval+1)    + c_val_r) :
                       (state == COMPUTE_2 && operation == MUL_A_B)?  (k_val_r * (aval*bval) + c_val_r) :
                       (state == COMPUTE_3 && operation == DIV_A_B)?  (k_val_r * (aval/bval) + c_val_r) :
                       (state == COMPUTE_3 && operation == DIV_B_A)?  (k_val_r * (bval/aval) + c_val_r) :
                       (state == COMPUTE_1 && operation == CLR_RES)?  0                                 :
                       (state == COMPUTE_1 && operation == ACCUM)?    (aval + result)                   :
                       nxt_result;
         result     <= nxt_result;
         ready      <= (state == RESULT)? 1'b1 : 1'b0;
         operation  <= (state == IDLE && ctl_r == 1)? dat_r[3:0] : operation;
         aval[15:8] <= (state == OP_A_MSB)? dat_r : aval[15:8];
         aval[7:0]  <= (state == OP_A_LSB)? dat_r : aval[7:0];
         bval[15:8] <= (state == OP_B_MSB)? dat_r : bval[15:8];
         bval[7:0]  <= (state == OP_B_LSB)? dat_r : bval[7:0];
      end
   end
endmodule


// Local Variables:
// verilog-library-directories:("." )
// End:

