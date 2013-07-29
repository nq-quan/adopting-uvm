
// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// ***********************************************************************
// File:   cn_msgs.sv
// Author: bhunter
/* About:  CN Messaging Macros to be used in UVM code
 *************************************************************************/

`ifndef __CN_MSGS_SV__
   `define __CN_MSGS_SV__

//----------------------------------------------------------------------------------------
// Group: Basic cn messaging macros

////////////////////////////////////////////
// macro: `cn_info(MSG)
// Print the MSG argument out at debug level 0
   `define cn_info(MSG)        \
      begin \
         string full_name = get_full_name(); \
         if(uvm_report_enabled(UVM_NONE,UVM_INFO,full_name)) begin \
            uvm_report_object report_object; \
            if ($cast(report_object, this)) begin \
               uvm_report_info(full_name, $sformatf MSG, 0, `uvm_file, `uvm_line); \
            end else begin \
               uvm_report_handler report_handler = uvm_top.get_report_handler(); \
               report_handler.report(UVM_INFO, full_name, full_name, $sformatf MSG, 0, `uvm_file, `uvm_line, uvm_top); \
            end \
         end \
      end

////////////////////////////////////////////
// macro: `cn_dbg(LVL, MSG)
// Print the message MSG out at level LVL.
   `define cn_dbg(LVL, MSG)    \
      begin \
         string full_name = get_full_name(); \
         if(uvm_report_enabled(LVL,UVM_INFO,full_name)) begin \
            uvm_report_object report_object; \
            if ($cast(report_object, this)) begin \
               uvm_report_info(full_name, $sformatf MSG, LVL, `uvm_file, `uvm_line); \
            end else begin \
               uvm_report_handler report_handler = uvm_top.get_report_handler(); \
               report_handler.report(UVM_INFO, full_name, full_name, $sformatf MSG, LVL, `uvm_file, `uvm_line, uvm_top); \
            end \
         end \
      end

////////////////////////////////////////////
// macro: cn_err(MSG)
// Print out the MSG as an error.
   `define cn_err(MSG)         \
      begin \
         string full_name = get_full_name(); \
         if(uvm_report_enabled(UVM_NONE,UVM_ERROR,full_name)) begin \
            uvm_report_object report_object; \
            if ($cast(report_object, this)) begin \
               uvm_report_error(full_name, $sformatf MSG, UVM_NONE, `uvm_file, `uvm_line); \
            end else begin \
               uvm_report_handler report_handler = uvm_top.get_report_handler(); \
               report_handler.report(UVM_ERROR, full_name, full_name, $sformatf MSG, UVM_NONE, `uvm_file, `uvm_line, uvm_top); \
            end \
         end \
      end

////////////////////////////////////////////
// macro: cn_fatal(MSG)
// Print the MSG out as a fatal error and immediately end simulation.
   `define cn_fatal(MSG)       \
      begin \
         string full_name = get_full_name(); \
         if(uvm_report_enabled(UVM_NONE,UVM_FATAL,full_name)) begin \
            uvm_report_object report_object; \
            if ($cast(report_object, this)) begin \
               uvm_report_fatal(full_name, $sformatf MSG, UVM_NONE, `uvm_file, `uvm_line); \
            end else begin \
               uvm_report_handler report_handler = uvm_top.get_report_handler(); \
               report_handler.report(UVM_FATAL, full_name, full_name, $sformatf MSG, UVM_NONE, `uvm_file, `uvm_line, uvm_top); \
            end \
         end \
      end

////////////////////////////////////////////
// macro: cn_warn(MSG)
// Print the MSG out as a warning
   `define cn_warn(MSG)        \
      begin \
         string full_name = get_full_name(); \
         if(uvm_report_enabled(UVM_NONE,UVM_WARNING,full_name)) begin \
            uvm_report_object report_object; \
            if ($cast(report_object, this)) begin \
               uvm_report_warning(full_name, $sformatf MSG, UVM_NONE, `uvm_file, `uvm_line); \
            end else begin \
               uvm_report_handler report_handler = uvm_top.get_report_handler(); \
               report_handler.report(UVM_WARNING, full_name, full_name, $sformatf MSG, UVM_NONE, `uvm_file, `uvm_line, uvm_top); \
            end \
         end \
      end

