// ************************************************************************
// *
// * legal mumbo jumbo
// *
// *  Copyright 2011
// ************************************************************************

`ifndef __CN_MSG_HDL__
   `define __CN_MSG_HDL__

   `include "cn_msgs.sv"

   `define cn_info_hdl(MSG)  msg_hdl.msg_root.uvm_report_info ("vlog", $sformatf("%s [%m]", $sformatf MSG), uvm_pkg::UVM_NONE, `uvm_file, `uvm_line);
   `define cn_err_hdl(MSG)   msg_hdl.msg_root.uvm_report_error("vlog", $sformatf("%s [%m]", $sformatf MSG), uvm_pkg::UVM_NONE, `uvm_file, `uvm_line);
   `define cn_fatal_hdl(MSG) msg_hdl.msg_root.uvm_report_fatal("vlog", $sformatf("%s [%m]", $sformatf MSG), uvm_pkg::UVM_NONE, `uvm_file, `uvm_line);

   module msg_hdl ();
      class msg_vlog_c extends uvm_component;
         function new(string name="vlog", uvm_component parent=null);
            super.new(name, parent);
         endfunction : new
      endclass : msg_vlog_c

      msg_vlog_c	msg_root  = new("vlog");
   endmodule

`endif // __CN_MSG_HDL__
