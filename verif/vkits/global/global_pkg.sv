
// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.3.3)
// ***********************************************************************
// File:   global_pkg.sv
// Author: bhunter
/* About:  Components available to all testbenches.
 *************************************************************************/


`include "uvm_macros.svh"
`include "cn_macros.sv"
`include "global_macros.sv"

package global_pkg;

   //--------------------------------------------------------------------------
   // Group: Imports
   import uvm_pkg::*;

   //--------------------------------------------------------------------------
   // Group: Includes
`include "global_heartbeat_mon.sv"
`include "global_watchdog.sv"
`include "global_env.sv"

endpackage : global_pkg


