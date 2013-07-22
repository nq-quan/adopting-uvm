//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-

// **********************************************************************
// *
// * legal mumbo jumbo
// *
// * (c) 2012, Caviu
// * (utg v0.8)
// ***********************************************************************
// File:   cn_bag.sv
// Author: jstadolnik
/* About:  UVM version of cnBagT.  Used for generated weighted random numbers in a bag type container.
 *************************************************************************/

`ifndef __CN_BAG_SV__
`define __CN_BAG_SV__

//Use to run a stand-alone test on the cn_bag_c class.
//`define RUN_CN_BAG_TEST
`ifdef RUN_CN_BAG_TEST
import uvm_pkg::*;
 `define cn_err(x) `uvm_error("cn_bag_c",$sformatf x)
 `define cn_assert(x) if(!(x)) `uvm_fatal("cn_bag_c",$sformatf(x))
`endif

// Note: There are 2 classes in the file: cn_bag_c and cn_mailbag_c.
//
// class: cn_bag_c
// This a random value container object.
// * Items are put into the bag with the push() and push_range() functions.
// * The peek() function will return a random entry from the bag, but keeps the entry in the bag.
// * The pop(output _value) function will return a random entry from the bag (from the _value output) and
// removes it.  The function will return 0 if the bag was empty, and 1 otherwise.
// * Use the empty() function to determine if the bag has entries available.
// * If randomize() is called on the cn_bag_c object, it will behave like the peek() function (no entries
// are removed).  The result member variable will contains the last randomized value.
// * The set_check_pushes() call controls the check_pushes flag.  When the check_pushes flag is set, all push()
// calls must use a value previously removed with the pop() call.  set_check_pushes() should only be called
// after the bag is initialized with values.
// * The set_recycle_on_empty() call controls the recycle_on_empty flat.  When the recycle_on_empty flag is
// set, and the last value has been popped, all values put into the bag before set_check_pushes(1) will
// get added back to the bag.
//
// class: cn_mailbag_c
// Same a cn_bag_c above except that that pop(output _value) is a task call that will block (wait time) if
// if the mailbag is empty.

// ----------
// Example:
//
// cn_bag_c #(bit[47:0]) bag;
// bag = new("my_bag");
// bag.push_range(1,3); //adds a range of numbers (1 through 3) to the bag.
// bag.push(4,2); //adds 2 copies the number 4 to the bag.
// bag.check_pushes(1); //all future values into the bag must have first been popped out

