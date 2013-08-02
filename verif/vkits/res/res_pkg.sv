
// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2013
// * (utg v0.10)
// ***********************************************************************
// File:   res_pkg.sv
// Author: bhunter
/* About:  res package
 *************************************************************************/


// (`includes of macros may go here)
`include "uvm_macros.svh"

// package: res_pkg
// (Describe me)
package res_pkg;

   //----------------------------------------------------------------------------------------
   // Group: Imports
   import uvm_pkg::*;

   //----------------------------------------------------------------------------------------
   // Group: Includes

`include "res_agent.sv"
`include "res_mon.sv"
`include "res_types.sv"

endpackage : res_pkg


