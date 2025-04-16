class wb_test extends uvm_test;

`uvm_component_utils(wb_test);

uvm_objection obj;

wb_tb testBench;

function new(string name = "wb_test", uvm_component parent);
super.new(name,parent);
`uvm_info("TEST_CLASS","INSIDE CONSTRUCTOR",UVM_HIGH);
endfunction

function void start_of_simulation_phase(uvm_phase phase);
super.start_of_simulation_phase(phase);
`uvm_info("--TEST_CLASS--","START OF SIMULATION PHASE",UVM_HIGH);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("TEST_CLASS","INSIDE BUILD PHASE",UVM_HIGH);
testBench = wb_tb::type_id::create("testBench",this); 

uvm_config_int::set(this,"testBench.env.master_agent","is_active",UVM_ACTIVE);
uvm_config_int::set(this,"testBench.env.slave_agent","is_active",UVM_ACTIVE);

uvm_config_int::set(this,"*","recording_detail",1);
endfunction

function void check_phase(uvm_phase phase);
super.check_phase(phase);
check_config_usage();
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
`uvm_info("TEST_CLASS","INSIDE CONNECT PHASE",UVM_HIGH);

endfunction


task run_phase(uvm_phase phase);
super.run_phase(phase);
`uvm_info("TEST_CLASS","INSIDE RUN PHASE",UVM_HIGH);
uvm_top.print_topology();
obj = phase.get_objection();
obj.set_drain_time(this,200ns);
endtask

endclass: wb_test



//test case 1: 10 random master operations, read write or idle on random addresses
class uart_ten_random_test extends wb_test;

`uvm_component_utils(uart_ten_random_test);

function new(string name = "uart_ten_random_test", uvm_component parent);
super.new(name,parent);
`uvm_info("--TEST_CLASS--","INSIDE CONSTRUCTOR",UVM_HIGH);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("--TEST_CLASS--","INSIDE BUILD PHASE",UVM_HIGH);


//set_type_override_by_type(wb_sequence_item::get_type(),uart_ten_random_test::get_type());


uvm_config_wrapper::set(this, "testBench.env.master_agent.sequencer.run_phase",
                                "default_sequence",
                                uart_ten_random::get_type());       



endfunction

endclass: uart_ten_random_test



//test case 2: 5 write signals on random addresses, 5 read signals on random addreses
class uart_five_write_five_read_test extends wb_test;

`uvm_component_utils(uart_five_write_five_read_test);

function new(string name = "uart_five_write_five_read_test", uvm_component parent);
super.new(name,parent);
`uvm_info("--TEST_CLASS--","INSIDE CONSTRUCTOR",UVM_HIGH);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("--TEST_CLASS--","INSIDE BUILD PHASE",UVM_HIGH);


//set_type_override_by_type(wb_sequence_item::get_type(),uart_ten_random_test::get_type());


uvm_config_wrapper::set(this, "testBench.env.master_agent.sequencer.run_phase",
                                "default_sequence",
                                uart_five_write_five_read::get_type());       



endfunction

endclass: uart_five_write_five_read_test




//test case 3: Write to all addresses of uart, random data
class uart_write_to_all_addresses_test extends wb_test;

`uvm_component_utils(uart_write_to_all_addresses);

function new(string name = "uart_write_to_all_addresses_test", uvm_component parent);
super.new(name,parent);
`uvm_info("--TEST_CLASS--","INSIDE CONSTRUCTOR",UVM_HIGH);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("--TEST_CLASS--","INSIDE BUILD PHASE",UVM_HIGH);


//set_type_override_by_type(wb_sequence_item::get_type(),uart_ten_random_test::get_type());


uvm_config_wrapper::set(this, "testBench.env.master_agent.sequencer.run_phase",
                                "default_sequence",
                                uart_write_to_all_addresses::get_type());       



endfunction

endclass: uart_write_to_all_addresses_test


//test case 4: Read from all addresses of uart
class uart_read_from_all_addresses_test extends wb_test;

`uvm_component_utils(uart_read_from_all_addresses_test);

function new(string name = "uart_read_from_all_addresses_test", uvm_component parent);
super.new(name,parent);
`uvm_info("--TEST_CLASS--","INSIDE CONSTRUCTOR",UVM_HIGH);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("--TEST_CLASS--","INSIDE BUILD PHASE",UVM_HIGH);


//set_type_override_by_type(wb_sequence_item::get_type(),uart_ten_random_test::get_type());


uvm_config_wrapper::set(this, "testBench.env.master_agent.sequencer.run_phase",
                                "default_sequence",
                                uart_read_from_all_addresses::get_type());       



endfunction

endclass: uart_read_from_all_addresses_test


//test case 5: sit idle for 10
class uart_sit_idle_for_10_test extends wb_test;

`uvm_component_utils(uart_sit_idle_for_10_test);