////////////////////////////////////////////
// macro: cn_print(LVL, MSG)
// Print the MSG out at level LVL, but bypass the report server
   `define cn_print(LVL, MSG) \
      begin \
         string full_name = get_full_name(); \
         if(uvm_report_enabled(LVL,UVM_INFO,full_name)) \
            $display($sformatf MSG); \
      end

////////////////////////////////////////////
// macro: cn_assert(p)
// Assert that p is true, otherwise report an error that p is not true.
   `define cn_assert(p) if((p)) begin \
      end \
      else begin \
         string full_name = get_full_name(); \
         if(uvm_report_enabled(UVM_NONE,UVM_FATAL,full_name)) \
            uvm_report_fatal(full_name, $sformatf("cn_assert_failure:: %s", `"p`"), UVM_NONE, `uvm_file, `uvm_line); \
      end

//----------------------------------------------------------------------------------------
// Group: Messaging Macros for Static Functions
// Static functions cannot call get_full_name.  These defs are provided specifically for those cases.

////////////////////////////////////////////
// macro: `cn_info_static(MSG)
// Same as <`cn_info(MSG)>, but for static functions
   `define cn_info_static(MSG)        \
      begin \
         string full_name = {type_name, "::<static>"}; \
         if(uvm_top.uvm_report_enabled(UVM_NONE,UVM_INFO,full_name)) begin \
            uvm_report_handler report_handler = uvm_top.get_report_handler(); \
            report_handler.report(UVM_INFO, full_name, full_name, $sformatf MSG, 0, `uvm_file, `uvm_line, uvm_top); \
         end \
      end

////////////////////////////////////////////
// macro: `cn_dbg_static(LVL, MSG)
// Same as <`cn_dbg(LVL, MSG)>, but for static functions
   `define cn_dbg_static(LVL, MSG)    \
      begin \
         string full_name = {type_name, "::<static>"}; \
         if(uvm_top.uvm_report_enabled(UVM_NONE,UVM_INFO,full_name)) begin \
            uvm_report_handler report_handler = uvm_top.get_report_handler(); \
            report_handler.report(UVM_INFO, full_name, full_name, $sformatf MSG, LVL, `uvm_file, `uvm_line, uvm_top); \
         end \
      end

////////////////////////////////////////////
// macro: `cn_err_static(MSG)
// Same as <`cn_err(MSG)>, but for static functions
   `define cn_err_static(MSG)         \
      begin \
         string full_name = {type_name, "::<static>"}; \
         if(uvm_top.uvm_report_enabled(UVM_NONE,UVM_ERROR,full_name)) begin \
            uvm_report_handler report_handler = uvm_top.get_report_handler(); \
            report_handler.report(UVM_ERROR, full_name, full_name, $sformatf MSG, UVM_NONE, `uvm_file, `uvm_line, uvm_top); \
         end \
      end

////////////////////////////////////////////
// macro: `cn_fatal_static(MSG)
// Same as <`cn_fatal(MSG)>, but for static functions
   `define cn_fatal_static(MSG)       \
      begin \
         string full_name = {type_name, "::<static>"}; \
         if(uvm_top.uvm_report_enabled(UVM_NONE,UVM_FATAL,full_name)) begin \
            uvm_report_handler report_handler = uvm_top.get_report_handler(); \
            report_handler.report(UVM_FATAL, full_name, full_name, $sformatf MSG, UVM_NONE, `uvm_file, `uvm_line, uvm_top); \
         end \
      end

////////////////////////////////////////////
// macro: `cn_warn_static(MSG)
// Same as <`cn_warn(MSG)>, but for static functions
   `define cn_warn_static(MSG)        \
      begin \
         string full_name = {type_name, "::<static>"}; \
         if(uvm_top.uvm_report_enabled(UVM_NONE,UVM_WARNING,full_name)) begin \
            uvm_report_handler report_handler = uvm_top.get_report_handler(); \
            report_handler.report(UVM_WARNING, full_name, full_name, $sformatf MSG, UVM_NONE, `uvm_file, `uvm_line, uvm_top); \
         end \
      end

////////////////////////////////////////////
// macro: cn_print_static(LVL, MSG)
// Print the MSG out at level LVL, but bypass the report server
   `define cn_print_static(LVL, MSG) \
      begin \
         string full_name = {type_name, "::<static>"}; \
         if(uvm_report_enabled(LVL,UVM_INFO,full_name)) \
            $display($sformatf MSG); \
      end

////////////////////////////////////////////
// macro: `cn_assert_static(p)
// Same as <`cn_assert(p)>, but for static functions
   `define cn_assert_static(p) if((p)) begin \
      end \
      else begin \
         string full_name = {type_name, "::<static>"}; \
         if(uvm_report_enabled(UVM_NONE,UVM_FATAL,full_name)) begin \
            uvm_report_handler report_handler = uvm_top.get_report_handler(); \
            report_handler.report(UVM_FATAL, full_name, full_name, $sformatf("cn_assert_failure:: %s", `"p`"), UVM_NONE, `uvm_file, `uvm_line, uvm_top); \
         end \
      end

