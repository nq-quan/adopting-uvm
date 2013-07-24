// ************************************************************************
// *
// * legal mumbo jumbo
// *
// *  Copyright 2013
// ************************************************************************

module alu_csr(/*AUTOARG*/
               // Outputs
               ctx_out, k_val, c_val,
               // Inputs
               clk, rst_n, ctx_val, ctx_in, alu_ready, alu_result
               );

   input clk;
   input rst_n;

   input ctx_val;
   input [7:0] ctx_in;

   input       alu_ready;
   input [31:0] alu_result;

   // outputs
   output reg [7:0] ctx_out;
   output [7:0]     k_val;
   output [7:0]     c_val;

   /*AUTOWIRE*/

   // reg inputs
   reg          ctx_val_r;
   reg [7:0]    ctx_in_r;

   // reg output
   reg [7:0]    ctx_out_r;

   // states
   parameter IDLE     = 4'b0000;
   parameter WR_DATA0 = 4'b0010;
   parameter WR_DATA1 = 4'b0011;
   parameter WR_DATA2 = 4'b0100;
   parameter WR_DATA3 = 4'b0101;
   parameter RD_DELAY = 4'b0110;
   parameter RD_DATA0 = 4'b0111;
   parameter RD_DATA1 = 4'b1000;
   parameter RD_DATA2 = 4'b1001;
   parameter RD_DATA3 = 4'b1010;

   reg [3:0]    state;
   reg [3:0]    nxt_state;

   reg [6:0]    addr;
   reg [31:0]   wr_data;

   // CSRs
   reg [7:0]    k_val_r;
   reg [7:0]    c_val_r;
   reg [31:0]   sor;

   // register inputs
   always @(posedge clk) begin
      if(~rst_n) begin
         ctx_val_r <= 0;
         ctx_in_r <= 0;
      end else begin
         ctx_val_r <= ctx_val;
         ctx_in_r <= ctx_in;
      end
   end

   // drive outputs
   assign k_val = k_val_r;
   assign c_val = c_val_r;

   // state machine
   always @(posedge clk) begin
      if(~rst_n)
         state <= IDLE;
      else
         state <= nxt_state;
   end

   // next state
   always @(/*AS*/ctx_in_r or ctx_val_r or rst_n or state) begin
      if(~rst_n) begin
         nxt_state = IDLE;
      end else begin
         case(state)
            IDLE: nxt_state = (ctx_val_r)?
                              ((ctx_in_r[7] == 1)? WR_DATA0 : RD_DELAY) :
                              IDLE;
            WR_DATA0: nxt_state = WR_DATA1;
            WR_DATA1: nxt_state = WR_DATA2;
            WR_DATA2: nxt_state = WR_DATA3;
            WR_DATA3: nxt_state = IDLE;
            RD_DELAY: nxt_state = RD_DATA0;
            RD_DATA0: nxt_state = RD_DATA1;
            RD_DATA1: nxt_state = RD_DATA2;
            RD_DATA2: nxt_state = RD_DATA3;
            RD_DATA3: nxt_state = IDLE;
         endcase
      end
   end

   // register address on idle cycles
   always @(posedge clk or negedge rst_n) begin
      if(~rst_n)
         addr <= 7'h0;
      else
         addr <= (state <= IDLE && ctx_val_r)? ctx_in_r[6:0] : addr;
   end

   assign addr20 = addr == 'h20;
   assign addr24 = addr == 'h24;
   assign sor_rd_clr = ((state == RD_DATA3) & addr24);

   // Read Transactions
   always @(posedge clk or negedge rst_n) begin
      if(~rst_n)
         ctx_out_r <= 0;
      else
         ctx_out_r <= (state == RD_DELAY)?  ((addr20)? 8'h0       :
                                             (addr24)? sor[31:24] :
                                             8'hDE)               :

                      (state == RD_DATA0)?  ((addr20)? 8'h0       :
                                             (addr24)? sor[23:16] :
                                             8'hAD)               :

                      (state == RD_DATA1)?  ((addr20)? k_val      :
                                             (addr24)? sor[15:8]  :
                                             8'hBE)               :

                      (state == RD_DATA2)?  ((addr20)? c_val      :
                                             (addr24)? sor[7:0]   :
                                             8'hEF)               :
                      // default
                      8'h00;
   end


   // Write Transactions
   always @(posedge clk or negedge rst_n) begin
      if(~rst_n) begin
         k_val_r <= 8'h0;
         c_val_r <= 8'h0;
      end else begin
         k_val_r <= (state == WR_DATA2 && addr20)? ctx_in_r : k_val_r;
         c_val_r <= (state == WR_DATA3 && addr20)? ctx_in_r : c_val_r;
      end
   end


   // sum-of-results register
   always @(posedge clk or negedge rst_n) begin
      if(~rst_n)
         sor <= 32'h0;
      else begin
         case({alu_ready, sor_rd_clr})
            2'b01 : sor <= 32'h0;
            2'b10 : sor <= sor + alu_result;
            2'b11 : sor <= alu_result;
         endcase
      end
   end

   // ctx_out
   always @(posedge clk or negedge rst_n) begin
      if(~rst_n)
         ctx_out <= 'b0;
      else
         ctx_out <= ctx_out_r;
   end
endmodule

// Local Variables:
// verilog-library-directories:("." )
// End:

