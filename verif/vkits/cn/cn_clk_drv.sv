
// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.3.3)
// ***********************************************************************
// File:   cn_clk_drv.sv
// Author: bhunter
/* About:  Clock Generation Driver

1. In blk_top_tb.v, instantiate the interface, and connect it to the
   clock.  Also, set it in the database.
    wire sclk;
    cn_clk_intf sclk_i();
    assign sclk = sclk_i.clk;
    initial begin
       uvm_resource_db#(virtual cn_clk_intf)::set("cn_pkg::clk_intf", "sclk_i", sclk_i);

2. In base_test.sv, instantiate the clock generator driver.
cn_pkg::clk_drv_c sclk_drv;

3. In build_phase(), create it like any other uvm_driver.  Confgure the string
intf_name the same name that you set in parameter 3 of the ::set call above:
uvm_config_db#(string)::set(this, "sclk_i", "intf_name", "sclk_i");
sclk_drv = cn_pkg::clk_drv_c::type_id::create("sclk_i", this);

4. Clock parameters can be set before the create call:
uvm_config_db#(int)::set(this, "sclk_i", "period_ps", 2000);
uvm_config_db#(int)::set(this, "sclk_i", "init_x",    0);

5. Or, clock parameters can be randomized after the create call:
sclk_drv.randomize() with {
  period_ps inside {[1492:2000]};
  init_x == 0;
}

6. Knobs:
  period_ps     : Clock period in ps
  init_x        : When set, clock is initially x
  init_value    : When init_x is clear, clock initializes to this value
  init_delay_ps : Period of time, in ps, before this clock starts running.
  jitter_enable : Turns on clock variability.  May greatly increase sim times.
  drift_type    : With jitter, causes clock to drift from ideal
  enable        : Defaults to 1, setting to 0 will disable clock generation (init_value or init_x will still be obeyed, but no toggling will occur)

7. Functional Coverage Knobs
  coverage_enable  : When set, turns on functional coverage generation.

 *************************************************************************/

`ifndef __CN_CLK_DRV_SV__
   `define __CN_CLK_DRV_SV__

