//-*-
 verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2011
// * (utg v0.3.1)
// ***********************************************************************
// * File        : base_test.sv
// * Author      : bhunter
// * Description : ALUTB Base-Test
// SRAND: weight:0
// ***********************************************************************

`ifndef __BASE_TEST_SV__
 `define __BASE_TEST_SV__

// class: base_test_c
// Base test for this testbench.
class base_test_c extends uvm_test;
   `uvm_component_utils_begin(base_test_c)
      `uvm_field_object(cfg, UVM_ALL_ON)
      `uvm_field_object(reg_block, UVM_ALL_ON)
   `uvm_component_utils_end

   //----------------------------------------------------------------------------------------
   // Group: Configuration Fields

   // var: cfg
   // environment configurations
   alutb_pkg::cfg_c cfg;

   // var: reg_block
   // ALUTB register block (reference to the one in cfg)
   alu_csr_pkg::reg_block_c reg_block;

   //----------------------------------------------------------------------------------------
   // Group: Fields

   // var: alutb_env
   // The alutb environment
   alutb_pkg::env_c alutb_env;

   // var: tb_clk_drv
   // The testbench clock driver
   cn_pkg::clk_drv_c tb_clk_drv;

   // var: tb_rst_drv
   // The testbench reset driver
   cn_pkg::rst_drv_c tb_rst_drv;

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="base_test",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   // func: build_phase
   // Builds out the whole environment.
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // Create the global environment
      uvm_config_db#(int)::set(this, "global_env.heartbeat_mon", "trace_mode", 1);
      global_pkg::env = global_pkg::env_c::type_id::create("global_env", this);

      // create the random configurations
      cfg = alutb_pkg::cfg_c::type_id::create("cfg");

      // create reg_block
      if(reg_block == null) begin
         reg_block = alu_csr_pkg::reg_block_c::type_id::create("reg_block", this);
         reg_block.configure(null, "alutb_tb_top.alu_wrapper.dut");
         reg_block.build();
         reg_block.lock_model();
      end

      // set configuration's reference to reg_block
      cfg.reg_block = reg_block;

      // randomize the cfg and CSR fields
      randomize_cfg();

      // push the register block and the configurations to all blocks that ask for it
      uvm_config_db#(uvm_object)::set(this, "*", "reg_block",    reg_block);
      uvm_config_db#(uvm_object)::set(this, "*", "cfg",          cfg);

      alutb_env = alutb_pkg::env_c::type_id::create("alutb_env", this);

      // Not randomized by default.  Derived tests can randomize in end_of_elaboration_phase.
      // Create the clock driver
      uvm_config_db#(string)::set(this, "tb_clk_drv", "intf_name", "tb_clk_vi");
      uvm_config_db#(int   )::set(this, "tb_clk_drv", "period_ps", 2000);
      tb_clk_drv = cn_pkg::clk_drv_c::type_id::create("tb_clk_drv", this);

      // Create the reset driver
      uvm_config_db#(string)::set(this, "tb_rst_drv", "intf_name",     "tb_rst_vi");
      uvm_config_db#(int   )::set(this, "tb_rst_drv", "reset_time_ps", 20000);
      tb_rst_drv = cn_pkg::rst_drv_c::type_id::create("tb_rst_drv", this);
   endfunction : build_phase

   ////////////////////////////////////////////
   // func: connect_phase
   // Set up the register block.
   //
   // See <reg_block>.
   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

      if(reg_block.get_parent() == null) begin
         ctx_pkg::reg_adapter_c ctx_adapter = ctx_pkg::reg_adapter_c::type_id::create("ctx_adapter", , get_full_name());

         reg_block.csr_map.set_sequencer(alutb_env.ctx_agent.sqr, ctx_adapter);
         reg_block.csr_map.set_auto_predict(1);
      end
   endfunction : connect_phase

   ////////////////////////////////////////////
   // func: randomize_cfg
   // Can be overridden by other tests to change how cfg is randomized.
   virtual   function void randomize_cfg();
      randomize(cfg);
   endfunction : randomize_cfg

   ////////////////////////////////////////////
   // func: configure_phase
   // Runs update on reg_block to generate CSR writes.
   virtual task configure_phase(uvm_phase phase);
      uvm_status_e status;
      uvm_reg_data_t data;

      phase.raise_objection(this);
      `cn_info(("Performing configuration."))
      reg_block.update(status);

      #(5ns);
      `cn_info(("Configuration finished with status %s", status))
      phase.drop_objection(this);
   endtask : configure_phase

endclass : base_test_c

`endif // __BASE_TEST_SV__
