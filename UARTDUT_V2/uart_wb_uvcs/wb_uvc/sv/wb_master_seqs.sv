/*
NOTES:
-This file is under cleaning



*/

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
  
  `uvm_object_utils(wb_write_seq)

  function new(string name="wb_write_seq");
    super.new(name);
  endfunction

  rand bit [31:0] Addr; //capital A btw
  rand bit [31:0] Data; //capital D btw

  virtual task body();
      `uvm_do_with(req, { req.address == Addr; req.data== Data; req.M_STATE==WRITE;})
          `uvm_info(get_type_name(), $sformatf("Master writing data (%b) through wishbone to address (%b)",Addr,Data), UVM_LOW)
  endtask
  
endclass : wb_write_seq


class wb_read_seq extends wb_master_sequence;
  
  `uvm_object_utils(wb_read_seq)

  function new(string name="wb_read_seq");
    super.new(name);
  endfunction

  rand bit [31:0] Addr;

  virtual task body();
      `uvm_do_with(req, {req.address == Addr; req.M_STATE==READ;})
      `uvm_info(get_type_name(), $sformatf("Master reading data through wishbone from address (%b)",Addr), UVM_LOW)
  endtask
  
endclass : wb_read_seq


class wb_write_seq_uart extends wb_master_sequence;
  
  `uvm_object_utils(wb_write_seq_uart)

  function new(string name="wb_write_seq_uart");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Writing data to through wishbone to uart address", UVM_LOW)
            `uvm_do_with(req, { req.address == 0;  req.M_STATE==WRITE;})

  endtask
  
endclass : wb_write_seq_uart

class delay_sequence_10mil extends wb_master_sequence;
  
  // Required macro for sequences automation
  `uvm_object_utils(delay_sequence_10mil)

  // Constructor
  function new(string name="delay_sequence_10mil");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Writing data to wishbone on an address", UVM_LOW)
    #10_000_000;
  endtask
  
endclass : delay_sequence_10mil




class wb_read_seq_uart_lsr extends wb_master_sequence;
  
  wb_read_seq read;
  // Required macro for sequences automation
  `uvm_object_utils(wb_read_seq_uart_lsr)

  // Constructor
  function new(string name="wb_read_seq_uart_lsr");
    super.new(name);
    read = wb_read_seq::type_id::create("read");
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Reading uart LSR register", UVM_LOW)
      `uvm_do_with(req, {req.address == 8'd5; req.M_STATE==READ;})
  endtask
  
endclass : wb_read_seq_uart_lsr




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
//`uvm_do_with(wb_write, {wb_write.addr == addr_reciever_buff; wb_write.Data==0;}) //clear reciever buff
//`uvm_do_with(wb_write, {wb_write.addr == addr_int_ie       ; wb_write.Data==int_ie;})        //clear Interrupt Enable
//`uvm_do_with(wb_write, {wb_write.addr == addr_fifo_ctrl    ; wb_write.Data==fifo_ctrl;}) //configure FIFO Control
//`uvm_do_with(wb_write, {wb_write.addr == addr_lcr          ; wb_write.Data==lcr;}) //configure Line Control Register
//`uvm_do_with(wb_write, {wb_write.addr == addr_modem_ctrl   ; wb_write.Data==modem_ctrl;}) //configure modem control