//----------------------------------------------------------------------------------------
// Group: Messaging Macros for Basic Non-UVM Classes
// Non-UVM classes have no name, so they cannot call get_full_name.  These defs are provided
// specifically for those cases.  While there is practically no reason to ever have a base
// class, some vendor IP may do this.

////////////////////////////////////////////
// macro: `cn_info_base(MSG)
// Same as <`cn_info(MSG)>, but for base functions
   `define cn_info_base(MSG)        \
      begin \
         uvm_report_handler report_handler = uvm_top.get_report_handler(); \
         report_handler.report(UVM_INFO, "unnamed_class", "unnamed_class", $sformatf MSG, 0, `uvm_file, `uvm_line, uvm_top); \
      end

////////////////////////////////////////////
// macro: `cn_dbg_base(LVL, MSG)
// Same as <`cn_dbg(LVL, MSG)>, but for base functions
   `define cn_dbg_base(LVL, MSG)    \
      begin \
         uvm_report_handler report_handler = uvm_top.get_report_handler(); \
         report_handler.report(UVM_INFO, "unnamed_class", "unnamed_class", $sformatf MSG, LVL, `uvm_file, `uvm_line, uvm_top); \
      end

////////////////////////////////////////////
// macro: `cn_err_base(MSG)
// Same as <`cn_err(MSG)>, but for base functions
   `define cn_err_base(MSG)         \
      begin \
         uvm_report_handler report_handler = uvm_top.get_report_handler(); \
         report_handler.report(UVM_ERROR, "unnamed_class", "unnamed_class", $sformatf MSG, UVM_NONE, `uvm_file, `uvm_line, uvm_top); \
      end

////////////////////////////////////////////
// macro: `cn_fatal_base(MSG)
// Same as <`cn_fatal(MSG)>, but for base functions
   `define cn_fatal_base(MSG)       \
      begin \
         uvm_report_handler report_handler = uvm_top.get_report_handler(); \
         report_handler.report(UVM_FATAL, "unnamed_class", "unnamed_class", $sformatf MSG, UVM_NONE, `uvm_file, `uvm_line, uvm_top); \
      end

////////////////////////////////////////////
// macro: `cn_warn_base(MSG)
// Same as <`cn_warn(MSG)>, but for base functions
   `define cn_warn_base(MSG)        \
      begin \
         uvm_report_handler report_handler = uvm_top.get_report_handler(); \
         report_handler.report(UVM_WARNING, "unnamed_class", "unnamed_class", $sformatf MSG, UVM_NONE, `uvm_file, `uvm_line, uvm_top); \
      end

////////////////////////////////////////////
// macro: cn_print_static(LVL, MSG)
// Print the MSG out at level LVL, but bypass the report server
   `define cn_print_base(LVL, MSG) \
            $display($sformatf MSG);