// class: clk_drv_c
// A clock driver class.
class clk_drv_c extends uvm_driver;
   //----------------------------------------------------------------------------------------
   // Group: Types

   // enum: drift_type_e
   // Drift will bias the jitter in one direction or another
   typedef enum { NEGATIVE,
                  NEUTRAL,
                  POSITIVE } drift_type_e;

   typedef enum { CN_1PS,
                  CN_100FS,
                  CN_10FS,
                  CN_1FS } clk_precision_e;

   `uvm_component_utils_begin(cn_pkg::clk_drv_c)
      `uvm_field_string(intf_name,     UVM_ALL_ON)
      `uvm_field_int(init_delay_ps,    UVM_ALL_ON | UVM_DEC)
      `uvm_field_int(init_value,       UVM_ALL_ON | UVM_DEC)
      `uvm_field_int(period_ps,        UVM_ALL_ON | UVM_DEC)
      `uvm_field_int(divisor,          UVM_ALL_ON | UVM_DEC)
      `uvm_field_int(init_x,           UVM_ALL_ON | UVM_DEC)
      `uvm_field_int(jitter_enable,    UVM_ALL_ON)
      `uvm_field_int(coverage_enable,  UVM_ALL_ON)
      `uvm_field_enum(clk_precision_e, precision, UVM_ALL_ON)
      `uvm_field_int(enable,           UVM_ALL_ON | UVM_DEC)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   // var: intf_name
   // Name in the resource database under which the vintf is stored. The scope
   // under which it is stored is "cn_pkg::clk_intf".
   string intf_name = "clk_intf";

   // var: period_ps
   // Period in ps
   rand int period_ps;

   // var: divisor
   // Divide period by this
   rand int divisor = 1;

   // var: init_delay_ps
   // Initial delay in ps
   rand int init_delay_ps;

   // var: init_value
   // The starting value of the clock signal
   rand bit init_value;

   // var: init_x
   // When true, the initial value will be X
   rand bit init_x;

   // var: coverage_enable
   // Turns on coverage collection
   int coverage_enable = 0;

   // var: clk_precision
   clk_precision_e precision = CN_1PS;

   // var: enable
   // Used to determine if the clock driver actually drives clocks (or instead only drives a static initial value)
   bit     enable = 1;

   constraint sane_cnstr {
      init_delay_ps inside {[0:100000]};
      period_ps inside {[1000:3000]};
      jitter_enable == 0;
   }
   constraint divisor_cnstr {
      divisor == 1;
   }

   //----------------------------------------------------------------------------------------
   // Group: Fields

   // interface to clock
   virtual cn_clk_intf clk_vi;

   // var: jitter_enable
   // Jitter/drift-related
   rand bit jitter_enable;

   // var: jitter_ps
   // Randomized on every clock when jitter is enabled
   rand int jitter_ps;

   // var: drift_type
   // What type of drift this clock driver will exhibit
   rand drift_type_e drift_type;

   // constraints on jitter_ps
   //  where do these numbers come from?  The answer is that they're arbitrary, but
   //  they should get the job done
   constraint jitter_cnstr {
      // neutral drift
      if(drift_type == NEUTRAL)
         jitter_ps dist {
            -7        := 1,
            [-6:-4]   :/ 1,
            [-3:-1]   :/ 2,
            0         := 92,
            [1:3]     :/ 2,
            [4:6]     :/ 1,
            7         := 1
         };

      // positive drift
      if(drift_type == POSITIVE)
         jitter_ps dist {
            -3        := 1,
            [-2:-1]   :/ 2,
            0         := 92,
            [1:3]     :/ 3,
            [4:6]     :/ 2
         };

      // negative drift
      if(drift_type == NEGATIVE)
         jitter_ps dist {
            [-6:-4]   :/ 2,
            [-3:-1]   :/ 3,
            0         := 92,
            [1:2]     :/ 2,
            3         := 1
         };
   }

   //----------------------------------------------------------------------------------------
   // Group: Methods

   ////////////////////////////////////////////
   function new(string name="clk_drv",
                uvm_component parent=null);
      super.new(name, parent);
      //set coverage_enable
      if (!uvm_resource_db#(int)::read_by_name("uvm_root", "coverage_enable", coverage_enable, this))
         `cn_warn(("read_by_name was null for uvm_root, coverage_enable"))

      if (coverage_enable) begin
         cg = new();
         cg.set_inst_name(get_full_name());
         `cn_info(("%s will collect coverage during this run.", get_full_name() ))
      end
   endfunction : new

   ////////////////////////////////////////////
   // func: build_phase
   // Hook up to the virtual interface
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // get the interface
      `cn_get_intf(virtual cn_clk_intf, "cn_pkg::clk_intf", intf_name, clk_vi)

      // Put into the clk_drv registry.
      uvm_config_db #(clk_drv_c)::set(null, get_full_name(), "this", this);

   endfunction : build_phase

   ////////////////////////////////////////////
   // func: run_phase
   // Produce the clock
   virtual task run_phase(uvm_phase phase);
      int  half_period_divisor;
      int  short_half_period;
      int  long_half_period;
      int  num_long_half_periods;
      int  full_period;
      int  period_mult;
      real  precision_mult;
      string report;

      // Do some sanity checking of config items.  Only if we're enabled though (don't burden users with configuration if the driver isn't even going to drive a clock...)
      if (enable == 1) begin
         if(init_delay_ps < 0)
           `cn_fatal(("Clock init_delay_ps is less than zero!"))
         if(period_ps == 0)
           `cn_fatal(("Clock generator period is zero."))
      end

      // report
      report = $sformatf("Starting %s: period_ps=%0dps divisor=%0d init_value=%0d init_delay_ps=%0d init_x=%0d precision=%s", get_name(), period_ps, divisor, init_value, init_delay_ps, init_x, precision);
      if(jitter_enable)
        report = {report," JITTER! drift=", drift_type.name()};
      `cn_info((report))

      if(init_x == 1)
         clk_vi.clk = 'bx;
      else begin
         clk_vi.clk = init_value;
         clk_vi.clk_ideal = init_value;
      end

      if (enable == 0) begin
         // We've already driven the initial value, just return.
         return;
      end

      case(precision)
        CN_1PS: begin
           precision_mult = 1ps;
           period_mult = 1;
        end
        CN_100FS: begin
           precision_mult = 100fs;
           period_mult = 10;
        end
        CN_10FS: begin
           precision_mult = 10fs;
           period_mult = 100;
        end
        CN_1FS: begin
           precision_mult = 1fs;
           period_mult = 1000;
        end
        default: `cn_fatal(("No support for clock prevision=%s.",precision))
      endcase

      `cn_assert(precision_mult > 0)

      #(init_delay_ps*1ps);

      clk_vi.clk = ~init_value;
      clk_vi.clk_ideal = ~init_value;

      full_period = period_ps*period_mult;
      half_period_divisor = divisor * 2;
      short_half_period = full_period / half_period_divisor;
      long_half_period = short_half_period + 1;
      num_long_half_periods = full_period % half_period_divisor;

      if(!jitter_enable) begin
         forever begin
            for (int p = 0; p < num_long_half_periods; p++) begin
               #(long_half_period*precision_mult) clk_vi.clk = ~clk_vi.clk;
            end
            for (int p = num_long_half_periods; p < half_period_divisor; p++) begin
               #(short_half_period*precision_mult) clk_vi.clk = ~clk_vi.clk;
            end
         end
      end
      else begin
         fork
            // generate the jittery clock
            forever begin
               for (int p = 0; p < num_long_half_periods; p++) begin
                  randomize(jitter_ps);
                  #((long_half_period+(jitter_ps*period_mult)) * precision_mult) clk_vi.clk = ~clk_vi.clk;
               end
               for (int p = num_long_half_periods; p < half_period_divisor; p++) begin
                  randomize(jitter_ps);
                  #((short_half_period+(jitter_ps*period_mult)) * precision_mult) clk_vi.clk = ~clk_vi.clk;
               end
            end
            // generate the ideal clock
            forever begin
               for (int p = 0; p < num_long_half_periods; p++) begin
                  #(long_half_period * precision_mult) clk_vi.clk_ideal = ~clk_vi.clk_ideal;
               end
               for (int p = num_long_half_periods; p < half_period_divisor; p++) begin
                  #(short_half_period * precision_mult) clk_vi.clk_ideal = ~clk_vi.clk_ideal;
               end
            end
         join
      end
   endtask : run_phase

   ////////////////////////////////////////////
   // func: extract_phase
   // Sample the coverage if coverage is enabled
   virtual function void extract_phase(uvm_phase phase);
      super.extract_phase(phase);

      if(coverage_enable) cg.sample();
   endfunction : extract_phase

   ////////////////////////////////////////////
   // func: wait_n_clocks
   // Can be called to wait this number of clocks
   virtual task wait_n_clocks(int n);
      for (int i = 0; i < n; i++) begin
         @(posedge clk_vi.clk);
      end
   endtask

   //----------------------------------------------------------------------------------------
   // Group: Functional Coverage
   covergroup cg;
      option.per_instance = 1;

      coverpoint init_delay_ps {
         option.comment="The amount of time before the first transition.";
         option.weight=1;

         bins zero        = {0};
         bins others[]    = default;
      }
      coverpoint init_value {
         option.comment="The initial value, either 1 or 0.";
         option.weight=1;
      }
      coverpoint period_ps {
         option.comment="The clock period, ranging from 300MHz..1.8GHz.";
         option.weight=100;

         bins quickest    = {[  500:555  ]};  // 2GHz-1.8GHz
         bins quick       = {[  556:715  ]};  // 1.4GHz-1.8GHz
         bins quicker     = {[  714:999  ]};  // 1GHz-1.4GHz
         bins typical     = {     1000    };  // 1GHz
         bins slower      = {[ 1001:1251 ]};  // 800-1GHz
         bins slow        = {[ 1252:3334 ]};  // 300-800
         bins slowest     = {     3333    };  // 300MHz min
         bins others[]    = default;
      }
      coverpoint init_x {
         option.comment="When set, the clock started with an X value.";
         option.weight=1;
      }

      coverpoint jitter_enable {
         option.comment="Makes clock jitter and/or drift.";
         option.weight=1;
      }
      coverpoint jitter_ps iff(jitter_enable) {
         option.comment="Randomized on every clock when jitter is enabled.";
         option.weight=1;
      }
      coverpoint drift_type iff(jitter_enable) {
         option.comment="Either neutral, positive, or negative.  Clock will drift over time.";
         option.weight=10;
      }
   endgroup : cg

endclass : clk_drv_c

//----------------------------------------------------------------------------------------
// Package: Package level functions

// Function: get_clk_drv
// Gets a <clk_drv_c> from the clock driver registry.
//
// Arguments:
//   cntxt - The uvm_hierachy used as the starting search point in the registry.
//   clk_name - The explicit instance name of the clock driver.
//
// Returns:
//   The <clk_drv_c> object, or null if it isn't found.
function clk_drv_c get_clk_drv(uvm_component cntxt, string clk_name);
   clk_drv_c clk_drv;
   if (uvm_config_db #(clk_drv_c)::get(cntxt, clk_name, "this", clk_drv)) begin
      return clk_drv;
   end
   else begin
      return null;
   end
endfunction

// class: clk_passive_drv_c
// Class that holds data about a clock that is not directly generated by the
// testbench.
class clk_passive_drv_c extends clk_drv_c;
   `uvm_component_utils(cn_pkg::clk_passive_drv_c)

   //----------------------------------------------------------------------------------------
   // Methods

   ////////////////////////////////////////////
   function new(string name="clk_passive_drv",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction : build_phase

   ////////////////////////////////////////////
   virtual function void end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
   endfunction : end_of_elaboration_phase

   ////////////////////////////////////////////
   virtual task run_phase(uvm_phase phase);
   endtask : run_phase

   ////////////////////////////////////////////
   virtual task wait_n_clocks(int n);
      `cn_fatal(("Passive clock generators can't yet support wait_n_clocks"))
   endtask

endclass : clk_passive_drv_c


`endif // __CN_CLK_DRV_SV__

