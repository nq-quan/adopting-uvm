
// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// ***********************************************************************
// File:   cn_print_utils.sv
// Author: bhunter
/* About:  Common utilities for printing things

 I'm not fond of the fact that the array type for print_byte_array has to be so
 specific (byte unsigned, not byte or int, etc.).  The parameterized class below
 is one way of fixing this, but makes the usage complicated

 *************************************************************************/


`ifndef __CN_PRINT_UTILS_SV__
   `define __CN_PRINT_UTILS_SV__

////////////////////////////////////////////
// func: print_ubyte_array
// Prints an array of unsigned bytes
//
// Arguments:
//   _array        : The data array (ref unsigned byte [])
//   _num_per_line : Number of entries per line
//   _separate_line: Prints a new-line first if array size < _num_per_line
function string print_ubyte_array(ref byte unsigned _array[],
                                          input int _num_per_line=8,
                                          input bit _separate_line=0);

   bit separate_line;

   separate_line = (_separate_line || _array.size() > _num_per_line)? 1:0;

   if(separate_line)
      print_ubyte_array = $sformatf("\n[%0d bytes]\n", _array.size());
   else
      print_ubyte_array = "[";

   foreach(_array[idx]) begin
      if(((idx % _num_per_line) == 0) && separate_line)
         print_ubyte_array = $sformatf("%s.%03d  ", print_ubyte_array, idx);
      print_ubyte_array = $sformatf("%s %02X", print_ubyte_array, _array[idx]);
      if(((idx+1) % _num_per_line == 0) && separate_line)
         print_ubyte_array = {print_ubyte_array, "\n"};
   end
   if(separate_line && (_array.size() % _num_per_line) != 0)
      print_ubyte_array = {print_ubyte_array, "\n"};
   if(!separate_line)
      print_ubyte_array = {print_ubyte_array, " ]"};
endfunction : print_ubyte_array

////////////////////////////////////////////
// func: print_byte_array
// Prints an array of signed bytes
//
// Arguments:
//   _array        : The data array (ref byte [])
//   _num_per_line : Number of entries per line
//   _separate_line: Prints a new-line first if array size < _num_per_line
function string print_byte_array(ref byte _array[],
                                 input int _num_per_line=8,
                                 input bit _separate_line=0);

   bit separate_line;

   separate_line = (_separate_line || _array.size() > _num_per_line)? 1:0;

   if(separate_line)
      print_byte_array = $sformatf("\n[%0d bytes]\n", _array.size());
   else
      print_byte_array = "[";

   foreach(_array[idx]) begin
      if(((idx % _num_per_line) == 0) && separate_line)
         print_byte_array = $sformatf("%s.%03d  ", print_byte_array, idx);
      print_byte_array = $sformatf("%s %02X", print_byte_array, _array[idx]);
      if(((idx+1) % _num_per_line == 0) && separate_line)
         print_byte_array = {print_byte_array, "\n"};
   end
   if(separate_line && (_array.size() % _num_per_line) != 0)
      print_byte_array = {print_byte_array, "\n"};
   if(!separate_line)
      print_byte_array = {print_byte_array, " ]"};
endfunction : print_byte_array

////////////////////////////////////////////
// func: print_bit8_array
// Prints an array of 8-bit values
//
// Arguments:
//   _array        : The data array (ref bit[7:0][])
//   _num_per_line : Number of entries per line
//   _separate_line: Prints a new-line first if array size < _num_per_line
function string print_bit8_array(ref bit[7:0] _array[],
                                 input int _num_per_line=8,
                                 input bit _separate_line=0);

   bit separate_line;

   separate_line = (_separate_line || _array.size() > _num_per_line)? 1:0;

   if(separate_line)
      print_bit8_array = $sformatf("\n[%0d bytes]\n", _array.size());
   else
      print_bit8_array = "[";

   foreach(_array[idx]) begin
      if(((idx % _num_per_line) == 0) && separate_line)
         print_bit8_array = $sformatf("%s.%03d  ", print_bit8_array, idx);
      print_bit8_array = $sformatf("%s %02X", print_bit8_array, _array[idx]);
      if(((idx+1) % _num_per_line == 0) && separate_line)
         print_bit8_array = {print_bit8_array, "\n"};
   end
   if(separate_line && (_array.size() % _num_per_line) != 0)
      print_bit8_array = {print_bit8_array, "\n"};
   if(!separate_line)
      print_bit8_array = {print_bit8_array, " ]"};
endfunction : print_bit8_array



`endif // __CN_PRINT_UTILS_SV__
