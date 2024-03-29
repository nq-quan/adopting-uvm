
// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.3.3)
// ***********************************************************************
// File:   cn_clk_intf.sv
// Author: bhunter
/* About:  Clock Interface
 *************************************************************************/


`ifndef __CN_CLK_INTF_SV__
   `define __CN_CLK_INTF_SV__

// class: cn_clk_intf
// A simple interface holding the clock wire, and it's ideal clock
interface cn_clk_intf();

   //----------------------------------------------------------------------------------------
   // Group: Signals

   logic clk;
   logic clk_ideal;

endinterface : cn_clk_intf

`endif // __CN_CLK_INTF_SV__
