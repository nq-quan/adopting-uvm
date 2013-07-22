// ************************************************************************
// *                                                                      *
// *
// * legal mumbo jumbo
// *
// *                                                                      *
// *  Copyright 2011
// *                                                                      *
// ************************************************************************
// * Author      : bdobbie
// * Description : module to associate messages with a msg_vlog component
// ************************************************************************

`include "cn_defines.vh"
`cn_timescale

module cn_msg_tag ();

`ifndef CN_LINT

   parameter string 	MSG_TAG    = "";

   const string		scope     = $sformatf("%m");
   const string		msg_tag   = $sformatf(MSG_TAG);
   cn_pkg::msg_vlog_c	msg_root  = cn_pkg::msg_vlog_c::get_vlog_root();
   cn_pkg::msg_vlog_c	msg_leaf  = msg_root.register_leaf(scope,msg_tag);
   string		full_name = msg_leaf.get_full_name();

   initial begin
      msg_leaf  = msg_root.get_vlog_leaf(scope);
      full_name = msg_leaf.get_full_name();
      #1; // wait for print format to take effect
      `cn_info_hdl(("Using a msg_tag of '%s'", full_name));
   end

`endif

endmodule
