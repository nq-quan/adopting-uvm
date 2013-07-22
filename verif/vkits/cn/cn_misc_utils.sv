//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-
// ***********************************************************************
// * CAVIUM NETWORKS CONFIDENTIAL                                        *
// *                                                                     *
// *                         PROPRIETARY NOTE                            *
// *                                                                     *
// *  This software contains information confidential and proprietary    *
// *  to Cavium Networks.  It shall not be reproduced in whole or in     *
// *  part, or transferred to other documents, or disclosed to third     *
// *  parties, or used for any purpose other than that for which it was  *
// *  obtained, without the prior written consent of Cavium Networks.    *
// *  (c) 2010, Cavium Networks.  All rights reserved.                   *
// *                                                                     *
// ***********************************************************************
// * File        : cn_misc_utils.sv
// * Author      : 
// * Description : cloned from the verif/common/cn_types.h    
// ***********************************************************************
`ifndef __CN_MISC_UTILS_SV__
 `define __CN_MISC_UTILS_SV__

 `include "cn_reg_bag.sv"

// func: ffs
// return one hot with only first bit set, 0 returns 0
function longint unsigned ffs(longint unsigned _val);
    return (~_val + 1) & _val;
endfunction : ffs

// func: ffc
// return one hot with only first bit clear, -1 returns -1
function  longint unsigned ffc(longint unsigned  _val);
    return (_val + 1) & ~_val;
endfunction : ffc

// func: encode
// Encode a one hot signal    
function longint unsigned encode(longint unsigned _oneHot); 
   longint unsigned result;
   result = 0;
   while (_oneHot) begin
      case(_oneHot) 
        1:       return result+0;  
        2:       return result+1; 
        4:       return result+2;  
        8:       return result+3;  
        16:      return result+4;  
        32:      return result+5;  
        64:      return result+6;  
        128:     return result+7;  
        default:  begin
           result += 8;
           _oneHot >>= 8;    
        end
      endcase 
   end
   return result;
endfunction : encode

`endif // __CN_MISC_UTILS_SV__