function new(string name = "uart_sit_idle_for_10_test", uvm_component parent);
super.new(name,parent);
`uvm_info("--TEST_CLASS--","INSIDE CONSTRUCTOR",UVM_HIGH);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("--TEST_CLASS--","INSIDE BUILD PHASE",UVM_HIGH);


//set_type_override_by_type(wb_sequence_item::get_type(),uart_ten_random_test::get_type());


uvm_config_wrapper::set(this, "testBench.env.master_agent.sequencer.run_phase",
                                "default_sequence",
                                uart_sit_idle_for_10::get_type());       



endfunction

endclass: uart_sit_idle_for_10_test


//test case 6: run all test cases in one run
class uart_complete_test extends wb_test;

`uvm_component_utils(uart_complete_test);

function new(string name = "uart_complete_test", uvm_component parent);
super.new(name,parent);
`uvm_info("--TEST_CLASS--","INSIDE CONSTRUCTOR",UVM_HIGH);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("--TEST_CLASS--","INSIDE BUILD PHASE",UVM_HIGH);


//set_type_override_by_type(wb_sequence_item::get_type(),uart_ten_random_test::get_type());


uvm_config_wrapper::set(this, "testBench.env.master_agent.sequencer.run_phase",
                                "default_sequence",
                                uart_ten_random::get_type());       



endfunction

endclass: uart_complete_test





/*
class short_yapp_tx_test extends yapp_tx_test;

`uvm_component_utils(short_yapp_tx_test);


function new(string name = "short_yapp_tx_test", uvm_component parent);
super.new(name,parent);
`uvm_info("TEST_CLASS","INSIDE CONSTRUCTOR",UVM_HIGH);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("TEST_CLASS","INSIDE BUILD PHASE",UVM_HIGH);


set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());


endfunction


endclass: short_yapp_tx_test

class configuration_test extends short_yapp_tx_test;

`uvm_component_utils(configuration_test);

function new(string name = "configuration_test", uvm_component parent);
super.new(name,parent);
`uvm_info("--TEST_CLASS--","INSIDE CONSTRUCTOR",UVM_HIGH);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("--TEST_CLASS--","INSIDE BUILD PHASE",UVM_HIGH);


set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());


 uvm_config_wrapper::set(this, "env.agent.sequencer.run_phase",
                                "default_sequence",
                                yapp_5_packets::get_type());

uvm_config_int::set(this,"*agent*","is_active",UVM_ACTIVE);
                                

endfunction

endclass: configuration_test



class yapp_012_test extends yapp_tx_test;

`uvm_component_utils(yapp_012_test);

function new(string name = "yapp_012_test", uvm_component parent);
super.new(name,parent);
`uvm_info("--TEST_CLASS--","INSIDE CONSTRUCTOR",UVM_HIGH);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("--TEST_CLASS--","INSIDE BUILD PHASE",UVM_HIGH);


//set_type_override_by_type(yapp_packet::get_type(),yapp_123_seq::get_type());


 uvm_config_wrapper::set(this, "testBench.yapp_tx.agent.sequencer.run_phase",
                                "default_sequence",
                                yapp_012_seq::get_type());

                                

endfunction

endclass: yapp_012_test



class simple_test extends yapp_tx_test;

`uvm_component_utils(simple_test);

function new(string name = "simple_test", uvm_component parent);
super.new(name,parent);
`uvm_info("--TEST_CLASS--","INSIDE CONSTRUCTOR",UVM_HIGH);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("--TEST_CLASS--","INSIDE BUILD PHASE",UVM_HIGH);


set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());


uvm_config_wrapper::set(this, "testBench.yapp_tx.agent.sequencer.run_phase",
                                "default_sequence",
                                yapp_012_seq::get_type());
uvm_config_wrapper::set(this, "testBench.ch?.rx_agent.sequencer.run_phase",
                                "default_sequence",
                                channel_rx_resp_seq::get_type());       

uvm_config_wrapper::set(this, "testBench.clk_n_rst.agent.sequencer.run_phase",
                                "default_sequence",
                                clk10_rst5_seq::get_type());                          

endfunction

endclass: simple_test

class mc_test extends yapp_tx_test;

`uvm_component_utils(mc_test);

function new(string name = "mc_test", uvm_component parent);
super.new(name,parent);
`uvm_info("--TEST_CLASS--","INSIDE CONSTRUCTOR",UVM_HIGH);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("--TEST_CLASS--","INSIDE BUILD PHASE",UVM_HIGH);


set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());



uvm_config_wrapper::set(this, "testBench.ch?.rx_agent.sequencer.run_phase",
                                "default_sequence",
                                channel_rx_resp_seq::get_type());       

uvm_config_wrapper::set(this, "testBench.clk_n_rst.agent.sequencer.run_phase",
                                "default_sequence",
                                clk10_rst5_seq::get_type());                          
uvm_config_wrapper::set(this, "testBench.mcsequencer.run_phase",
                                "default_sequence",
                                router_simple_mcseq::get_type());


endfunction

endclass: mc_test

*/