<@header>
<@ifndef>
   
// (`includes go here)

// class: base_test_c
// (Describe me)
class base_test_c extends uvm_test;
   `uvm_component_utils_begin(base_test_c)
      `uvm_field_object(cfg, UVM_ALL_ON)
      `uvm_field_object(reg_block, UVM_ALL_ON)
   `uvm_component_utils_end

<@section_border>
   // Group: Configuration Fields

<@section_border>
   // Group: Fields

   // var: cfg
   // The configuration class
   <name>_pkg::cfg_c cfg;

   // var: reg_block
   // The register block (reference to the one in cfg)
   <name>_csr_pkg::<name>_ncb_reg_block_c reg_block;

   // var: env
   // The <name> environment
   <name>_pkg::env_c env;
   
   // var: tb_clk_drv
   // The testbench clock driver
   cn_pkg::clk_drv_c tb_clk_drv;

   // var: tb_rst_drv
   // The testbench reset driver
   cn_pkg::rst_drv_c tb_rst_drv;

<@section_border>
   // Group: Methods
  
<@phases>
<$build_phase>
      // Create the global environment        
      global_pkg::env = global_pkg::env_c::type_id::create("global_env", this);

      // create the random configurations
      cfg = <name>_pkg::cfg_c::type_id::create("cfg");
   
      // create reg_block
      if(reg_block == null) begin
         reg_block = <name>_csr_pkg::<name>_ncb_reg_block_c::type_id::create("reg_block", this);
         reg_block.build();
         reg_block.lock_model();
      end

      // randomize configs & CSRs
      cfg.reg_block = reg_block;

      // randomize the cfg and CSR fields
      randomize_cfg();
      
      uvm_config_db#(uvm_object)::set(this, "*", "reg_block", reg_block);
      uvm_config_db#(uvm_object)::set(this, "*", "cfg",       cfg      );

      env = <name>_pkg::env_c::type_id::create("env", this);

      // Not randomized by default.  Derived tests can randomize in end_of_elaboration_phase.
      // Create the clock driver
      uvm_config_db#(string)::set(this, "tb_clk_drv", "intf_name", "tb_clk_vi");
      uvm_config_db#(int)::set(this, "tb_clk_drv", "period_ps", 2000);
      tb_clk_drv = cn_pkg::clk_drv_c::type_id::create("tb_clk_drv", this);

      // Create the reset driver
      uvm_config_db#(string)::set(this,"tb_rst_drv", "intf_name",     "tb_rst_vi");
      uvm_config_db#(int)::set(this, "tb_rst_drv", "reset_time_ps", 20000);
      tb_rst_drv = cn_pkg::rst_drv_c::type_id::create("tb_rst_drv", this);
<$end>

<@method_border>
   virtual task configure_phase(uvm_phase phase);
      uvm_status_e status;

      phase.raise_objection(this);
      
      reg_block.update(status);
      // (alternatively, start a configuration sequence)

      // ensure that all transactions complete
      #(100ns);
      
      phase.drop_objection(this);
   endtask : configure_phase

<@method_border>
   virtual function void randomize_cfg();
      randomize(cfg);
   endfunction : randomize_cfg
   
endclass : base_test_c
   
<@endif>
   