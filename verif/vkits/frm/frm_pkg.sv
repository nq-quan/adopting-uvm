
// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.6.3)
// ***********************************************************************
// File:   frm_pkg.sv
// Author: bhunter
/* About:  Contains the framer agent
 *************************************************************************/

`include "uvm_macros.svh"

// package: frm_pkg
// Framer package
package frm_pkg;

   //----------------------------------------------------------------------------------------
   // Group: Imports
   import uvm_pkg::*;

   //----------------------------------------------------------------------------------------
   // Group: Includes
`include "frm_agent.sv"
`include "frm_cfg.sv"
`include "frm_drv.sv"
`include "frm_env.sv"
`include "frm_frame.sv"
`include "frm_intf.sv"
`include "frm_mon.sv"
`include "frm_seq_lib.sv"
`include "frm_sqr.sv"
`include "frm_vseq_lib.sv"

endpackage : frm_pkg


