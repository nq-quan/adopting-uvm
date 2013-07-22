#!/bin/csh

if ($#argv != 1) then
   echo "usage: cn_dep_node__selftest.csh <test_class_c>"
else
   qrsh -V -l vcs=1 -l urg_plus20 -l lic_cmp_vcs=1 -l lic_sim_vcs=1 -q verilog "runmod -t vcs vcs +vcs+lic+wait -R -sverilog -timescale=1ns/1ns +incdir+../uvm/1_1a/src+. +UVM_TESTNAME=$1 +define+__SELF_TEST__ -debug_all ../uvm/1_1a/src/uvm_pkg.sv ./cn_self_test.sv ../../lib/uvm_dpiVcs.a cn_dep_node.sv"
endif

