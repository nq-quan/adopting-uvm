<?selftest>
//****************************************************************************************
//* SELF-TEST
//****************************************************************************************
`ifdef __SELF_TEST__
class self_test_c extends uvm_test;
   `uvm_component_utils(self_test_c)

   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="self_test",
                uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   // func: run_phase
   virtual task run_phase(uvm_phase phase);
      // (do stuff!)
   endtask : run_phase

endclass : self_test_c
`endif // __SELF_TEST__
<?end>
`endif // __<FILENAME>_SV__