////////////////////////////////////////////
// macro: `cn_assert_base(p)
// Same as <`cn_assert(p)>, but for base functions
   `define cn_assert_base(p) if((p)) begin \
      end \
      else begin \
            uvm_report_fatal("unnamed_class", $sformatf("cn_assert_failure:: %s", `"p`"), UVM_NONE, `uvm_file, `uvm_line); \
      end

//----------------------------------------------------------------------------------------
// Group: Messaging Macros for Interfaces
// All interfaces should use these macros instead
// The error macros do NOT use UVM_NONE because interfaces may be compiled before UVM is compiled

////////////////////////////////////////////
// macro: `cn_info_intf(MSG)
// Same as <`cn_info(MSG)>, but for interfaces
   `define cn_info_intf(MSG)        \
      begin \
         uvm_report_handler report_handler = uvm_top.get_report_handler(); \
         report_handler.report(UVM_INFO, $sformatf("%m"), $sformatf("%m"), $sformatf MSG, 0, `uvm_file, `uvm_line, uvm_top); \
      end

////////////////////////////////////////////
// macro: `cn_dbg_intf(LVL, MSG)
// Same as <`cn_dbg(LVL, MSG)>, but for interfaces
   `define cn_dbg_intf(LVL, MSG)    \
      begin \
         uvm_report_handler report_handler = uvm_top.get_report_handler(); \
         report_handler.report(UVM_INFO, $sformatf("%m"), $sformatf("%m"), $sformatf MSG, LVL, `uvm_file, `uvm_line, uvm_top); \
      end

////////////////////////////////////////////
// macro: `cn_err_intf(MSG)
// Same as <`cn_err(MSG)>, but for interfaces
   `define cn_err_intf(MSG)         \
      begin \
         uvm_report_handler report_handler = uvm_top.get_report_handler(); \
         report_handler.report(UVM_ERROR, $sformatf("%m"), $sformatf("%m"), $sformatf MSG, 0, `uvm_file, `uvm_line, uvm_top); \
      end

////////////////////////////////////////////
// macro: `cn_fatal_intf(MSG)
// Same as <`cn_fatal(MSG)>, but for interfaces
   `define cn_fatal_intf(MSG)       \
      begin \
         uvm_report_handler report_handler = uvm_top.get_report_handler(); \
         report_handler.report(UVM_FATAL, $sformatf("%m"), $sformatf("%m"), $sformatf MSG, 0, `uvm_file, `uvm_line, uvm_top); \
      end

////////////////////////////////////////////
// macro: `cn_warn_intf(MSG)
// Same as <`cn_warn(MSG)>, but for interfaces
   `define cn_warn_intf(MSG)        \
      begin \
         uvm_report_handler report_handler = uvm_top.get_report_handler(); \
         report_handler.report(UVM_WARNING, $sformatf("%m"), $sformatf("%m"), $sformatf MSG, 0, `uvm_file, `uvm_line, uvm_top); \
      end

////////////////////////////////////////////
// macro: `cn_print_intf(MSG)
// Same as <`cn_print(MSG)>, but for interfaces
   `define cn_print_intf(MSG)        \
            $display($sformatf MSG);

////////////////////////////////////////////
// macro: `cn_assert_intf(p)
// Same as <`cn_assert(p)>, but for interfaces
   `define cn_assert_intf(p) if((p)) begin \
   end \
   else begin \
       uvm_report_handler report_handler = uvm_top.get_report_handler(); \
       report_handler.report(UVM_FATAL, $sformatf("%m"), $sformatf("%m"), $sformatf("cn_assert_failure:: %s", `"p`"), 0, `uvm_file, `uvm_line, uvm_top); \
   end

//----------------------------------------------------------------------------------------
// Group: Stack Traces
// Each vendor implements a stack trace slightly differently.
// Use these macros instead

////////////////////////////////////////////
// macro: `cn_stack()
// Prints a stack trace

`ifdef VCS
   `define cn_stack(x) $stack;
`endif
`ifdef NCV
   `define cn_stack(x) $stacktrace;
`endif

`endif //  __CN_MSGS_SV__
