typedef enum bit {ODD_PARITY, EVEN_PARITY} parity_type;

class uart_packet extends uvm_sequence_item;
  rand bit [7:0] data;          
  rand parity_type parity_type; 
  bit done;                     
  bit parity_bit;               

  
  constraint data_c { data inside {[0:255]}; } 
  constraint parity_c { parity_type inside {ODD_PARITY, EVEN_PARITY}; } 

  
  `uvm_object_utils_begin(uart_packet)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_enum(parity_type, parity_type, UVM_ALL_ON)
    `uvm_field_int(done, UVM_ALL_ON)
    `uvm_field_int(parity_bit, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "uart_packet");
    super.new(name);
  endfunction

 function void calc_parity();
    parity_bit = ^data; 
    if (parity_type == EVEN_PARITY)
      parity_bit = ~parity_bit; 
  endfunctio
  function void set_parity(bit [7:0] data_val, parity_type parity_val);
    data = data_val;
    parity_type = parity_val;
    calc_parity(); 
  endfunction

  function void post_randomize();
    set_parity(data, parity_type);
  endfunction
  
endclass
