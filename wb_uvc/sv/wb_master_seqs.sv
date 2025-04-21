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



class wb_write_seq extends wb_master_sequence;
  
  // Required macro for sequences automation
  `uvm_object_utils(wb_write_seq)

  // Constructor
  function new(string name="wb_write_seq");
    super.new(name);
  endfunction

  rand bit [31:0] addr;
  rand bit [31:0] data;

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Writing data to wishbone on an address", UVM_LOW)
      `uvm_do_with(req, {req.address == this.addr; req.data==this.data; req.M_STATE==WRITE;})
  endtask
  
endclass : wb_write_seq



class wb_read_seq extends wb_master_sequence;
  
  // Required macro for sequences automation
  `uvm_object_utils(wb_read_seq)

  // Constructor
  function new(string name="wb_read_seq");
    super.new(name);
  endfunction

  rand bit [31:0] addr;

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Reading from wishbone on an address", UVM_LOW)
      `uvm_do_with(req, {req.address == this.addr; req.data==this.data; req.M_STATE==READ;})
  endtask
  
endclass : wb_read_seq


class config_uart extends wb_master_sequence;

`uvm_object_utils(config_uart)

wb_write_seq wb_write;


byte reciever_buff =      0b00000000; //Reciever Buffer
byte int_ie =             0b00000000; //Interrupt Enable
byte fifo_ctrl =          0b00000000; //FIFO Control
byte lcr =                0b00001011;//Line Control Register
byte modem_ctrl =         0b00000000; //Modem Control

byte DL_B1 = 0b01000101; //Divisor Latch 1
byte DL_B2 = 0b00000001; //Divisor Latch 2

int addr_reciever_buff =  0x00000020; //Reciever Buffer
int addr_int_ie =         0x00000021; //Interrupt Enable
int addr_fifo_ctrl =      0x00000022; //FIFO Control
int addr_lcr =            0x00000023;//Line Control Register
int addr_modem_ctrl =     0x00000024; //Modem Control

int addr_DL_B1 = 0x00000020; //Divisor Latch 1
int addr_DL_B2 = 0x00000021; //Divisor Latch 2

function new(string name="config_uart");
  super.new(name);
  wb_write = wb_write_seq::type_id::create("wb_write");

endfunction

virtual task body();
  'uvm_info(get_type_name(), "Sequence to Configure UART",UVM_LOW)
`uvm_do_with(wb_write, {wb_write.addr == addr_reciever_buff; wb_write.data==reciever_buff;}) //clear reciever buff
`uvm_do_with(wb_write, {wb_write.addr == addr_int_ie       ; wb_write.data==int_ie;})        //clear Interrupt Enable
`uvm_do_with(wb_write, {wb_write.addr == addr_fifo_ctrl    ; wb_write.data==fifo_ctrl;}) //configure FIFO Control
`uvm_do_with(wb_write, {wb_write.addr == addr_lcr          ; wb_write.data==lcd;}) //configure Line Control Register
`uvm_do_with(wb_write, {wb_write.addr == addr_modem_ctrl   ; wb_write.data==modem_ctrl;}) //configure modem control


`uvm_do_with(wb_write, {wb_write.addr == addr_lcr          ; wb_write.data== 0b10001011;}) //enable DIVISOR 
`uvm_do_with(wb_write, {wb_write.addr == addr_DL_B2        ; wb_write.data==DL_B2;}) //enable DIVISOR 
`uvm_do_with(wb_write, {wb_write.addr == addr_DL_B1        ; wb_write.data==DL_B1;}) //enable DIVISOR 


endtask

endclass : config_uart



/*
class uart_send_data extends wb_master_sequence;
  
  // Required macro for sequences automation
  `uvm_object_utils(wb_write_seq)

  wb_write_seq wb_write;

  // Constructor
  function new(string name="wb_write_seq");
    super.new(name);
  endfunction

  

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing 10 random uart calls", UVM_LOW)
      `uvm_do_with(wb_write, wb_write.addr == 0; wb_write.data==0;)
  endtask
  
endclass : wb_write_seq


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
*/