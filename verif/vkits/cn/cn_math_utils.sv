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
// * (c) 2011, Cavium, Inc.  All rights reserved.                      
// ***********************************************************************
// File:   cn_math_utils.sv
// Author: mcarns
/* About:  Common trivial math routines

For now, these are defined for ints.  I'd prefer to allow them to be
parameterized/templated, but you can't parameterize free functions in SV.

 *************************************************************************/


`ifndef __CN_MATH_UTILS_SV__
   `define __CN_MATH_UTILS_SV__

////////////////////////////////////////////
// func: round_up
// Round x up to the nearest multiple of n
//
// Arguments:
//   x : The number to round.
//   n : The multiple to round up to.
function automatic int round_up(int x, int n);
   int y = x - 1;
   return y + n - (y % n);
endfunction : round_up


`endif // __CN_MATH_UTILS_SV__
