
import uvm_pkg::*;

   initial begin : vpd_dumping
   	if($test$plusargs("vpdon"))
   		$vcdpluson(0);
   end : vpd_dumping

   /////////////////////////////////////////////////////////////////////////////
   // 1. replace the UVM report server with ours
   //    and set the timeformat
   // 2. call pre_run_test(). testbenches MUST override this with any functionality
   //    that should occur before run_test.
   // 3. call run_test.
   /////////////////////////////////////////////////////////////////////////////
   initial begin : start_uvm
      cn_pkg::report_server_c        report_server;
      int unsigned                   seed_value;

      // all "%t" shall print out in ns format with 9 digits and 3 decimal places
      $timeformat(-9,3,"ns",13);
      report_server = cn_pkg::report_server_c::type_id::create();

      // replace uvm_report_server with cn_report_server_c
      uvm_pkg::uvm_report_server::set_server(report_server);

      if(!$value$plusargs("seed=%d", seed_value))
         `cn_err_hdl(("Error parsing command-line arg: +seed"));
      `cn_info_hdl(("Running simulation with seed: %0d", seed_value));

      // testbenches must create this zero-time function
      pre_run_test();
      run_test();
   end : start_uvm

   initial begin
      #(1ns);
      if(global_pkg::env == null)
         `cn_fatal_hdl(("Must create global env when running UVM"));
   end

   ////////////////////////////////////////////
   // Functional Coverage
   ////////////////////////////////////////////
   initial begin : functional_coverage
      integer svfcov;
      if ($value$plusargs("svfcov=%d", svfcov)) begin
         uvm_config_db#(int)::set(uvm_top, "*", "coverage_enable", svfcov);
      end else begin
         uvm_config_db#(int)::set(uvm_top, "*", "coverage_enable", 0);
      end
   end

   // Root message tag instance
   msg_hdl msg_hdl ();


