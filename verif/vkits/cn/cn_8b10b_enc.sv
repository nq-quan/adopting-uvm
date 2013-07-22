//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011, Caviu
// * (utg v0.3.3)
// ***********************************************************************
// File:   cn_8b10b_enc.sv
// Author: benchen
/* About:  8b10b encoder/decoder

Usage: 
   Declare cn_pkg::enc/dec_8b10b_c encoder/decoder; for each 10b lane
   Create encoder/decoder = cn_pkg::enc/dec_8b10b_c::type_id::create("encoder/decoder", this);
   For encode: data_10b = encoder.encode(data_8b, data_or_ctrl);
   For decode: {data_or_ctrl, data_8b} = decoder.decode(data_10b);
   Running disparity is calculated and kept automatically
   Disp_err and dec_err are kept in the decoder class
    
 *************************************************************************/

`ifndef __CN_8B10B_ENC_SV__
   `define __CN_8B10B_ENC_SV__

class enc_8b10b_c extends uvm_component;
   //----------------------------------------------------------------------------------------
   // Group: Types

   `uvm_component_utils_begin(cn_pkg::enc_8b10b_c)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   //----------------------------------------------------------------------------------------
   // Group: Fields

   // var: running disparity
   bit rd = 0;

   //----------------------------------------------------------------------------------------
   // Group: Methods

   ////////////////////////////////////////////
   function new(string name="enc_8b10b",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   // func: build_phase
   // Hook up to the virtual interface
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction : build_phase
   
   ////////////////////////////////////////////
   // function: encode
   // encode from 8b to 10b
   function bit [9:0] encode(input bit [7:0] data, input bit ctrl);
      case ({rd, ctrl, data})
      {1'b0, 1'b0, 8'h00}: begin encode = 10'b1001110100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h00}: begin encode = 10'b0110001011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h01}: begin encode = 10'b0111010100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h01}: begin encode = 10'b1000101011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h02}: begin encode = 10'b1011010100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h02}: begin encode = 10'b0100101011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h03}: begin encode = 10'b1100011011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h03}: begin encode = 10'b1100010100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h04}: begin encode = 10'b1101010100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h04}: begin encode = 10'b0010101011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h05}: begin encode = 10'b1010011011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h05}: begin encode = 10'b1010010100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h06}: begin encode = 10'b0110011011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h06}: begin encode = 10'b0110010100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h07}: begin encode = 10'b1110001011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h07}: begin encode = 10'b0001110100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h08}: begin encode = 10'b1110010100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h08}: begin encode = 10'b0001101011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h09}: begin encode = 10'b1001011011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h09}: begin encode = 10'b1001010100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h0a}: begin encode = 10'b0101011011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h0a}: begin encode = 10'b0101010100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h0b}: begin encode = 10'b1101001011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h0b}: begin encode = 10'b1101000100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h0c}: begin encode = 10'b0011011011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h0c}: begin encode = 10'b0011010100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h0d}: begin encode = 10'b1011001011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h0d}: begin encode = 10'b1011000100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h0e}: begin encode = 10'b0111001011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h0e}: begin encode = 10'b0111000100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h0f}: begin encode = 10'b0101110100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h0f}: begin encode = 10'b1010001011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h10}: begin encode = 10'b0110110100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h10}: begin encode = 10'b1001001011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h11}: begin encode = 10'b1000111011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h11}: begin encode = 10'b1000110100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h12}: begin encode = 10'b0100111011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h12}: begin encode = 10'b0100110100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h13}: begin encode = 10'b1100101011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h13}: begin encode = 10'b1100100100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h14}: begin encode = 10'b0010111011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h14}: begin encode = 10'b0010110100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h15}: begin encode = 10'b1010101011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h15}: begin encode = 10'b1010100100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h16}: begin encode = 10'b0110101011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h16}: begin encode = 10'b0110100100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h17}: begin encode = 10'b1110100100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h17}: begin encode = 10'b0001011011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h18}: begin encode = 10'b1100110100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h18}: begin encode = 10'b0011001011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h19}: begin encode = 10'b1001101011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h19}: begin encode = 10'b1001100100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h1a}: begin encode = 10'b0101101011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h1a}: begin encode = 10'b0101100100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h1b}: begin encode = 10'b1101100100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h1b}: begin encode = 10'b0010011011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h1c}: begin encode = 10'b0011101011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h1c}: begin encode = 10'b0011100100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h1d}: begin encode = 10'b1011100100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h1d}: begin encode = 10'b0100011011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h1e}: begin encode = 10'b0111100100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h1e}: begin encode = 10'b1000011011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h1f}: begin encode = 10'b1010110100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h1f}: begin encode = 10'b0101001011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h20}: begin encode = 10'b1001111001; rd = 1'b1; end
      {1'b1, 1'b0, 8'h20}: begin encode = 10'b0110001001; rd = 1'b0; end
      {1'b0, 1'b0, 8'h21}: begin encode = 10'b0111011001; rd = 1'b1; end
      {1'b1, 1'b0, 8'h21}: begin encode = 10'b1000101001; rd = 1'b0; end
      {1'b0, 1'b0, 8'h22}: begin encode = 10'b1011011001; rd = 1'b1; end
      {1'b1, 1'b0, 8'h22}: begin encode = 10'b0100101001; rd = 1'b0; end
      {1'b0, 1'b0, 8'h23}: begin encode = 10'b1100011001; rd = 1'b0; end
      {1'b1, 1'b0, 8'h23}: begin encode = 10'b1100011001; rd = 1'b1; end
      {1'b0, 1'b0, 8'h24}: begin encode = 10'b1101011001; rd = 1'b1; end
      {1'b1, 1'b0, 8'h24}: begin encode = 10'b0010101001; rd = 1'b0; end
      {1'b0, 1'b0, 8'h25}: begin encode = 10'b1010011001; rd = 1'b0; end
      {1'b1, 1'b0, 8'h25}: begin encode = 10'b1010011001; rd = 1'b1; end
      {1'b0, 1'b0, 8'h26}: begin encode = 10'b0110011001; rd = 1'b0; end
      {1'b1, 1'b0, 8'h26}: begin encode = 10'b0110011001; rd = 1'b1; end
      {1'b0, 1'b0, 8'h27}: begin encode = 10'b1110001001; rd = 1'b0; end
      {1'b1, 1'b0, 8'h27}: begin encode = 10'b0001111001; rd = 1'b1; end
      {1'b0, 1'b0, 8'h28}: begin encode = 10'b1110011001; rd = 1'b1; end
      {1'b1, 1'b0, 8'h28}: begin encode = 10'b0001101001; rd = 1'b0; end
      {1'b0, 1'b0, 8'h29}: begin encode = 10'b1001011001; rd = 1'b0; end
      {1'b1, 1'b0, 8'h29}: begin encode = 10'b1001011001; rd = 1'b1; end
      {1'b0, 1'b0, 8'h2a}: begin encode = 10'b0101011001; rd = 1'b0; end
      {1'b1, 1'b0, 8'h2a}: begin encode = 10'b0101011001; rd = 1'b1; end
      {1'b0, 1'b0, 8'h2b}: begin encode = 10'b1101001001; rd = 1'b0; end
      {1'b1, 1'b0, 8'h2b}: begin encode = 10'b1101001001; rd = 1'b1; end
      {1'b0, 1'b0, 8'h2c}: begin encode = 10'b0011011001; rd = 1'b0; end
      {1'b1, 1'b0, 8'h2c}: begin encode = 10'b0011011001; rd = 1'b1; end
      {1'b0, 1'b0, 8'h2d}: begin encode = 10'b1011001001; rd = 1'b0; end
      {1'b1, 1'b0, 8'h2d}: begin encode = 10'b1011001001; rd = 1'b1; end
      {1'b0, 1'b0, 8'h2e}: begin encode = 10'b0111001001; rd = 1'b0; end
      {1'b1, 1'b0, 8'h2e}: begin encode = 10'b0111001001; rd = 1'b1; end
      {1'b0, 1'b0, 8'h2f}: begin encode = 10'b0101111001; rd = 1'b1; end
      {1'b1, 1'b0, 8'h2f}: begin encode = 10'b1010001001; rd = 1'b0; end
      {1'b0, 1'b0, 8'h30}: begin encode = 10'b0110111001; rd = 1'b1; end
      {1'b1, 1'b0, 8'h30}: begin encode = 10'b1001001001; rd = 1'b0; end
      {1'b0, 1'b0, 8'h31}: begin encode = 10'b1000111001; rd = 1'b0; end
      {1'b1, 1'b0, 8'h31}: begin encode = 10'b1000111001; rd = 1'b1; end
      {1'b0, 1'b0, 8'h32}: begin encode = 10'b0100111001; rd = 1'b0; end
      {1'b1, 1'b0, 8'h32}: begin encode = 10'b0100111001; rd = 1'b1; end
      {1'b0, 1'b0, 8'h33}: begin encode = 10'b1100101001; rd = 1'b0; end
      {1'b1, 1'b0, 8'h33}: begin encode = 10'b1100101001; rd = 1'b1; end
      {1'b0, 1'b0, 8'h34}: begin encode = 10'b0010111001; rd = 1'b0; end
      {1'b1, 1'b0, 8'h34}: begin encode = 10'b0010111001; rd = 1'b1; end
      {1'b0, 1'b0, 8'h35}: begin encode = 10'b1010101001; rd = 1'b0; end
      {1'b1, 1'b0, 8'h35}: begin encode = 10'b1010101001; rd = 1'b1; end
      {1'b0, 1'b0, 8'h36}: begin encode = 10'b0110101001; rd = 1'b0; end
      {1'b1, 1'b0, 8'h36}: begin encode = 10'b0110101001; rd = 1'b1; end
      {1'b0, 1'b0, 8'h37}: begin encode = 10'b1110101001; rd = 1'b1; end
      {1'b1, 1'b0, 8'h37}: begin encode = 10'b0001011001; rd = 1'b0; end
      {1'b0, 1'b0, 8'h38}: begin encode = 10'b1100111001; rd = 1'b1; end
      {1'b1, 1'b0, 8'h38}: begin encode = 10'b0011001001; rd = 1'b0; end
      {1'b0, 1'b0, 8'h39}: begin encode = 10'b1001101001; rd = 1'b0; end
      {1'b1, 1'b0, 8'h39}: begin encode = 10'b1001101001; rd = 1'b1; end
      {1'b0, 1'b0, 8'h3a}: begin encode = 10'b0101101001; rd = 1'b0; end
      {1'b1, 1'b0, 8'h3a}: begin encode = 10'b0101101001; rd = 1'b1; end
      {1'b0, 1'b0, 8'h3b}: begin encode = 10'b1101101001; rd = 1'b1; end
      {1'b1, 1'b0, 8'h3b}: begin encode = 10'b0010011001; rd = 1'b0; end
      {1'b0, 1'b0, 8'h3c}: begin encode = 10'b0011101001; rd = 1'b0; end
      {1'b1, 1'b0, 8'h3c}: begin encode = 10'b0011101001; rd = 1'b1; end
      {1'b0, 1'b0, 8'h3d}: begin encode = 10'b1011101001; rd = 1'b1; end
      {1'b1, 1'b0, 8'h3d}: begin encode = 10'b0100011001; rd = 1'b0; end
      {1'b0, 1'b0, 8'h3e}: begin encode = 10'b0111101001; rd = 1'b1; end
      {1'b1, 1'b0, 8'h3e}: begin encode = 10'b1000011001; rd = 1'b0; end
      {1'b0, 1'b0, 8'h3f}: begin encode = 10'b1010111001; rd = 1'b1; end
      {1'b1, 1'b0, 8'h3f}: begin encode = 10'b0101001001; rd = 1'b0; end
      {1'b0, 1'b0, 8'h40}: begin encode = 10'b1001110101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h40}: begin encode = 10'b0110000101; rd = 1'b0; end
      {1'b0, 1'b0, 8'h41}: begin encode = 10'b0111010101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h41}: begin encode = 10'b1000100101; rd = 1'b0; end
      {1'b0, 1'b0, 8'h42}: begin encode = 10'b1011010101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h42}: begin encode = 10'b0100100101; rd = 1'b0; end
      {1'b0, 1'b0, 8'h43}: begin encode = 10'b1100010101; rd = 1'b0; end
      {1'b1, 1'b0, 8'h43}: begin encode = 10'b1100010101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h44}: begin encode = 10'b1101010101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h44}: begin encode = 10'b0010100101; rd = 1'b0; end
      {1'b0, 1'b0, 8'h45}: begin encode = 10'b1010010101; rd = 1'b0; end
      {1'b1, 1'b0, 8'h45}: begin encode = 10'b1010010101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h46}: begin encode = 10'b0110010101; rd = 1'b0; end
      {1'b1, 1'b0, 8'h46}: begin encode = 10'b0110010101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h47}: begin encode = 10'b1110000101; rd = 1'b0; end
      {1'b1, 1'b0, 8'h47}: begin encode = 10'b0001110101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h48}: begin encode = 10'b1110010101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h48}: begin encode = 10'b0001100101; rd = 1'b0; end
      {1'b0, 1'b0, 8'h49}: begin encode = 10'b1001010101; rd = 1'b0; end
      {1'b1, 1'b0, 8'h49}: begin encode = 10'b1001010101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h4a}: begin encode = 10'b0101010101; rd = 1'b0; end
      {1'b1, 1'b0, 8'h4a}: begin encode = 10'b0101010101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h4b}: begin encode = 10'b1101000101; rd = 1'b0; end
      {1'b1, 1'b0, 8'h4b}: begin encode = 10'b1101000101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h4c}: begin encode = 10'b0011010101; rd = 1'b0; end
      {1'b1, 1'b0, 8'h4c}: begin encode = 10'b0011010101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h4d}: begin encode = 10'b1011000101; rd = 1'b0; end
      {1'b1, 1'b0, 8'h4d}: begin encode = 10'b1011000101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h4e}: begin encode = 10'b0111000101; rd = 1'b0; end
      {1'b1, 1'b0, 8'h4e}: begin encode = 10'b0111000101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h4f}: begin encode = 10'b0101110101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h4f}: begin encode = 10'b1010000101; rd = 1'b0; end
      {1'b0, 1'b0, 8'h50}: begin encode = 10'b0110110101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h50}: begin encode = 10'b1001000101; rd = 1'b0; end
      {1'b0, 1'b0, 8'h51}: begin encode = 10'b1000110101; rd = 1'b0; end
      {1'b1, 1'b0, 8'h51}: begin encode = 10'b1000110101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h52}: begin encode = 10'b0100110101; rd = 1'b0; end
      {1'b1, 1'b0, 8'h52}: begin encode = 10'b0100110101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h53}: begin encode = 10'b1100100101; rd = 1'b0; end
      {1'b1, 1'b0, 8'h53}: begin encode = 10'b1100100101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h54}: begin encode = 10'b0010110101; rd = 1'b0; end
      {1'b1, 1'b0, 8'h54}: begin encode = 10'b0010110101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h55}: begin encode = 10'b1010100101; rd = 1'b0; end
      {1'b1, 1'b0, 8'h55}: begin encode = 10'b1010100101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h56}: begin encode = 10'b0110100101; rd = 1'b0; end
      {1'b1, 1'b0, 8'h56}: begin encode = 10'b0110100101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h57}: begin encode = 10'b1110100101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h57}: begin encode = 10'b0001010101; rd = 1'b0; end
      {1'b0, 1'b0, 8'h58}: begin encode = 10'b1100110101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h58}: begin encode = 10'b0011000101; rd = 1'b0; end
      {1'b0, 1'b0, 8'h59}: begin encode = 10'b1001100101; rd = 1'b0; end
      {1'b1, 1'b0, 8'h59}: begin encode = 10'b1001100101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h5a}: begin encode = 10'b0101100101; rd = 1'b0; end
      {1'b1, 1'b0, 8'h5a}: begin encode = 10'b0101100101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h5b}: begin encode = 10'b1101100101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h5b}: begin encode = 10'b0010010101; rd = 1'b0; end
      {1'b0, 1'b0, 8'h5c}: begin encode = 10'b0011100101; rd = 1'b0; end
      {1'b1, 1'b0, 8'h5c}: begin encode = 10'b0011100101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h5d}: begin encode = 10'b1011100101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h5d}: begin encode = 10'b0100010101; rd = 1'b0; end
      {1'b0, 1'b0, 8'h5e}: begin encode = 10'b0111100101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h5e}: begin encode = 10'b1000010101; rd = 1'b0; end
      {1'b0, 1'b0, 8'h5f}: begin encode = 10'b1010110101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h5f}: begin encode = 10'b0101000101; rd = 1'b0; end
      {1'b0, 1'b0, 8'h60}: begin encode = 10'b1001110011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h60}: begin encode = 10'b0110001100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h61}: begin encode = 10'b0111010011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h61}: begin encode = 10'b1000101100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h62}: begin encode = 10'b1011010011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h62}: begin encode = 10'b0100101100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h63}: begin encode = 10'b1100011100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h63}: begin encode = 10'b1100010011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h64}: begin encode = 10'b1101010011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h64}: begin encode = 10'b0010101100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h65}: begin encode = 10'b1010011100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h65}: begin encode = 10'b1010010011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h66}: begin encode = 10'b0110011100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h66}: begin encode = 10'b0110010011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h67}: begin encode = 10'b1110001100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h67}: begin encode = 10'b0001110011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h68}: begin encode = 10'b1110010011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h68}: begin encode = 10'b0001101100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h69}: begin encode = 10'b1001011100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h69}: begin encode = 10'b1001010011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h6a}: begin encode = 10'b0101011100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h6a}: begin encode = 10'b0101010011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h6b}: begin encode = 10'b1101001100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h6b}: begin encode = 10'b1101000011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h6c}: begin encode = 10'b0011011100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h6c}: begin encode = 10'b0011010011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h6d}: begin encode = 10'b1011001100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h6d}: begin encode = 10'b1011000011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h6e}: begin encode = 10'b0111001100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h6e}: begin encode = 10'b0111000011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h6f}: begin encode = 10'b0101110011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h6f}: begin encode = 10'b1010001100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h70}: begin encode = 10'b0110110011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h70}: begin encode = 10'b1001001100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h71}: begin encode = 10'b1000111100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h71}: begin encode = 10'b1000110011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h72}: begin encode = 10'b0100111100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h72}: begin encode = 10'b0100110011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h73}: begin encode = 10'b1100101100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h73}: begin encode = 10'b1100100011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h74}: begin encode = 10'b0010111100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h74}: begin encode = 10'b0010110011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h75}: begin encode = 10'b1010101100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h75}: begin encode = 10'b1010100011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h76}: begin encode = 10'b0110101100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h76}: begin encode = 10'b0110100011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h77}: begin encode = 10'b1110100011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h77}: begin encode = 10'b0001011100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h78}: begin encode = 10'b1100110011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h78}: begin encode = 10'b0011001100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h79}: begin encode = 10'b1001101100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h79}: begin encode = 10'b1001100011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h7a}: begin encode = 10'b0101101100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h7a}: begin encode = 10'b0101100011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h7b}: begin encode = 10'b1101100011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h7b}: begin encode = 10'b0010011100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h7c}: begin encode = 10'b0011101100; rd = 1'b0; end
      {1'b1, 1'b0, 8'h7c}: begin encode = 10'b0011100011; rd = 1'b1; end
      {1'b0, 1'b0, 8'h7d}: begin encode = 10'b1011100011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h7d}: begin encode = 10'b0100011100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h7e}: begin encode = 10'b0111100011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h7e}: begin encode = 10'b1000011100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h7f}: begin encode = 10'b1010110011; rd = 1'b1; end
      {1'b1, 1'b0, 8'h7f}: begin encode = 10'b0101001100; rd = 1'b0; end
      {1'b0, 1'b0, 8'h80}: begin encode = 10'b1001110010; rd = 1'b0; end
      {1'b1, 1'b0, 8'h80}: begin encode = 10'b0110001101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h81}: begin encode = 10'b0111010010; rd = 1'b0; end
      {1'b1, 1'b0, 8'h81}: begin encode = 10'b1000101101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h82}: begin encode = 10'b1011010010; rd = 1'b0; end
      {1'b1, 1'b0, 8'h82}: begin encode = 10'b0100101101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h83}: begin encode = 10'b1100011101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h83}: begin encode = 10'b1100010010; rd = 1'b0; end
      {1'b0, 1'b0, 8'h84}: begin encode = 10'b1101010010; rd = 1'b0; end
      {1'b1, 1'b0, 8'h84}: begin encode = 10'b0010101101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h85}: begin encode = 10'b1010011101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h85}: begin encode = 10'b1010010010; rd = 1'b0; end
      {1'b0, 1'b0, 8'h86}: begin encode = 10'b0110011101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h86}: begin encode = 10'b0110010010; rd = 1'b0; end
      {1'b0, 1'b0, 8'h87}: begin encode = 10'b1110001101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h87}: begin encode = 10'b0001110010; rd = 1'b0; end
      {1'b0, 1'b0, 8'h88}: begin encode = 10'b1110010010; rd = 1'b0; end
      {1'b1, 1'b0, 8'h88}: begin encode = 10'b0001101101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h89}: begin encode = 10'b1001011101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h89}: begin encode = 10'b1001010010; rd = 1'b0; end
      {1'b0, 1'b0, 8'h8a}: begin encode = 10'b0101011101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h8a}: begin encode = 10'b0101010010; rd = 1'b0; end
      {1'b0, 1'b0, 8'h8b}: begin encode = 10'b1101001101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h8b}: begin encode = 10'b1101000010; rd = 1'b0; end
      {1'b0, 1'b0, 8'h8c}: begin encode = 10'b0011011101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h8c}: begin encode = 10'b0011010010; rd = 1'b0; end
      {1'b0, 1'b0, 8'h8d}: begin encode = 10'b1011001101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h8d}: begin encode = 10'b1011000010; rd = 1'b0; end
      {1'b0, 1'b0, 8'h8e}: begin encode = 10'b0111001101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h8e}: begin encode = 10'b0111000010; rd = 1'b0; end
      {1'b0, 1'b0, 8'h8f}: begin encode = 10'b0101110010; rd = 1'b0; end
      {1'b1, 1'b0, 8'h8f}: begin encode = 10'b1010001101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h90}: begin encode = 10'b0110110010; rd = 1'b0; end
      {1'b1, 1'b0, 8'h90}: begin encode = 10'b1001001101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h91}: begin encode = 10'b1000111101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h91}: begin encode = 10'b1000110010; rd = 1'b0; end
      {1'b0, 1'b0, 8'h92}: begin encode = 10'b0100111101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h92}: begin encode = 10'b0100110010; rd = 1'b0; end
      {1'b0, 1'b0, 8'h93}: begin encode = 10'b1100101101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h93}: begin encode = 10'b1100100010; rd = 1'b0; end
      {1'b0, 1'b0, 8'h94}: begin encode = 10'b0010111101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h94}: begin encode = 10'b0010110010; rd = 1'b0; end
      {1'b0, 1'b0, 8'h95}: begin encode = 10'b1010101101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h95}: begin encode = 10'b1010100010; rd = 1'b0; end
      {1'b0, 1'b0, 8'h96}: begin encode = 10'b0110101101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h96}: begin encode = 10'b0110100010; rd = 1'b0; end
      {1'b0, 1'b0, 8'h97}: begin encode = 10'b1110100010; rd = 1'b0; end
      {1'b1, 1'b0, 8'h97}: begin encode = 10'b0001011101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h98}: begin encode = 10'b1100110010; rd = 1'b0; end
      {1'b1, 1'b0, 8'h98}: begin encode = 10'b0011001101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h99}: begin encode = 10'b1001101101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h99}: begin encode = 10'b1001100010; rd = 1'b0; end
      {1'b0, 1'b0, 8'h9a}: begin encode = 10'b0101101101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h9a}: begin encode = 10'b0101100010; rd = 1'b0; end
      {1'b0, 1'b0, 8'h9b}: begin encode = 10'b1101100010; rd = 1'b0; end
      {1'b1, 1'b0, 8'h9b}: begin encode = 10'b0010011101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h9c}: begin encode = 10'b0011101101; rd = 1'b1; end
      {1'b1, 1'b0, 8'h9c}: begin encode = 10'b0011100010; rd = 1'b0; end
      {1'b0, 1'b0, 8'h9d}: begin encode = 10'b1011100010; rd = 1'b0; end
      {1'b1, 1'b0, 8'h9d}: begin encode = 10'b0100011101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h9e}: begin encode = 10'b0111100010; rd = 1'b0; end
      {1'b1, 1'b0, 8'h9e}: begin encode = 10'b1000011101; rd = 1'b1; end
      {1'b0, 1'b0, 8'h9f}: begin encode = 10'b1010110010; rd = 1'b0; end
      {1'b1, 1'b0, 8'h9f}: begin encode = 10'b0101001101; rd = 1'b1; end
      {1'b0, 1'b0, 8'ha0}: begin encode = 10'b1001111010; rd = 1'b1; end
      {1'b1, 1'b0, 8'ha0}: begin encode = 10'b0110001010; rd = 1'b0; end
      {1'b0, 1'b0, 8'ha1}: begin encode = 10'b0111011010; rd = 1'b1; end
      {1'b1, 1'b0, 8'ha1}: begin encode = 10'b1000101010; rd = 1'b0; end
      {1'b0, 1'b0, 8'ha2}: begin encode = 10'b1011011010; rd = 1'b1; end
      {1'b1, 1'b0, 8'ha2}: begin encode = 10'b0100101010; rd = 1'b0; end
      {1'b0, 1'b0, 8'ha3}: begin encode = 10'b1100011010; rd = 1'b0; end
      {1'b1, 1'b0, 8'ha3}: begin encode = 10'b1100011010; rd = 1'b1; end
      {1'b0, 1'b0, 8'ha4}: begin encode = 10'b1101011010; rd = 1'b1; end
      {1'b1, 1'b0, 8'ha4}: begin encode = 10'b0010101010; rd = 1'b0; end
      {1'b0, 1'b0, 8'ha5}: begin encode = 10'b1010011010; rd = 1'b0; end
      {1'b1, 1'b0, 8'ha5}: begin encode = 10'b1010011010; rd = 1'b1; end
      {1'b0, 1'b0, 8'ha6}: begin encode = 10'b0110011010; rd = 1'b0; end
      {1'b1, 1'b0, 8'ha6}: begin encode = 10'b0110011010; rd = 1'b1; end
      {1'b0, 1'b0, 8'ha7}: begin encode = 10'b1110001010; rd = 1'b0; end
      {1'b1, 1'b0, 8'ha7}: begin encode = 10'b0001111010; rd = 1'b1; end
      {1'b0, 1'b0, 8'ha8}: begin encode = 10'b1110011010; rd = 1'b1; end
      {1'b1, 1'b0, 8'ha8}: begin encode = 10'b0001101010; rd = 1'b0; end
      {1'b0, 1'b0, 8'ha9}: begin encode = 10'b1001011010; rd = 1'b0; end
      {1'b1, 1'b0, 8'ha9}: begin encode = 10'b1001011010; rd = 1'b1; end
      {1'b0, 1'b0, 8'haa}: begin encode = 10'b0101011010; rd = 1'b0; end
      {1'b1, 1'b0, 8'haa}: begin encode = 10'b0101011010; rd = 1'b1; end
      {1'b0, 1'b0, 8'hab}: begin encode = 10'b1101001010; rd = 1'b0; end
      {1'b1, 1'b0, 8'hab}: begin encode = 10'b1101001010; rd = 1'b1; end
      {1'b0, 1'b0, 8'hac}: begin encode = 10'b0011011010; rd = 1'b0; end
      {1'b1, 1'b0, 8'hac}: begin encode = 10'b0011011010; rd = 1'b1; end
      {1'b0, 1'b0, 8'had}: begin encode = 10'b1011001010; rd = 1'b0; end
      {1'b1, 1'b0, 8'had}: begin encode = 10'b1011001010; rd = 1'b1; end
      {1'b0, 1'b0, 8'hae}: begin encode = 10'b0111001010; rd = 1'b0; end
      {1'b1, 1'b0, 8'hae}: begin encode = 10'b0111001010; rd = 1'b1; end
      {1'b0, 1'b0, 8'haf}: begin encode = 10'b0101111010; rd = 1'b1; end
      {1'b1, 1'b0, 8'haf}: begin encode = 10'b1010001010; rd = 1'b0; end
      {1'b0, 1'b0, 8'hb0}: begin encode = 10'b0110111010; rd = 1'b1; end
      {1'b1, 1'b0, 8'hb0}: begin encode = 10'b1001001010; rd = 1'b0; end
      {1'b0, 1'b0, 8'hb1}: begin encode = 10'b1000111010; rd = 1'b0; end
      {1'b1, 1'b0, 8'hb1}: begin encode = 10'b1000111010; rd = 1'b1; end
      {1'b0, 1'b0, 8'hb2}: begin encode = 10'b0100111010; rd = 1'b0; end
      {1'b1, 1'b0, 8'hb2}: begin encode = 10'b0100111010; rd = 1'b1; end
      {1'b0, 1'b0, 8'hb3}: begin encode = 10'b1100101010; rd = 1'b0; end
      {1'b1, 1'b0, 8'hb3}: begin encode = 10'b1100101010; rd = 1'b1; end
      {1'b0, 1'b0, 8'hb4}: begin encode = 10'b0010111010; rd = 1'b0; end
      {1'b1, 1'b0, 8'hb4}: begin encode = 10'b0010111010; rd = 1'b1; end
      {1'b0, 1'b0, 8'hb5}: begin encode = 10'b1010101010; rd = 1'b0; end
      {1'b1, 1'b0, 8'hb5}: begin encode = 10'b1010101010; rd = 1'b1; end
      {1'b0, 1'b0, 8'hb6}: begin encode = 10'b0110101010; rd = 1'b0; end
      {1'b1, 1'b0, 8'hb6}: begin encode = 10'b0110101010; rd = 1'b1; end
      {1'b0, 1'b0, 8'hb7}: begin encode = 10'b1110101010; rd = 1'b1; end
      {1'b1, 1'b0, 8'hb7}: begin encode = 10'b0001011010; rd = 1'b0; end
      {1'b0, 1'b0, 8'hb8}: begin encode = 10'b1100111010; rd = 1'b1; end
      {1'b1, 1'b0, 8'hb8}: begin encode = 10'b0011001010; rd = 1'b0; end
      {1'b0, 1'b0, 8'hb9}: begin encode = 10'b1001101010; rd = 1'b0; end
      {1'b1, 1'b0, 8'hb9}: begin encode = 10'b1001101010; rd = 1'b1; end
      {1'b0, 1'b0, 8'hba}: begin encode = 10'b0101101010; rd = 1'b0; end
      {1'b1, 1'b0, 8'hba}: begin encode = 10'b0101101010; rd = 1'b1; end
      {1'b0, 1'b0, 8'hbb}: begin encode = 10'b1101101010; rd = 1'b1; end
      {1'b1, 1'b0, 8'hbb}: begin encode = 10'b0010011010; rd = 1'b0; end
      {1'b0, 1'b0, 8'hbc}: begin encode = 10'b0011101010; rd = 1'b0; end
      {1'b1, 1'b0, 8'hbc}: begin encode = 10'b0011101010; rd = 1'b1; end
      {1'b0, 1'b0, 8'hbd}: begin encode = 10'b1011101010; rd = 1'b1; end
      {1'b1, 1'b0, 8'hbd}: begin encode = 10'b0100011010; rd = 1'b0; end
      {1'b0, 1'b0, 8'hbe}: begin encode = 10'b0111101010; rd = 1'b1; end
      {1'b1, 1'b0, 8'hbe}: begin encode = 10'b1000011010; rd = 1'b0; end
      {1'b0, 1'b0, 8'hbf}: begin encode = 10'b1010111010; rd = 1'b1; end
      {1'b1, 1'b0, 8'hbf}: begin encode = 10'b0101001010; rd = 1'b0; end
      {1'b0, 1'b0, 8'hc0}: begin encode = 10'b1001110110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hc0}: begin encode = 10'b0110000110; rd = 1'b0; end
      {1'b0, 1'b0, 8'hc1}: begin encode = 10'b0111010110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hc1}: begin encode = 10'b1000100110; rd = 1'b0; end
      {1'b0, 1'b0, 8'hc2}: begin encode = 10'b1011010110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hc2}: begin encode = 10'b0100100110; rd = 1'b0; end
      {1'b0, 1'b0, 8'hc3}: begin encode = 10'b1100010110; rd = 1'b0; end
      {1'b1, 1'b0, 8'hc3}: begin encode = 10'b1100010110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hc4}: begin encode = 10'b1101010110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hc4}: begin encode = 10'b0010100110; rd = 1'b0; end
      {1'b0, 1'b0, 8'hc5}: begin encode = 10'b1010010110; rd = 1'b0; end
      {1'b1, 1'b0, 8'hc5}: begin encode = 10'b1010010110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hc6}: begin encode = 10'b0110010110; rd = 1'b0; end
      {1'b1, 1'b0, 8'hc6}: begin encode = 10'b0110010110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hc7}: begin encode = 10'b1110000110; rd = 1'b0; end
      {1'b1, 1'b0, 8'hc7}: begin encode = 10'b0001110110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hc8}: begin encode = 10'b1110010110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hc8}: begin encode = 10'b0001100110; rd = 1'b0; end
      {1'b0, 1'b0, 8'hc9}: begin encode = 10'b1001010110; rd = 1'b0; end
      {1'b1, 1'b0, 8'hc9}: begin encode = 10'b1001010110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hca}: begin encode = 10'b0101010110; rd = 1'b0; end
      {1'b1, 1'b0, 8'hca}: begin encode = 10'b0101010110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hcb}: begin encode = 10'b1101000110; rd = 1'b0; end
      {1'b1, 1'b0, 8'hcb}: begin encode = 10'b1101000110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hcc}: begin encode = 10'b0011010110; rd = 1'b0; end
      {1'b1, 1'b0, 8'hcc}: begin encode = 10'b0011010110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hcd}: begin encode = 10'b1011000110; rd = 1'b0; end
      {1'b1, 1'b0, 8'hcd}: begin encode = 10'b1011000110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hce}: begin encode = 10'b0111000110; rd = 1'b0; end
      {1'b1, 1'b0, 8'hce}: begin encode = 10'b0111000110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hcf}: begin encode = 10'b0101110110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hcf}: begin encode = 10'b1010000110; rd = 1'b0; end
      {1'b0, 1'b0, 8'hd0}: begin encode = 10'b0110110110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hd0}: begin encode = 10'b1001000110; rd = 1'b0; end
      {1'b0, 1'b0, 8'hd1}: begin encode = 10'b1000110110; rd = 1'b0; end
      {1'b1, 1'b0, 8'hd1}: begin encode = 10'b1000110110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hd2}: begin encode = 10'b0100110110; rd = 1'b0; end
      {1'b1, 1'b0, 8'hd2}: begin encode = 10'b0100110110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hd3}: begin encode = 10'b1100100110; rd = 1'b0; end
      {1'b1, 1'b0, 8'hd3}: begin encode = 10'b1100100110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hd4}: begin encode = 10'b0010110110; rd = 1'b0; end
      {1'b1, 1'b0, 8'hd4}: begin encode = 10'b0010110110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hd5}: begin encode = 10'b1010100110; rd = 1'b0; end
      {1'b1, 1'b0, 8'hd5}: begin encode = 10'b1010100110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hd6}: begin encode = 10'b0110100110; rd = 1'b0; end
      {1'b1, 1'b0, 8'hd6}: begin encode = 10'b0110100110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hd7}: begin encode = 10'b1110100110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hd7}: begin encode = 10'b0001010110; rd = 1'b0; end
      {1'b0, 1'b0, 8'hd8}: begin encode = 10'b1100110110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hd8}: begin encode = 10'b0011000110; rd = 1'b0; end
      {1'b0, 1'b0, 8'hd9}: begin encode = 10'b1001100110; rd = 1'b0; end
      {1'b1, 1'b0, 8'hd9}: begin encode = 10'b1001100110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hda}: begin encode = 10'b0101100110; rd = 1'b0; end
      {1'b1, 1'b0, 8'hda}: begin encode = 10'b0101100110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hdb}: begin encode = 10'b1101100110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hdb}: begin encode = 10'b0010010110; rd = 1'b0; end
      {1'b0, 1'b0, 8'hdc}: begin encode = 10'b0011100110; rd = 1'b0; end
      {1'b1, 1'b0, 8'hdc}: begin encode = 10'b0011100110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hdd}: begin encode = 10'b1011100110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hdd}: begin encode = 10'b0100010110; rd = 1'b0; end
      {1'b0, 1'b0, 8'hde}: begin encode = 10'b0111100110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hde}: begin encode = 10'b1000010110; rd = 1'b0; end
      {1'b0, 1'b0, 8'hdf}: begin encode = 10'b1010110110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hdf}: begin encode = 10'b0101000110; rd = 1'b0; end
      {1'b0, 1'b0, 8'he0}: begin encode = 10'b1001110001; rd = 1'b0; end
      {1'b1, 1'b0, 8'he0}: begin encode = 10'b0110001110; rd = 1'b1; end
      {1'b0, 1'b0, 8'he1}: begin encode = 10'b0111010001; rd = 1'b0; end
      {1'b1, 1'b0, 8'he1}: begin encode = 10'b1000101110; rd = 1'b1; end
      {1'b0, 1'b0, 8'he2}: begin encode = 10'b1011010001; rd = 1'b0; end
      {1'b1, 1'b0, 8'he2}: begin encode = 10'b0100101110; rd = 1'b1; end
      {1'b0, 1'b0, 8'he3}: begin encode = 10'b1100011110; rd = 1'b1; end
      {1'b1, 1'b0, 8'he3}: begin encode = 10'b1100010001; rd = 1'b0; end
      {1'b0, 1'b0, 8'he4}: begin encode = 10'b1101010001; rd = 1'b0; end
      {1'b1, 1'b0, 8'he4}: begin encode = 10'b0010101110; rd = 1'b1; end
      {1'b0, 1'b0, 8'he5}: begin encode = 10'b1010011110; rd = 1'b1; end
      {1'b1, 1'b0, 8'he5}: begin encode = 10'b1010010001; rd = 1'b0; end
      {1'b0, 1'b0, 8'he6}: begin encode = 10'b0110011110; rd = 1'b1; end
      {1'b1, 1'b0, 8'he6}: begin encode = 10'b0110010001; rd = 1'b0; end
      {1'b0, 1'b0, 8'he7}: begin encode = 10'b1110001110; rd = 1'b1; end
      {1'b1, 1'b0, 8'he7}: begin encode = 10'b0001110001; rd = 1'b0; end
      {1'b0, 1'b0, 8'he8}: begin encode = 10'b1110010001; rd = 1'b0; end
      {1'b1, 1'b0, 8'he8}: begin encode = 10'b0001101110; rd = 1'b1; end
      {1'b0, 1'b0, 8'he9}: begin encode = 10'b1001011110; rd = 1'b1; end
      {1'b1, 1'b0, 8'he9}: begin encode = 10'b1001010001; rd = 1'b0; end
      {1'b0, 1'b0, 8'hea}: begin encode = 10'b0101011110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hea}: begin encode = 10'b0101010001; rd = 1'b0; end
      {1'b0, 1'b0, 8'heb}: begin encode = 10'b1101001110; rd = 1'b1; end
      {1'b1, 1'b0, 8'heb}: begin encode = 10'b1101001000; rd = 1'b0; end
      {1'b0, 1'b0, 8'hec}: begin encode = 10'b0011011110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hec}: begin encode = 10'b0011010001; rd = 1'b0; end
      {1'b0, 1'b0, 8'hed}: begin encode = 10'b1011001110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hed}: begin encode = 10'b1011001000; rd = 1'b0; end
      {1'b0, 1'b0, 8'hee}: begin encode = 10'b0111001110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hee}: begin encode = 10'b0111001000; rd = 1'b0; end
      {1'b0, 1'b0, 8'hef}: begin encode = 10'b0101110001; rd = 1'b0; end
      {1'b1, 1'b0, 8'hef}: begin encode = 10'b1010001110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hf0}: begin encode = 10'b0110110001; rd = 1'b0; end
      {1'b1, 1'b0, 8'hf0}: begin encode = 10'b1001001110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hf1}: begin encode = 10'b1000110111; rd = 1'b1; end
      {1'b1, 1'b0, 8'hf1}: begin encode = 10'b1000110001; rd = 1'b0; end
      {1'b0, 1'b0, 8'hf2}: begin encode = 10'b0100110111; rd = 1'b1; end
      {1'b1, 1'b0, 8'hf2}: begin encode = 10'b0100110001; rd = 1'b0; end
      {1'b0, 1'b0, 8'hf3}: begin encode = 10'b1100101110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hf3}: begin encode = 10'b1100100001; rd = 1'b0; end
      {1'b0, 1'b0, 8'hf4}: begin encode = 10'b0010110111; rd = 1'b1; end
      {1'b1, 1'b0, 8'hf4}: begin encode = 10'b0010110001; rd = 1'b0; end
      {1'b0, 1'b0, 8'hf5}: begin encode = 10'b1010101110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hf5}: begin encode = 10'b1010100001; rd = 1'b0; end
      {1'b0, 1'b0, 8'hf6}: begin encode = 10'b0110101110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hf6}: begin encode = 10'b0110100001; rd = 1'b0; end
      {1'b0, 1'b0, 8'hf7}: begin encode = 10'b1110100001; rd = 1'b0; end
      {1'b1, 1'b0, 8'hf7}: begin encode = 10'b0001011110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hf8}: begin encode = 10'b1100110001; rd = 1'b0; end
      {1'b1, 1'b0, 8'hf8}: begin encode = 10'b0011001110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hf9}: begin encode = 10'b1001101110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hf9}: begin encode = 10'b1001100001; rd = 1'b0; end
      {1'b0, 1'b0, 8'hfa}: begin encode = 10'b0101101110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hfa}: begin encode = 10'b0101100001; rd = 1'b0; end
      {1'b0, 1'b0, 8'hfb}: begin encode = 10'b1101100001; rd = 1'b0; end
      {1'b1, 1'b0, 8'hfb}: begin encode = 10'b0010011110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hfc}: begin encode = 10'b0011101110; rd = 1'b1; end
      {1'b1, 1'b0, 8'hfc}: begin encode = 10'b0011100001; rd = 1'b0; end
      {1'b0, 1'b0, 8'hfd}: begin encode = 10'b1011100001; rd = 1'b0; end
      {1'b1, 1'b0, 8'hfd}: begin encode = 10'b0100011110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hfe}: begin encode = 10'b0111100001; rd = 1'b0; end
      {1'b1, 1'b0, 8'hfe}: begin encode = 10'b1000011110; rd = 1'b1; end
      {1'b0, 1'b0, 8'hff}: begin encode = 10'b1010110001; rd = 1'b0; end
      {1'b1, 1'b0, 8'hff}: begin encode = 10'b0101001110; rd = 1'b1; end
      {1'b0, 1'b1, 8'h1c}: begin encode = 10'b0011110100; rd = 1'b0; end
      {1'b1, 1'b1, 8'h1c}: begin encode = 10'b1100001011; rd = 1'b1; end
      {1'b0, 1'b1, 8'h3c}: begin encode = 10'b0011111001; rd = 1'b1; end
      {1'b1, 1'b1, 8'h3c}: begin encode = 10'b1100000110; rd = 1'b0; end
      {1'b0, 1'b1, 8'h5c}: begin encode = 10'b0011110101; rd = 1'b1; end
      {1'b1, 1'b1, 8'h5c}: begin encode = 10'b1100001010; rd = 1'b0; end
      {1'b0, 1'b1, 8'h7c}: begin encode = 10'b0011110011; rd = 1'b1; end
      {1'b1, 1'b1, 8'h7c}: begin encode = 10'b1100001100; rd = 1'b0; end
      {1'b0, 1'b1, 8'h9c}: begin encode = 10'b0011110010; rd = 1'b0; end
      {1'b1, 1'b1, 8'h9c}: begin encode = 10'b1100001101; rd = 1'b1; end
      {1'b0, 1'b1, 8'hbc}: begin encode = 10'b0011111010; rd = 1'b1; end
      {1'b1, 1'b1, 8'hbc}: begin encode = 10'b1100000101; rd = 1'b0; end
      {1'b0, 1'b1, 8'hdc}: begin encode = 10'b0011110110; rd = 1'b1; end
      {1'b1, 1'b1, 8'hdc}: begin encode = 10'b1100001001; rd = 1'b0; end
      {1'b0, 1'b1, 8'hfc}: begin encode = 10'b0011111000; rd = 1'b0; end
      {1'b1, 1'b1, 8'hfc}: begin encode = 10'b1100000111; rd = 1'b1; end
      {1'b0, 1'b1, 8'hf7}: begin encode = 10'b1110101000; rd = 1'b0; end
      {1'b1, 1'b1, 8'hf7}: begin encode = 10'b0001010111; rd = 1'b1; end
      {1'b0, 1'b1, 8'hfb}: begin encode = 10'b1101101000; rd = 1'b0; end
      {1'b1, 1'b1, 8'hfb}: begin encode = 10'b0010010111; rd = 1'b1; end
      {1'b0, 1'b1, 8'hfd}: begin encode = 10'b1011101000; rd = 1'b0; end
      {1'b1, 1'b1, 8'hfd}: begin encode = 10'b0100010111; rd = 1'b1; end
      {1'b0, 1'b1, 8'hfe}: begin encode = 10'b0111101000; rd = 1'b0; end
      {1'b1, 1'b1, 8'hfe}: begin encode = 10'b1000010111; rd = 1'b1; end
      // K5.6 = send D5.6  if neg, D16.2 if pos
      {1'b0, 1'b1, 8'hc5}: begin encode = 10'b1010010110; rd = 1'b0; end
      {1'b1, 1'b1, 8'hc5}: begin encode = 10'b1001000101; rd = 1'b0; end
      endcase

   endfunction : encode

endclass : enc_8b10b_c

class dec_8b10b_c extends uvm_component;
   //----------------------------------------------------------------------------------------
   // Group: Types

   `uvm_component_utils_begin(cn_pkg::dec_8b10b_c)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   //----------------------------------------------------------------------------------------
   // Group: Fields

   // var: running disparity
   bit rd = 0;

   // var: disparity error
   bit disp_err = 0;

   // var: decode error
   bit dec_err = 0;

   //----------------------------------------------------------------------------------------
   // Group: Methods

   ////////////////////////////////////////////
   function new(string name="dec_8b10b",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   // func: build_phase
   // Hook up to the virtual interface
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction : build_phase
   
   ////////////////////////////////////////////
   // func: decode
   // 10b-to-8b decode
   function bit [8:0] decode(input bit [9:0] din);
      bit [7:0] rxd;
      bit       rxc;

      case (din)
      10'b1001110100: begin rxd = 8'h00; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end 
      10'b0110001011: begin rxd = 8'h00; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end 
      10'b0111010100: begin rxd = 8'h01; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end 
      10'b1000101011: begin rxd = 8'h01; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end 
      10'b1011010100: begin rxd = 8'h02; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end 
      10'b0100101011: begin rxd = 8'h02; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end 
      10'b1100011011: begin rxd = 8'h03; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b1100010100: begin rxd = 8'h03; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b1101010100: begin rxd = 8'h04; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end 
      10'b0010101011: begin rxd = 8'h04; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end 
      10'b1010011011: begin rxd = 8'h05; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b1010010100: begin rxd = 8'h05; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b0110011011: begin rxd = 8'h06; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b0110010100: begin rxd = 8'h06; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b1110001011: begin rxd = 8'h07; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b0001110100: begin rxd = 8'h07; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b1110010100: begin rxd = 8'h08; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end 
      10'b0001101011: begin rxd = 8'h08; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end 
      10'b1001011011: begin rxd = 8'h09; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b1001010100: begin rxd = 8'h09; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b0101011011: begin rxd = 8'h0a; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b0101010100: begin rxd = 8'h0a; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b1101001011: begin rxd = 8'h0b; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b1101000100: begin rxd = 8'h0b; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b0011011011: begin rxd = 8'h0c; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b0011010100: begin rxd = 8'h0c; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b1011001011: begin rxd = 8'h0d; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b1011000100: begin rxd = 8'h0d; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b0111001011: begin rxd = 8'h0e; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b0111000100: begin rxd = 8'h0e; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b0101110100: begin rxd = 8'h0f; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end 
      10'b1010001011: begin rxd = 8'h0f; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end 
      10'b0110110100: begin rxd = 8'h10; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end 
      10'b1001001011: begin rxd = 8'h10; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end 
      10'b1000111011: begin rxd = 8'h11; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b1000110100: begin rxd = 8'h11; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b0100111011: begin rxd = 8'h12; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b0100110100: begin rxd = 8'h12; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b1100101011: begin rxd = 8'h13; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b1100100100: begin rxd = 8'h13; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b0010111011: begin rxd = 8'h14; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b0010110100: begin rxd = 8'h14; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b1010101011: begin rxd = 8'h15; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b1010100100: begin rxd = 8'h15; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b0110101011: begin rxd = 8'h16; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b0110100100: begin rxd = 8'h16; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b1110100100: begin rxd = 8'h17; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end 
      10'b0001011011: begin rxd = 8'h17; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end 
      10'b1100110100: begin rxd = 8'h18; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end 
      10'b0011001011: begin rxd = 8'h18; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end 
      10'b1001101011: begin rxd = 8'h19; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b1001100100: begin rxd = 8'h19; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b0101101011: begin rxd = 8'h1a; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b0101100100: begin rxd = 8'h1a; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b1101100100: begin rxd = 8'h1b; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end 
      10'b0010011011: begin rxd = 8'h1b; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end 
      10'b0011101011: begin rxd = 8'h1c; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b0011100100: begin rxd = 8'h1c; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b1011100100: begin rxd = 8'h1d; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end 
      10'b0100011011: begin rxd = 8'h1d; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end 
      10'b0111100100: begin rxd = 8'h1e; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end 
      10'b1000011011: begin rxd = 8'h1e; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end 
      10'b1010110100: begin rxd = 8'h1f; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end 
      10'b0101001011: begin rxd = 8'h1f; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end 
      10'b1001111001: begin rxd = 8'h20; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b0110001001: begin rxd = 8'h20; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b0111011001: begin rxd = 8'h21; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b1000101001: begin rxd = 8'h21; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b1011011001: begin rxd = 8'h22; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end 
      10'b0100101001: begin rxd = 8'h22; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end 
      10'b1100011001: begin rxd = 8'h23; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1101011001: begin rxd = 8'h24; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0010101001: begin rxd = 8'h24; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1010011001: begin rxd = 8'h25; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0110011001: begin rxd = 8'h26; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1110001001: begin rxd = 8'h27; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0001111001: begin rxd = 8'h27; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1110011001: begin rxd = 8'h28; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0001101001: begin rxd = 8'h28; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1001011001: begin rxd = 8'h29; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0101011001: begin rxd = 8'h2a; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1101001001: begin rxd = 8'h2b; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0011011001: begin rxd = 8'h2c; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1011001001: begin rxd = 8'h2d; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0111001001: begin rxd = 8'h2e; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0101111001: begin rxd = 8'h2f; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1010001001: begin rxd = 8'h2f; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0110111001: begin rxd = 8'h30; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1001001001: begin rxd = 8'h30; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1000111001: begin rxd = 8'h31; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0100111001: begin rxd = 8'h32; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1100101001: begin rxd = 8'h33; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0010111001: begin rxd = 8'h34; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1010101001: begin rxd = 8'h35; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0110101001: begin rxd = 8'h36; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1110101001: begin rxd = 8'h37; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0001011001: begin rxd = 8'h37; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1100111001: begin rxd = 8'h38; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0011001001: begin rxd = 8'h38; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1001101001: begin rxd = 8'h39; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0101101001: begin rxd = 8'h3a; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1101101001: begin rxd = 8'h3b; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0010011001: begin rxd = 8'h3b; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0011101001: begin rxd = 8'h3c; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1011101001: begin rxd = 8'h3d; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0100011001: begin rxd = 8'h3d; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0111101001: begin rxd = 8'h3e; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1000011001: begin rxd = 8'h3e; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1010111001: begin rxd = 8'h3f; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0101001001: begin rxd = 8'h3f; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1001110101: begin rxd = 8'h40; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0110000101: begin rxd = 8'h40; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0111010101: begin rxd = 8'h41; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1000100101: begin rxd = 8'h41; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1011010101: begin rxd = 8'h42; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0100100101: begin rxd = 8'h42; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1100010101: begin rxd = 8'h43; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1101010101: begin rxd = 8'h44; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0010100101: begin rxd = 8'h44; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1010010101: begin rxd = 8'h45; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0110010101: begin rxd = 8'h46; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1110000101: begin rxd = 8'h47; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0001110101: begin rxd = 8'h47; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1110010101: begin rxd = 8'h48; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0001100101: begin rxd = 8'h48; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1001010101: begin rxd = 8'h49; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0101010101: begin rxd = 8'h4a; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1101000101: begin rxd = 8'h4b; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0011010101: begin rxd = 8'h4c; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1011000101: begin rxd = 8'h4d; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0111000101: begin rxd = 8'h4e; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0101110101: begin rxd = 8'h4f; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1010000101: begin rxd = 8'h4f; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0110110101: begin rxd = 8'h50; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1001000101: begin rxd = 8'h50; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1000110101: begin rxd = 8'h51; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0100110101: begin rxd = 8'h52; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1100100101: begin rxd = 8'h53; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0010110101: begin rxd = 8'h54; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1010100101: begin rxd = 8'h55; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0110100101: begin rxd = 8'h56; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1110100101: begin rxd = 8'h57; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0001010101: begin rxd = 8'h57; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1100110101: begin rxd = 8'h58; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0011000101: begin rxd = 8'h58; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1001100101: begin rxd = 8'h59; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0101100101: begin rxd = 8'h5a; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1101100101: begin rxd = 8'h5b; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0010010101: begin rxd = 8'h5b; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0011100101: begin rxd = 8'h5c; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1011100101: begin rxd = 8'h5d; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0100010101: begin rxd = 8'h5d; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0111100101: begin rxd = 8'h5e; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1000010101: begin rxd = 8'h5e; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1010110101: begin rxd = 8'h5f; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0101000101: begin rxd = 8'h5f; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1001110011: begin rxd = 8'h60; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0110001100: begin rxd = 8'h60; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0111010011: begin rxd = 8'h61; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1000101100: begin rxd = 8'h61; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1011010011: begin rxd = 8'h62; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0100101100: begin rxd = 8'h62; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1100011100: begin rxd = 8'h63; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1100010011: begin rxd = 8'h63; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1101010011: begin rxd = 8'h64; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0010101100: begin rxd = 8'h64; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1010011100: begin rxd = 8'h65; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1010010011: begin rxd = 8'h65; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0110011100: begin rxd = 8'h66; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0110010011: begin rxd = 8'h66; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1110001100: begin rxd = 8'h67; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0001110011: begin rxd = 8'h67; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1110010011: begin rxd = 8'h68; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0001101100: begin rxd = 8'h68; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1001011100: begin rxd = 8'h69; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1001010011: begin rxd = 8'h69; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0101011100: begin rxd = 8'h6a; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0101010011: begin rxd = 8'h6a; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1101001100: begin rxd = 8'h6b; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1101000011: begin rxd = 8'h6b; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0011011100: begin rxd = 8'h6c; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0011010011: begin rxd = 8'h6c; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1011001100: begin rxd = 8'h6d; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1011000011: begin rxd = 8'h6d; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0111001100: begin rxd = 8'h6e; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0111000011: begin rxd = 8'h6e; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0101110011: begin rxd = 8'h6f; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1010001100: begin rxd = 8'h6f; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0110110011: begin rxd = 8'h70; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1001001100: begin rxd = 8'h70; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1000111100: begin rxd = 8'h71; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1000110011: begin rxd = 8'h71; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0100111100: begin rxd = 8'h72; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0100110011: begin rxd = 8'h72; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1100101100: begin rxd = 8'h73; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1100100011: begin rxd = 8'h73; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0010111100: begin rxd = 8'h74; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0010110011: begin rxd = 8'h74; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1010101100: begin rxd = 8'h75; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1010100011: begin rxd = 8'h75; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0110101100: begin rxd = 8'h76; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0110100011: begin rxd = 8'h76; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1110100011: begin rxd = 8'h77; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0001011100: begin rxd = 8'h77; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1100110011: begin rxd = 8'h78; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0011001100: begin rxd = 8'h78; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1001101100: begin rxd = 8'h79; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1001100011: begin rxd = 8'h79; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0101101100: begin rxd = 8'h7a; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0101100011: begin rxd = 8'h7a; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1101100011: begin rxd = 8'h7b; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0010011100: begin rxd = 8'h7b; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0011101100: begin rxd = 8'h7c; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0011100011: begin rxd = 8'h7c; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1011100011: begin rxd = 8'h7d; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0100011100: begin rxd = 8'h7d; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0111100011: begin rxd = 8'h7e; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1000011100: begin rxd = 8'h7e; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1010110011: begin rxd = 8'h7f; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0101001100: begin rxd = 8'h7f; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1001110010: begin rxd = 8'h80; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0110001101: begin rxd = 8'h80; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0111010010: begin rxd = 8'h81; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1000101101: begin rxd = 8'h81; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1011010010: begin rxd = 8'h82; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0100101101: begin rxd = 8'h82; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1100011101: begin rxd = 8'h83; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1100010010: begin rxd = 8'h83; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1101010010: begin rxd = 8'h84; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0010101101: begin rxd = 8'h84; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1010011101: begin rxd = 8'h85; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1010010010: begin rxd = 8'h85; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0110011101: begin rxd = 8'h86; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0110010010: begin rxd = 8'h86; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1110001101: begin rxd = 8'h87; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0001110010: begin rxd = 8'h87; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1110010010: begin rxd = 8'h88; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0001101101: begin rxd = 8'h88; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1001011101: begin rxd = 8'h89; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1001010010: begin rxd = 8'h89; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0101011101: begin rxd = 8'h8a; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0101010010: begin rxd = 8'h8a; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1101001101: begin rxd = 8'h8b; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1101000010: begin rxd = 8'h8b; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0011011101: begin rxd = 8'h8c; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0011010010: begin rxd = 8'h8c; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1011001101: begin rxd = 8'h8d; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1011000010: begin rxd = 8'h8d; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0111001101: begin rxd = 8'h8e; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0111000010: begin rxd = 8'h8e; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0101110010: begin rxd = 8'h8f; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1010001101: begin rxd = 8'h8f; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0110110010: begin rxd = 8'h90; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1001001101: begin rxd = 8'h90; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1000111101: begin rxd = 8'h91; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1000110010: begin rxd = 8'h91; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0100111101: begin rxd = 8'h92; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0100110010: begin rxd = 8'h92; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1100101101: begin rxd = 8'h93; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1100100010: begin rxd = 8'h93; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0010111101: begin rxd = 8'h94; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0010110010: begin rxd = 8'h94; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1010101101: begin rxd = 8'h95; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1010100010: begin rxd = 8'h95; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0110101101: begin rxd = 8'h96; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0110100010: begin rxd = 8'h96; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1110100010: begin rxd = 8'h97; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0001011101: begin rxd = 8'h97; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1100110010: begin rxd = 8'h98; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0011001101: begin rxd = 8'h98; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1001101101: begin rxd = 8'h99; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1001100010: begin rxd = 8'h99; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0101101101: begin rxd = 8'h9a; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0101100010: begin rxd = 8'h9a; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1101100010: begin rxd = 8'h9b; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0010011101: begin rxd = 8'h9b; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0011101101: begin rxd = 8'h9c; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0011100010: begin rxd = 8'h9c; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1011100010: begin rxd = 8'h9d; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0100011101: begin rxd = 8'h9d; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0111100010: begin rxd = 8'h9e; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1000011101: begin rxd = 8'h9e; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1010110010: begin rxd = 8'h9f; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0101001101: begin rxd = 8'h9f; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1001111010: begin rxd = 8'ha0; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0110001010: begin rxd = 8'ha0; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0111011010: begin rxd = 8'ha1; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1000101010: begin rxd = 8'ha1; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1011011010: begin rxd = 8'ha2; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0100101010: begin rxd = 8'ha2; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1100011010: begin rxd = 8'ha3; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1101011010: begin rxd = 8'ha4; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0010101010: begin rxd = 8'ha4; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1010011010: begin rxd = 8'ha5; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0110011010: begin rxd = 8'ha6; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1110001010: begin rxd = 8'ha7; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0001111010: begin rxd = 8'ha7; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1110011010: begin rxd = 8'ha8; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0001101010: begin rxd = 8'ha8; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1001011010: begin rxd = 8'ha9; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0101011010: begin rxd = 8'haa; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1101001010: begin rxd = 8'hab; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0011011010: begin rxd = 8'hac; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1011001010: begin rxd = 8'had; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0111001010: begin rxd = 8'hae; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0101111010: begin rxd = 8'haf; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1010001010: begin rxd = 8'haf; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0110111010: begin rxd = 8'hb0; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1001001010: begin rxd = 8'hb0; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1000111010: begin rxd = 8'hb1; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0100111010: begin rxd = 8'hb2; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1100101010: begin rxd = 8'hb3; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0010111010: begin rxd = 8'hb4; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1010101010: begin rxd = 8'hb5; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0110101010: begin rxd = 8'hb6; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1110101010: begin rxd = 8'hb7; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0001011010: begin rxd = 8'hb7; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1100111010: begin rxd = 8'hb8; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0011001010: begin rxd = 8'hb8; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1001101010: begin rxd = 8'hb9; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0101101010: begin rxd = 8'hba; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1101101010: begin rxd = 8'hbb; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0010011010: begin rxd = 8'hbb; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0011101010: begin rxd = 8'hbc; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1011101010: begin rxd = 8'hbd; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0100011010: begin rxd = 8'hbd; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0111101010: begin rxd = 8'hbe; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1000011010: begin rxd = 8'hbe; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1010111010: begin rxd = 8'hbf; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0101001010: begin rxd = 8'hbf; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1001110110: begin rxd = 8'hc0; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0110000110: begin rxd = 8'hc0; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0111010110: begin rxd = 8'hc1; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1000100110: begin rxd = 8'hc1; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1011010110: begin rxd = 8'hc2; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0100100110: begin rxd = 8'hc2; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1100010110: begin rxd = 8'hc3; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1101010110: begin rxd = 8'hc4; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0010100110: begin rxd = 8'hc4; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1010010110: begin rxd = 8'hc5; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0110010110: begin rxd = 8'hc6; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1110000110: begin rxd = 8'hc7; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0001110110: begin rxd = 8'hc7; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1110010110: begin rxd = 8'hc8; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0001100110: begin rxd = 8'hc8; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1001010110: begin rxd = 8'hc9; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0101010110: begin rxd = 8'hca; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1101000110: begin rxd = 8'hcb; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0011010110: begin rxd = 8'hcc; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1011000110: begin rxd = 8'hcd; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0111000110: begin rxd = 8'hce; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0101110110: begin rxd = 8'hcf; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1010000110: begin rxd = 8'hcf; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0110110110: begin rxd = 8'hd0; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1001000110: begin rxd = 8'hd0; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1000110110: begin rxd = 8'hd1; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0100110110: begin rxd = 8'hd2; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1100100110: begin rxd = 8'hd3; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0010110110: begin rxd = 8'hd4; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1010100110: begin rxd = 8'hd5; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0110100110: begin rxd = 8'hd6; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1110100110: begin rxd = 8'hd7; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0001010110: begin rxd = 8'hd7; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1100110110: begin rxd = 8'hd8; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0011000110: begin rxd = 8'hd8; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1001100110: begin rxd = 8'hd9; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b0101100110: begin rxd = 8'hda; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1101100110: begin rxd = 8'hdb; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0010010110: begin rxd = 8'hdb; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0011100110: begin rxd = 8'hdc; rxc = 1'b0; {dec_err, disp_err} =       2'b00; rd =     rd; end
      10'b1011100110: begin rxd = 8'hdd; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0100010110: begin rxd = 8'hdd; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0111100110: begin rxd = 8'hde; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1000010110: begin rxd = 8'hde; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1010110110: begin rxd = 8'hdf; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0101000110: begin rxd = 8'hdf; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1001110001: begin rxd = 8'he0; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0110001110: begin rxd = 8'he0; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0111010001: begin rxd = 8'he1; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1000101110: begin rxd = 8'he1; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1011010001: begin rxd = 8'he2; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0100101110: begin rxd = 8'he2; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1100011110: begin rxd = 8'he3; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1100010001: begin rxd = 8'he3; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1101010001: begin rxd = 8'he4; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0010101110: begin rxd = 8'he4; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1010011110: begin rxd = 8'he5; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1010010001: begin rxd = 8'he5; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0110011110: begin rxd = 8'he6; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0110010001: begin rxd = 8'he6; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1110001110: begin rxd = 8'he7; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0001110001: begin rxd = 8'he7; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1110010001: begin rxd = 8'he8; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0001101110: begin rxd = 8'he8; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1001011110: begin rxd = 8'he9; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1001010001: begin rxd = 8'he9; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0101011110: begin rxd = 8'hea; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0101010001: begin rxd = 8'hea; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1101001110: begin rxd = 8'heb; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1101001000: begin rxd = 8'heb; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0011011110: begin rxd = 8'hec; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0011010001: begin rxd = 8'hec; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1011001110: begin rxd = 8'hed; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1011001000: begin rxd = 8'hed; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0111001110: begin rxd = 8'hee; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0111001000: begin rxd = 8'hee; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0101110001: begin rxd = 8'hef; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1010001110: begin rxd = 8'hef; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0110110001: begin rxd = 8'hf0; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1001001110: begin rxd = 8'hf0; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1000110111: begin rxd = 8'hf1; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1000110001: begin rxd = 8'hf1; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0100110111: begin rxd = 8'hf2; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0100110001: begin rxd = 8'hf2; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1100101110: begin rxd = 8'hf3; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1100100001: begin rxd = 8'hf3; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0010110111: begin rxd = 8'hf4; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0010110001: begin rxd = 8'hf4; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1010101110: begin rxd = 8'hf5; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1010100001: begin rxd = 8'hf5; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0110101110: begin rxd = 8'hf6; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0110100001: begin rxd = 8'hf6; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1110100001: begin rxd = 8'hf7; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0001011110: begin rxd = 8'hf7; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1100110001: begin rxd = 8'hf8; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0011001110: begin rxd = 8'hf8; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1001101110: begin rxd = 8'hf9; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1001100001: begin rxd = 8'hf9; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0101101110: begin rxd = 8'hfa; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0101100001: begin rxd = 8'hfa; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1101100001: begin rxd = 8'hfb; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0010011110: begin rxd = 8'hfb; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0011101110: begin rxd = 8'hfc; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b0011100001: begin rxd = 8'hfc; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b1011100001: begin rxd = 8'hfd; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0100011110: begin rxd = 8'hfd; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0111100001: begin rxd = 8'hfe; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1000011110: begin rxd = 8'hfe; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1010110001: begin rxd = 8'hff; rxc = 1'b0; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0101001110: begin rxd = 8'hff; rxc = 1'b0; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0011110100: begin rxd = 8'h1c; rxc = 1'b1; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1100001011: begin rxd = 8'h1c; rxc = 1'b1; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0011111001: begin rxd = 8'h3c; rxc = 1'b1; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1100000110: begin rxd = 8'h3c; rxc = 1'b1; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0011110101: begin rxd = 8'h5c; rxc = 1'b1; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1100001010: begin rxd = 8'h5c; rxc = 1'b1; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0011110011: begin rxd = 8'h7c; rxc = 1'b1; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1100001100: begin rxd = 8'h7c; rxc = 1'b1; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0011110010: begin rxd = 8'h9c; rxc = 1'b1; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1100001101: begin rxd = 8'h9c; rxc = 1'b1; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0011111010: begin rxd = 8'hbc; rxc = 1'b1; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1100000101: begin rxd = 8'hbc; rxc = 1'b1; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0011110110: begin rxd = 8'hdc; rxc = 1'b1; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b1; end
      10'b1100001001: begin rxd = 8'hdc; rxc = 1'b1; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b0; end
      10'b0011111000: begin rxd = 8'hfc; rxc = 1'b1; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1100000111: begin rxd = 8'hfc; rxc = 1'b1; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1110101000: begin rxd = 8'hf7; rxc = 1'b1; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0001010111: begin rxd = 8'hf7; rxc = 1'b1; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1101101000: begin rxd = 8'hfb; rxc = 1'b1; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0010010111: begin rxd = 8'hfb; rxc = 1'b1; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b1011101000: begin rxd = 8'hfd; rxc = 1'b1; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b0100010111: begin rxd = 8'hfd; rxc = 1'b1; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0111101000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} = {1'b0,  rd}; rd =   1'b0; end
      10'b1000010111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} = {1'b0, ~rd}; rd =   1'b1; end
      10'b0000000000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000000001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000000010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000000011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000000100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000000101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000000110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000000111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000001000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000001001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000001010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000001011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000001100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000001101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000001110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000001111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000010000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000010001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000010010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000010011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000010100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000010101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000010110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000010111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000011000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000011001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000011010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000011011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000011100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000011101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000011110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000011111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000100000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000100001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000100010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000100011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000100100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000100101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000100110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000100111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000101000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000101001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000101010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000101011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000101100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000101101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000101110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000101111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000110000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000110001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000110010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000110011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000110100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000110101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000110110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000110111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000111000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000111001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000111010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000111011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000111100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0000111101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000111110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0000111111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0001000000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001000001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001000010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001000011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0001000100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001000101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001000110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001000111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0001001000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001001001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001001010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001001011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0001001100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001001101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0001001110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0001001111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0001010000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001010001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001010010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001010011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0001010100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001011000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001011111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0001100000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001100001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001100010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001100011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0001100100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001100111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0001101000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001101111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0001110000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001110111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0001111000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001111011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0001111100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0001111101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0001111110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0001111111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0010000000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010000001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010000010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010000011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0010000100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010000101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010000110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010000111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0010001000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010001001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010001010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010001011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0010001100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010001101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0010001110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0010001111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0010010000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010010001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010010010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010010011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0010010100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010011000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010011111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0010100000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010100001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010100010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010100011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0010100100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010100111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0010101000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010101111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0010110000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010111000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0010111110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0010111111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0011000000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0011000001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0011000010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0011000011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0011000100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0011000111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0011001000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0011001111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0011010000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0011010111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0011011000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0011011111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0011100000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0011100111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0011101000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0011101111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0011110000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0011110001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0011110111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0011111011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0011111100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0011111101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0011111110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0011111111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0100000000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100000001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100000010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100000011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0100000100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100000101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100000110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100000111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0100001000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100001001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100001010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100001011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0100001100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100001101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0100001110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0100001111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0100010000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100010001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100010010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100010011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0100010100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100011000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100011111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0100100000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100100001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100100010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100100011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0100100100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100100111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0100101000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100101111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0100110000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100111000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0100111110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0100111111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0101000000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0101000001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0101000010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0101000011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0101000100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0101000111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0101001000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0101001111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0101010000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0101010111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0101011000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0101011111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0101100000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0101100111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0101101000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0101101111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0101110000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0101110111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0101111000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0101111011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0101111100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0101111101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0101111110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0101111111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0110000000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0110000001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0110000010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0110000011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0110000100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0110000111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0110001000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0110001111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0110010000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0110010111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0110011000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0110011111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0110100000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0110100111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0110101000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0110101111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0110110000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0110110111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0110111000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0110111011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0110111100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0110111101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0110111110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0110111111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111000000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0111000001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0111000111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111001111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111010000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0111010111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111011000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0111011011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111011100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0111011101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111011110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111011111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111100000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0111100111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111101011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111101100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0111101101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111101110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111101111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111110000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0111110001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0111110010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0111110011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111110100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0111110101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111110110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111110111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111111000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0111111001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111111010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111111011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111111100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b0111111101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111111110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b0111111111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1000000000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000000001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000000010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000000011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1000000100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000000101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000000110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000000111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1000001000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000001001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000001010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000001011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1000001100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000001101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1000001110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1000001111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1000010000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000010001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000010010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000010011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1000010100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000011000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000011111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1000100000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000100001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000100010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000100011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1000100100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000100111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1000101000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000101111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1000110000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000111000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1000111110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1000111111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1001000000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1001000001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1001000010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1001000011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1001000100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1001000111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1001001000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1001001111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1001010000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1001010111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1001011000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1001011111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1001100000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1001100111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1001101000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1001101111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1001110000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1001110111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1001111000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1001111011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1001111100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1001111101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1001111110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1001111111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1010000000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1010000001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1010000010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1010000011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1010000100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1010000111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1010001000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1010001111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1010010000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1010010111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1010011000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1010011111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1010100000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1010100111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1010101000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1010101111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1010110000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1010110111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1010111000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1010111011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1010111100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1010111101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1010111110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1010111111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011000000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1011000001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1011000111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011001111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011010000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1011010111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011011000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1011011011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011011100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1011011101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011011110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011011111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011100000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1011100111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011101011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011101100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1011101101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011101110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011101111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011110000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1011110001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1011110010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1011110011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011110100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1011110101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011110110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011110111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011111000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1011111001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011111010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011111011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011111100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1011111101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011111110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1011111111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1100000000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1100000001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1100000010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1100000011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1100000100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1100001000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1100001110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1100001111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1100010000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1100010111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1100011000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1100011111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1100100000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1100100111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1100101000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1100101111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1100110000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1100110111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1100111000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1100111011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1100111100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1100111101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1100111110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1100111111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101000000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1101000001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1101000111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101001111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101010000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1101010111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101011000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1101011011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101011100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1101011101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101011110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101011111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101100000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1101100111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101101011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101101100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1101101101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101101110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101101111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101110000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1101110001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1101110010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1101110011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101110100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1101110101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101110110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101110111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101111000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1101111001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101111010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101111011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101111100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1101111101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101111110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1101111111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110000000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1110000001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1110000010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1110000011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110000100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1110000111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110001000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1110001111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110010000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1110010111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110011000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1110011011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110011100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1110011101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110011110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110011111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110100000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1110100111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110101011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110101100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1110101101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110101110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110101111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110110000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1110110001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1110110010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1110110011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110110100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1110110101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110110110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110110111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110111000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1110111001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110111010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110111011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110111100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1110111101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110111110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1110111111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111000000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111000001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111000010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111000011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111000100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111000101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111000110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111000111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111001000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111001001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111001010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111001011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111001100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111001101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111001110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111001111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111010000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111010001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111010010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111010011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111010100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111010101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111010110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111010111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111011000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111011001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111011010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111011011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111011100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111011101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111011110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111011111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111100000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111100001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111100010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111100011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111100100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111100101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111100110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111100111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111101000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111101001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111101010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111101011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111101100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111101101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111101110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111101111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111110000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111110001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111110010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111110011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111110100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111110101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111110110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111110111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111111000: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111111001: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111111010: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111111011: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111111100: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b0; end
      10'b1111111101: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111111110: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      10'b1111111111: begin rxd = 8'hfe; rxc = 1'b1; {dec_err, disp_err} =       2'b10; rd =   1'b1; end
      default:        begin rxd = 8'hxx; rxc = 1'bx; {dec_err, disp_err} =       2'bxx; rd =  2'bxx; end
      endcase

      decode = {rxc, rxd};
   endfunction : decode

endclass : dec_8b10b_c

`endif // __CN_8B10B_ENC_SV__
