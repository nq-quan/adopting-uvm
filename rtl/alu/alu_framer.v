//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

module alu_framer(/*AUTOARG*/
                  // Outputs
                  frame, frame_data, frame_bp,
                  // Inputs
                  clk, rst_n, frame_len, frame_len_val, alu_data, alu_ready
                  );

   input clk;
   input rst_n;

   input [4:0] frame_len;
   input       frame_len_val;

   input [31:0] alu_data;
   input        alu_ready;

   output       frame;
   output [31:0] frame_data;

   output        frame_bp;

   parameter IDLE = 0;
   parameter PENDING = 1;
   parameter FRAMING = 2;

   /*AUTOWIRE*/

   /*AUTOREG*/
   // Beginning of automatic regs (for this module's undeclared outputs)
   reg           frame;
   reg           frame_bp;
   reg [31:0]    frame_data;
   // End of automatics

   reg [31:0]    fifo[32];
   reg [4:0]     rptr;
   reg [4:0]     wptr;
   reg [4:0]     fifo_cnt;
   reg [1:0]     state, nxt_state;

   // reg inputs
   reg [4:0]     frame_len_r;
   reg           frame_len_val_r;
   reg [4:0]     frame_length;
   reg [31:0]    alu_data_r;
   reg           alu_ready_r;

   always @(posedge clk or negedge rst_n) begin
      if(~rst_n) begin
         frame_len_r <= 0;
         frame_len_val_r <= 0;
         alu_data_r <= 0;
         alu_ready_r <= 0;
      end else begin
         frame_len_val_r <= frame_len_val;
         frame_len_r <= frame_len;
         frame_length <= (frame_len_val_r && state == IDLE)? frame_len_r :
                         (frame_length && state == FRAMING)? frame_length - 1 :
                         frame_length;
         alu_data_r <= alu_data;
         alu_ready_r <= alu_ready;
      end
   end

   always @(posedge clk or negedge rst_n) begin
      state <= (~rst_n)? IDLE : nxt_state;
   end

   always @(/*AS*/fifo_cnt or frame_len_r or frame_len_val_r or frame_length
	           or state) begin
      nxt_state = state;
      case(state)
         IDLE: begin
            nxt_state = (frame_len_val_r)?
                        ((fifo_cnt >= frame_len_r)? FRAMING : PENDING) :
                        IDLE;
         end

         PENDING: begin
            nxt_state = (fifo_cnt >= frame_length)? FRAMING : PENDING;
         end

         FRAMING: begin
            nxt_state = (frame_length)? FRAMING : IDLE;
         end
      endcase
   end

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         rptr <= 0;
         wptr <= 0;
         frame_bp <= 0;
         fifo_cnt <= 0;
         frame <= 'b0;
      end else begin
         fifo[wptr] <= (alu_ready_r)? alu_data_r : fifo[wptr];
         wptr <= (alu_ready_r)? wptr+1 : wptr;
         rptr <= (state == FRAMING && frame_length)? rptr+1 : rptr;
         fifo_cnt <= (wptr - rptr);
         frame_bp <= fifo_cnt >= 5'd29;
         frame <= (state == FRAMING && frame_length)? 1'b1 : 1'b0;
         frame_data <= fifo[rptr];
      end
   end

`ifdef FRAMER_ASSERTIONS
   assert property(@(posedge clk)
                   !(fifo_cnt == 'd31 && alu_ready_r)
                   ) else
      `cn_fatal_hdl(("FIFO Overflow."))

   assert property(@(posedge clk)
                   !(fifo_cnt == 'd0 && state == FRAMING && frame_length)
                   ) else
      `cn_fatal_hdl(("FIFO Underflow."))
`endif

endmodule