`uvm_do_with(wb_write, {wb_write.Addr == addr_lcr          ; wb_write.Data== 8'b10001011;}) //enable DIVISOR 
`uvm_do_with(wb_write, {wb_write.Addr == addr_DL_B2        ; wb_write.Data==DL_B2;}) //enable DIVISOR 
`uvm_do_with(wb_write, {wb_write.Addr == addr_DL_B1        ; wb_write.Data==DL_B1;}) //enable DIVISOR 
`uvm_do_with(wb_write, {wb_write.Addr == addr_lcr          ; wb_write.Data== 8'b00001011;}) //enable DIVISOR 


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


`uvm_do_with(wb_write, {wb_write.Addr == addr_lcr           ; wb_write.Data== 8'b10001011;}) //enable DIVISOR 
`uvm_do_with(wb_read, {wb_read.Addr == addr_DL_B2           ;}) //enable DIVISOR 
`uvm_do_with(wb_read, {wb_read.Addr == addr_DL_B1          ;}) //enable DIVISOR 


endtask

endclass : uart_read_baudrate


/*
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
*/



class uart_configAndWrite extends wb_master_sequence;


`uvm_object_utils(uart_configAndWrite)

config_uart configure;
delay_sequence_10mil daley;
wb_write_seq_uart write;


function new(string name="uart_configAndWrite");
  super.new(name);
  configure = config_uart::type_id::create("configure");
  write = wb_write_seq_uart::type_id::create("write");
  daley = delay_sequence_10mil::type_id::create("daley");


endfunction

virtual task body();
  `uvm_info(get_type_name(), "Sequence to Configure UART and write a packet",UVM_LOW)


`uvm_do(configure);
`uvm_do(write);
`uvm_do(daley);

endtask

endclass : uart_configAndWrite


class uart_configAndWrite_5 extends wb_master_sequence;


`uvm_object_utils(uart_configAndWrite_5)

config_uart configure;
delay_sequence_10mil daley;
wb_write_seq_uart write;


function new(string name="uart_configAndWrite_5");
  super.new(name);
  configure = config_uart::type_id::create("configure");
  write = wb_write_seq_uart::type_id::create("write");
  daley = delay_sequence_10mil::type_id::create("daley");


endfunction

virtual task body();
  `uvm_info(get_type_name(), "Sequence to Configure UART and write a packet",UVM_LOW)

repeat(5)begin

`uvm_do(configure);
`uvm_do(write);
`uvm_do(daley);
end
endtask

endclass : uart_configAndWrite_5



class uart_configAndRead extends wb_master_sequence;

`uvm_object_utils(uart_configAndRead)

config_uart configure;
delay_sequence_10mil daley;
wb_read_seq_uart_lsr read;
wb_read_seq read_data;
wb_write_seq_uart write;


 n_cpu_transaction req;
 n_cpu_transaction rsp;

  byte rdata;
function new(string name="uart_configAndRead");
  super.new(name);
  configure = config_uart::type_id::create("configure");
  //read = wb_read_seq_uart_lsr::type_id::create("read");
  daley = delay_sequence_10mil::type_id::create("daley");
req = n_cpu_transaction::type_id::create("req");
read_data = wb_read_seq::type_id::create("read_data");
  write = wb_write_seq_uart::type_id::create("write");

endfunction

virtual task body();
  `uvm_info(get_type_name(), "Sequence to Configure UART and read from uart after lsr is written",UVM_LOW)
`uvm_do(configure);

    req.address       = 32'd5;   // Example fixed address
    req.M_STATE = READ;               // 1 for write, 0 for read (example)

rdata = 0;
while(rdata[0]==0)begin
wait_for_grant();
send_request(req);
wait_for_item_done();
get_response(rsp);
rdata = rsp.data[7:0];
//$display("Reading first bit of lsr until it becomes 1");
end
`uvm_do_with(read_data , {read_data.Addr == 0'd0;});
`uvm_do(daley);
    //  `uvm_do_with(read_data, {read_data.addr == 8'd0;})
endtask

endclass : uart_configAndRead


class uart_configAndRead_5 extends wb_master_sequence;

`uvm_object_utils(uart_configAndRead_5)

config_uart configure;
delay_sequence_10mil daley;
wb_read_seq_uart_lsr read;
wb_read_seq read_data;
wb_write_seq_uart write;


 n_cpu_transaction req;
 n_cpu_transaction rsp;

  byte rdata;
function new(string name="uart_configAndRead_5");
  super.new(name);
  configure = config_uart::type_id::create("configure");
  //read = wb_read_seq_uart_lsr::type_id::create("read");
  daley = delay_sequence_10mil::type_id::create("daley");
req = n_cpu_transaction::type_id::create("req");
read_data = wb_read_seq::type_id::create("read_data");
  write = wb_write_seq_uart::type_id::create("write");

endfunction

virtual task body();
  `uvm_info(get_type_name(), "Sequence to Configure UART and read from uart after lsr is written",UVM_LOW)
`uvm_do(configure);
repeat(5)begin

    req.address       = 32'd5;   // Example fixed address
    req.M_STATE = READ;               // 1 for write, 0 for read (example)

rdata = 0;
while(rdata[0]==0)begin
wait_for_grant();
send_request(req);
wait_for_item_done();
get_response(rsp);
rdata = rsp.data[7:0];
//$display("Reading first bit of lsr until it becomes 1");
end

`uvm_do_with(read_data , {read_data.Addr == 0'd0;});
`uvm_do(daley)

  
end
    //  `uvm_do_with(read_data, {read_data.addr == 8'd0;})
endtask

endclass : uart_configAndRead_5



