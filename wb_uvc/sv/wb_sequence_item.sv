//Done

typedef enum bit [1:0] {WRITE, READ, IDLE, NULL} m_state_t;

class n_cpu_transaction #(int WIDTH = 8) extends uvm_sequence_item;

randc bit [31:0] address;
rand bit [WIDTH-1:0] data;
rand m_state_t M_STATE;


constraint address_range  {address >31; address <64;}
constraint master_state_bias {M_STATE dist {WRITE:=45,READ:=45,IDLE:=10,NULL:=0};}


function new (string name = "n_cpu_transaction");
  super.new(name);
  `uvm_info("--SEQ ITEM--","INSIDE CONSTRUCTOR",UVM_HIGH)

endfunction


`uvm_object_utils_begin(n_cpu_transaction)

  `uvm_field_int( address , UVM_ALL_ON+ UVM_DEC );
  `uvm_field_int( data, UVM_ALL_ON + UVM_BIN);
  `uvm_field_enum( m_state_t, M_STATE, UVM_ALL_ON);


`uvm_object_utils_end


endclass: n_cpu_transaction
