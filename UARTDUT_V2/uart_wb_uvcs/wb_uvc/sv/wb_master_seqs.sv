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
  rand bit [31:0] dataa;

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Writing data to wishbone on an address", UVM_LOW)
      //randomize();
      `uvm_do_with(req, { req.address == addr; req.data== dataa; req.M_STATE==WRITE;})
     //`uvm_do(req);
  endtask
  
endclass : wb_write_seq

class wb_write_seq_uart extends wb_master_sequence;
  
  // Required macro for sequences automation
  `uvm_object_utils(wb_write_seq_uart)

  // Constructor
  function new(string name="wb_write_seq_uart");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Writing data to wishbone on an address", UVM_LOW)
      //randomize();
      `uvm_do_with(req, { req.address == 0; req.data== 8'hff; req.M_STATE==WRITE;})
     //`uvm_do(req);
  endtask
  
endclass : wb_write_seq_uart

class dd extends wb_master_sequence;
  
  // Required macro for sequences automation
  `uvm_object_utils(dd)

  // Constructor
  function new(string name="dd");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Writing data to wishbone on an address", UVM_LOW)
    #10_000_000;
  endtask
  
endclass : dd


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
      `uvm_do_with(req, {req.address == addr; req.M_STATE==READ;})
  endtask
  
endclass : wb_read_seq


class config_uart extends wb_master_sequence;

`uvm_object_utils(config_uart)

wb_write_seq wb_write;


byte reciever_buff =      8'b00000000; //Reciever Buffer
byte int_ie =             8'b00000000; //Interrupt Enable
byte fifo_ctrl =          8'b00000000; //FIFO Control
byte lcr =                8'b00001011;//Line Control Register
byte modem_ctrl =         8'b00000000; //Modem Control

byte DL_B1 = 8'b01000101; //Divisor Latch 1
byte DL_B2 = 8'b00000001; //Divisor Latch 2

int addr_reciever_buff =  32'h00000000; //Reciever Buffer
int addr_int_ie =         32'h00000001; //Interrupt Enable
int addr_fifo_ctrl =      32'h00000002; //FIFO Control
int addr_lcr =            32'h00000003;//Line Control Register
int addr_modem_ctrl =     32'h00000004; //Modem Control

int addr_DL_B1 = 32'h00000000; //Divisor Latch 1
int addr_DL_B2 = 32'h00000001; //Divisor Latch 2

function new(string name="config_uart");
  super.new(name);
  wb_write = wb_write_seq::type_id::create("wb_write");

endfunction

virtual task body();
  `uvm_info(get_type_name(), "Sequence to Configure UART",UVM_LOW)
//`uvm_do_with(wb_write, {wb_write.addr == addr_reciever_buff; wb_write.dataa==0;}) //clear reciever buff
//`uvm_do_with(wb_write, {wb_write.addr == addr_int_ie       ; wb_write.dataa==int_ie;})        //clear Interrupt Enable
//`uvm_do_with(wb_write, {wb_write.addr == addr_fifo_ctrl    ; wb_write.dataa==fifo_ctrl;}) //configure FIFO Control
//`uvm_do_with(wb_write, {wb_write.addr == addr_lcr          ; wb_write.dataa==lcr;}) //configure Line Control Register
//`uvm_do_with(wb_write, {wb_write.addr == addr_modem_ctrl   ; wb_write.dataa==modem_ctrl;}) //configure modem control


`uvm_do_with(wb_write, {wb_write.addr == addr_lcr          ; wb_write.dataa== 8'b10001011;}) //enable DIVISOR 
`uvm_do_with(wb_write, {wb_write.addr == addr_DL_B2        ; wb_write.dataa==DL_B2;}) //enable DIVISOR 
`uvm_do_with(wb_write, {wb_write.addr == addr_DL_B1        ; wb_write.dataa==DL_B1;}) //enable DIVISOR 
`uvm_do_with(wb_write, {wb_write.addr == addr_lcr          ; wb_write.dataa== 8'b00001011;}) //enable DIVISOR 


endtask

endclass : config_uart


class wb_random_packet extends wb_master_sequence;
  
  // Required macro for sequences automation
  `uvm_object_utils(wb_random_packet)

  // Constructor
  function new(string name="wb_random_packet");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Writing data to wishbone on an address", UVM_LOW)
      randomize();
      `uvm_do_with(req, {req.M_STATE==WRITE;})
     //`uvm_do(req);
  endtask

endclass : wb_random_packet



class uart_read_baudrate extends wb_master_sequence;

`uvm_object_utils(uart_read_baudrate)

wb_write_seq wb_write;
wb_read_seq wb_read;

int addr_lcr   = 32'h00000003;//Line Control Register

int addr_DL_B1 = 32'h00000000; //Divisor Latch 1
int addr_DL_B2 = 32'h00000001; //Divisor Latch 2

function new(string name="uart_read_baudrate");
  super.new(name);
  wb_read = wb_read_seq::type_id::create("wb_read");
  wb_write = wb_write_seq::type_id::create("wb_write");

endfunction

virtual task body();
  `uvm_info(get_type_name(), "Sequence to Configure UART",UVM_LOW)


`uvm_do_with(wb_write, {wb_write.addr == addr_lcr           ; wb_write.dataa== 8'b10001011;}) //enable DIVISOR 
`uvm_do_with(wb_read, {wb_read.addr == addr_DL_B2           ;}) //enable DIVISOR 
`uvm_do_with(wb_read, {wb_read.addr == addr_DL_B1          ;}) //enable DIVISOR 


endtask

endclass : uart_read_baudrate



class uart_configAndRead extends wb_master_sequence;

`uvm_object_utils(uart_configAndRead)

config_uart configure;
uart_read_baudrate read;



function new(string name="uart_read_baudrate");
  super.new(name);
  configure = config_uart::type_id::create("configure");
  read = uart_read_baudrate::type_id::create("read");

endfunction

virtual task body();
  `uvm_info(get_type_name(), "Sequence to Configure UART and read it",UVM_LOW)


`uvm_do(configure);
`uvm_do(read);


endtask

endclass : uart_configAndRead

class uart_configAndWrite extends wb_master_sequence;

`uvm_object_utils(uart_configAndWrite)

config_uart configure;
dd daley;
wb_write_seq_uart write;


function new(string name="uart_configAndWrite");
  super.new(name);
  configure = config_uart::type_id::create("configure");
  write = wb_write_seq_uart::type_id::create("write");
  daley = dd::type_id::create("daley");


endfunction

virtual task body();
  `uvm_info(get_type_name(), "Sequence to Configure UART and read it",UVM_LOW)


`uvm_do(configure);
`uvm_do(write);
`uvm_do(daley);


endtask

endclass : uart_configAndWrite

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