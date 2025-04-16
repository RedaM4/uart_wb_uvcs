//need to figure out the sequences to be generated


class wb_master_sequence extends uvm_sequence #(n_cpu_transaction);
  
  `uvm_object_utils(wb_master_sequence)

  function new(string name="wb_master_sequence");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body



endclass : wb_master_sequence




class uart_ten_random extends wb_master_sequence;
  
  // Required macro for sequences automation
  `uvm_object_utils(uart_ten_random)

  // Constructor
  function new(string name="uart_ten_random");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing 10 random uart calls", UVM_LOW)
     repeat(10)
      `uvm_do(req)
  endtask
  
endclass : uart_ten_random




class uart_five_write_five_read extends wb_master_sequence;
  
  // Required macro for sequences automation
  `uvm_object_utils(uart_five_write_five_read)

  // Constructor
  function new(string name="uart_five_write_five_read");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "send 5 write signals to random addresses of uart, then send 5 read signals from random addresses of uart", UVM_LOW)
     repeat(5)
      `uvm_do_with(req, {M_STATE==WRITE;});
    repeat(5)
      `uvm_do_with(req, {M_STATE==READ;});
  endtask
  
endclass : uart_five_write_five_read




class uart_write_to_all_addresses extends wb_master_sequence;
  
  // Required macro for sequences automation
  `uvm_object_utils(uart_write_to_all_addresses)

  // Constructor
  function new(string name="uart_write_to_all_addresses");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "sending write signal to all uart addresses from 32 to 63", UVM_LOW)
    for(int i=32; i<64; i++)begin 
      `uvm_do_with(req, {address==i;M_STATE==WRITE;});
    end
  endtask
  
endclass : uart_write_to_all_addresses



class uart_read_from_all_addresses extends wb_master_sequence;
  
  // Required macro for sequences automation
  `uvm_object_utils(uart_read_from_all_addresses)

  // Constructor
  function new(string name="uart_read_from_all_addresses");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "sending read signal to all uart addresses from 32 to 63", UVM_LOW)
    for(int i=32; i<64; i++)begin 
      `uvm_do_with(req, {address==i;M_STATE==READ;});
    end
  endtask
  
endclass : uart_read_from_all_addresses




class uart_sit_idle_for_10 extends wb_master_sequence;
  
  // Required macro for sequences automation
  `uvm_object_utils(uart_sit_idle_for_10)

  // Constructor
  function new(string name="uart_sit_idle_for_10");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "sitting IDLE, no read or write for 10 times", UVM_LOW)
    repeat(10)
      `uvm_do_with(req, {M_STATE==IDLE;});
  endtask
  
endclass : uart_sit_idle_for_10