class cn_bag_c #(type dataT=int) extends uvm_object;

   //----------------------------------------------------------------------------------------
   // Group: Constants
   const int MAX_BAG_ENTRIES = 100000; //maximum number of entries to allow in a bag
   const int MAX_PRINT_ENTRIES = 64; //maximum number of entries to print in convert2string() call.
   
   //----------------------------------------------------------------------------------------
   // Group: Fields
   rand dataT result; //Contains result of last peek(), pop(), or randomize() call. 
   rand int unsigned index; //Index of last randomized item in bag.  Updates on peek(), pop(), or randomize() call.
   dataT active_list[$]; //List of items in bag
   int marked_list[dataT]; //List of marked items. When check_pushes flag is set and all popped values will get added to the marked_list.  push() calls will remove
   //entries from the marked list when the check_flag is set.
   bit recycle_on_empty; //When set to 1 and pop() call emptis the bag, the marked list will be dumped into the bag.
   bit check_pushes; //after a bag has been populated with values, this flag can be set to check that any new values pushed in were ones that were popped first.
   
   `uvm_object_param_utils_begin(cn_bag_c #(dataT))
      `uvm_field_int(result, UVM_ALL_ON)
      `uvm_field_int(index, UVM_ALL_ON)      
   `uvm_object_utils_end
   
   //----------------------------------------------------------------------------------------
   // Group: Constraints
   //Master contraint for cn_bag_c class.
   constraint selection_constraint {
      solve index before result;
      index < active_list.size();
      extract_from_array(index) == result; //need to wrap array element extraction in a function to prevent solver from complaining
   };

   function int extract_from_array(int _index);
      return this.active_list[_index];
   endfunction
   
   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="cn_bag");
      super.new(name);
   endfunction : new

   //Removes all elements from the bag
   function void clear();
      this.active_list = {};
      this.marked_list.delete;
   endfunction

   //Add a value to the bag.  Can specify a count.
   function void push(dataT _num, int _count=1);
      `cn_assert((this.active_list.size()+_count)<this.MAX_BAG_ENTRIES)
      for(int i=0;i<_count;i++) begin
         this.active_list.push_back(_num);

         if(this.check_pushes) begin
            if(this.marked_list.exists(_num)) begin
               //locate entry in marked list
               if(this.marked_list[_num]==1)
                 this.marked_list.delete(_num); //remove entry from marked list if there are no more available
               else
                 this.marked_list[_num] -= 1;
            end
            //Flag error if pushing an entry which wasn't already in the marked list
            else
              `cn_err(("Pushed an entry into a cn_bag that was not in the marked list. Bag name=%0m:%0s, value pushed=%0d",this.get_full_name(),_num));
         end
         
      end

   endfunction

   //Add a range of values to the bag.  Can specify a count.
   virtual function int push_range(dataT _start, dataT _end, int _count=1);
      int    num_entries;
      num_entries = (_end-_start+1)*_count;
      `cn_assert((this.active_list.size()+num_entries)<this.MAX_BAG_ENTRIES)     
      for(int j=_start;j<=_end;j++) this.push(j,_count);
      return num_entries;
   endfunction

   //Returns true if bag is empty.
   function int empty();
      return (this.active_list.size()==0);
   endfunction

   //Returns number of entries in the bag.
   function int size();
      return this.active_list.size();
   endfunction

   //Set recycle on empty flag. When set, if a pop() empties the bag, all entries in the marked list will get dumped into the bag.
   function void set_recycle_on_empty(int _enable);
      `cn_assert(this.marked_list.size()==0) //The cycle_on_empty feature can only be enabled when the marked_list is clear.
      this.recycle_on_empty = _enable;
      if(_enable) this.check_pushes = 1; //enable check_pushes if recycle mode is enabled
   endfunction

   //Sets check_pushes flag.
   function void set_check_pushes(int _enable);
      if(_enable) `cn_assert(this.active_list.size()!=0) //If enabling check pushes then make sure that the bag is not empty.
      this.check_pushes = _enable;
    endfunction  
   
   //Returns a random entry from the bag.  Does NOT remove entry.
   function dataT peek();
      //pick item from bag but don't remove it
      `cn_assert(this.active_list.size()!=0)    
      this.randomize();
      return this.result;
   endfunction

   //Returns a random entry from the bag.  Entry is removed from the bag.  If bag is empty, returns 0.
   function int pop(output dataT _value);
      //pick item from bag and remove it
      if(this.active_list.size()!=0 && this.randomize()) begin
         this.active_list.delete(index);
         if(this.check_pushes) begin
            //move the entry to the marked list if the marked flag is set
            this.marked_list[this.result] += 1;
         end
         _value = this.result;
         if(this.recycle_on_empty!=0 && this.active_list.size()==0) this.unmark_all();
         return(1);
      end
      else return(0);
   endfunction

   //Remove all elements from the bag of the specified value.
   function int remove(dataT _value);
      dataT cleaned_list[$];
      int unsigned num_removed_entries;
      cleaned_list = this.active_list.find(x) with ( x != _value);
      num_removed_entries = this.active_list.size() - cleaned_list.size();
      this.active_list = cleaned_list;
      return(num_removed_entries);
   endfunction

   //Return 1 if there are not
   function int quiet(int _do_error=0);
      if(this.marked_list.size()!=0) begin
         if(_do_error) begin
            `cn_err(("Not all entries were returned to the cn_bag named: %0m:%0s Contents in (key-count) form: %0p", this.get_full_name(),this.marked_list));
         end
         return 0;
      end
      else return 1;
   endfunction
   
   //Returns size of the marked list
   function int marked_size();
      dataT key;
      int count;
      count = 0;
      if(this.marked_list.first(key)) begin
         do
           count += this.marked_list[key];
         while(this.marked_list.next(key));
      end
      
      return count;
   endfunction
   
   //Moves all entries in marked list back to the bag.
   local function void unmark_all();
      dataT key;
      if(this.marked_list.first(key)) begin
         do begin
            int marked_count;
            marked_count = this.marked_list[key];
            for(int j=0;j<marked_count;j++)
              this.push(key);
         end
         while(this.marked_list.next(key));
         this.marked_list.delete;
      end
   endfunction
   
   ////////////////////////////////////////////
   // func: convert2string
   // Single-line printing function
   virtual function string convert2string();
      int  size;
      size = this.active_list.size();
      if(size>0 && size<=this.MAX_PRINT_ENTRIES) 
          return $psprintf("cn_bag_c: %0s, last result=%0d, index=%0d, bag size=%0d, bag=%0m",this.get_full_name(),this.result,this.index,size,this.active_list);
      else
          return $psprintf("cn_bag_c: %0s, last result=%0d, index=%0d, bag size=%0d",this.get_full_name(),this.result,this.index,size);
   endfunction : convert2string

   ////////////////////////////////////////////
   // func: do_copy
   // Handles deep copy
   function void do_copy (uvm_object rhs);
      cn_bag_c#(dataT) casted_obj;
      super.do_copy(rhs);
      $cast(casted_obj,rhs);
      this.marked_list = casted_obj.marked_list;
      this.active_list = casted_obj.active_list;
      this.recycle_on_empty = casted_obj.recycle_on_empty;
      this.check_pushes = casted_obj.check_pushes;
   endfunction
   
endclass : cn_bag_c

// class: cn_mailbag_c
//cn_mailbag_c is a version of cn_bag_c which behaves like a mailbox.  It's pop() function blocks (waits time) if the bag is empty.
class cn_mailbag_c #(type dataT=int) extends cn_bag_c #(dataT);

   //----------------------------------------------------------------------------------------
   // Group: Fields   
   semaphore count; //Used to by pop() task to wait when mailbag is empty.

   `uvm_object_param_utils(cn_mailbag_c #(dataT))
   
   //----------------------------------------------------------------------------------------
   // Group: Methods
   function new(string name="cn_mailbag");
      super.new(name);
      count = new(0); //new semaphore
   endfunction : new

   //Removes all elements from the bag
   function void clear();
      super.clear();
      this.count = new(0); //create semaphore anew
   endfunction
   
   function void push(dataT _num, int _count=1);
      super.push(_num,_count);
      this.count.put(_count);
   endfunction

   //Add a range of values to the bag.  Can specify a count.   
   function int push_range(dataT _start, dataT _end, int _count=1);
      this.count.put(super.push_range(_start,_end,_count));
   endfunction

   //Returns a random entry from the bag.  Entry IS removed from the bag.  If bag is empty, blocks (waits time) until an entry is added.
   task pop(output dataT _value); //needs to be a task because this call may wait time
      this.count.get(1); //decrement semaphore before randomizing
      if(this.recycle_on_empty!=0 && this.active_list.size()==1)
         this.count.put(this.marked_size()+1); //fixup semaphore if auto unmark is enabled and there is only 1 entry in the bag.  The +1 is because the pop has yet to occur.
      super.pop(_value);
   endtask   

   task remove(dataT _value);
      this.count.get(super.remove(_value)); //fix-up the semaphore count - this should never block
   endtask

endclass
   
//----- Test Code ------

`ifdef RUN_CN_BAG_TEST

class test;
   //cn_bag_c #(bit[47:0]) o;
   cn_mailbag_c #(bit[47:0]) o, p;
   
   task run();
      int result_bins[int];
      int num;
      o = new("blah");
      o.push_range(5,9);
      o.push(10,5);

      $display("Print: %0s",o.convert2string());
      
      repeat(10000) begin
           result_bins[o.peek()] += 1;
      end
      
      $display("result_bins: %m",result_bins);

      result_bins.delete;
      o.clear();
      o.push_range(20,22,3);
      $display("Print: %0s",o.convert2string());      
      o.remove(28);
      $display("Post remove 28: %0s",o.convert2string());
      o.remove(21);
      $display("Post remove 21: %0s",o.convert2string());    
      o.remove(20);
      $display("Post remove 20: %0s",o.convert2string());      
      o.remove(22);
      $display("Post remove 22: %0s",o.convert2string());  


      $display("Starting mark test");
      //o.push(50,1,1); //pushed a marked entry - should cause assertion
      o.push(60,2);
      o.push(61,1);
      $display("Marked list size=%0d",o.marked_size());
      o.push(61,1);
      $display("Marked list size=%0d",o.marked_size());      

      o.set_check_pushes(1);
      
      $display("Marked list: %0m",o.marked_list);
      $display("Active list: %0m",o.active_list);
      
      o.pop(num);
      $display("Popped %0d",num);
      $display("Marked list size=%0d",o.marked_size());

      o.pop(num);
      $display("Popped %0d",num);
      $display("Marked list size=%0d",o.marked_size());

      $display("Marked list: %0m",o.marked_list);
      $display("Active list: %0m",o.active_list);
      $cast(p,o.clone());
      $display("Cloned Marked list: %0m",p.marked_list);
      $display("Cloned list: %0m",p.active_list);      
      
      o.pop(num);
      $display("Popped %0d",num);
      $display("Marked list size=%0d",o.marked_size());

      o.pop(num);
      $display("Popped %0d",num);
      $display("Marked list size=%0d",o.marked_size());      

      $display("Marked list: %0m",o.marked_list);
      $display("Active list: %0m",o.active_list);      
     

      o.clear();
      
      o.push(1,1);
      $display("Marked list size=%0d",o.marked_size()); 
      o.push(2,2);
      $display("Marked list size=%0d",o.marked_size());       
      o.push(3,1);
      $display("Marked list size=%0d",o.marked_size());       

      $display("Starting auto-unmark test");
      o.set_recycle_on_empty(1);
      for(int j=0;j<20;j++) begin
         o.pop(num);
         result_bins[num] += 1;
         $display("Result=%0d",num);
      end
      $display("result_bins: %m",result_bins);
      result_bins.delete;
      o.set_recycle_on_empty(0);
      o.set_check_pushes(0);
      o.clear();
      
      $display("Starting mailbag test");
      
      fork
    begin
       int val;
       $display("Started process 1");
       o.pop(val);
       $display("Process 1 saw: %0d",val);
    end
    begin
       int val;
       $display("Started process 2");       
       o.pop(val);
       $display("Process 2 saw: %0d",val);
    end
    begin
       int val;
       $display("Started process 3");       
       o.pop(val);
       $display("Process 3 saw: %0d",val);
    end
    begin
       int val;
       $display("Started process 4");       
       o.pop(val);
       $display("Process 4 saw: %0d",val);
    end    
    begin
       $display("Add process started");
       #10ns;
       $display("About to add elements");
       o.push_range(1,2);
       $display("Added first two elements");
       #10ns;
       o.push_range(3,4);
       $display("Added last two elements");       
    end    

      join

      $display("Print: %0s",o.convert2string());
      
   endtask
   
endclass

module top;

initial begin
   test t = new();
   t.run();
end
endmodule

`endif //RUN_CN_BAG_TEST

`endif // __CN_BAG_SV__

