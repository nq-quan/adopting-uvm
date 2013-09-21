<@header>

// (`includes go here)

import uvm_pkg::*;
// (other imports go here)

`include "cn_defines.vh"

// package: <name>_tb_top
// Top-level testbench
module <name>_tb_top;
   /*AUTOWIRE*/

   /*AUTOREG*/

<@section_border>
   // Group: Interfaces

   // obj: tb_clk_i
   // Testbench clock interface
   cn_clk_intf tb_clk_i();
   wire tb_clk = tb_clk_i.clk;

   // obj: tb_rst_i
   // Testbench reset interface
   cn_rst_intf tb_rst_i();
   wire tb_rst_n = tb_rst_i.rst_n;
   
   // obj: frm_i
   // The <name>_intf instance.
   <name>_intf <name>_i(.clk(tb_clk),
                        .rst_n(tb_rst_n));
   
<@section_border>
   // Group: DUT
   // (Instantiate the DUT or DUT wrapper and other modules here)
   dut_module dut(/*AUTOINST*/);

<@section_border>
   // Group: Procedural Blocks

<@method_border>
   // func: pre_run_test
   // Set interface names before run_test is called
   function void pre_run_test();
      `cn_set_intf(virtual cn_clk_intf,  "cn_pkg::clk_intf", "tb_clk_vi",  tb_clk_i)
      `cn_set_intf(virtual cn_rst_intf,  "cn_pkg::rst_intf", "tb_rst_vi",  tb_rst_i)
   endfunction : pre_run_test
   
   `include "tbv_common.v"
endmodule : <name>_tb_top

// Local Variables:
// verilog-library-extensions:(".v" ".sv" ".svh")
// verilog-library-directories:("." "../../rtl/include/" "../common" "../vkits/<name>" "../hdl")
// verilog-auto-ignore-concat:t
// End:
   