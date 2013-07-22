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
// * (c) 2013, Cavium, Inc.  All rights reserved.                      
// * (utg v0.8)
// ***********************************************************************
// File:   ctx_types.sv
// Author: bhunter
/* About:  Typedefs for CTX
 *************************************************************************/

`ifndef __CTX_TYPES_SV__
   `define __CTX_TYPES_SV__


// typedef: addr_t
// Addresses are this big
typedef bit[6:0]   addr_t;

// typedef: data_t
// Data bus is this wide
typedef bit [31:0] data_t;


`endif // __CTX_TYPES_SV__

