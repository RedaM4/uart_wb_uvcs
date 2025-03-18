class wb_tb extends uvm_env;

`uvm_component_utils(wb_tb);

wb_env env;

//make scoreboard handle;

//clock_and_reset_env clk_n_rst;


function new(string name = "wb_tb", uvm_component parent);
super.new(name,parent); 
`uvm_info("--TESTBENCH_CLASS--","INSIDE CONSTRUCTOR",UVM_HIGH);
endfunction

function void start_of_simulation_phase(uvm_phase phase);
super.start_of_simulation_phase(phase);
`uvm_info("--TESTBENCH_CLASS--","START OF SIMULATION PHASE",UVM_HIGH);
endfunction


function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("--TESTBENCH_CLASS--","INSIDE BUILD PHASE",UVM_HIGH);
env = wb_env::type_id::create("env",this); 

//clk_n_rst = clock_and_reset_env::type_id::create("clk_n_rst",this);

//scoreboard= scoreboard::type_id::create("scoreboard",this);
endfunction



function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
`uvm_info("--TESTBENCH_CLASS--","INSIDE CONNECT PHASE",UVM_HIGH);
//agent.monitor.mon_port.connect(scoreboard.scoreboard_port); //connect scoreboard with monitors here
endfunction


task run_phase(uvm_phase phase);
super.run_phase(phase);
`uvm_info("--TESTBENCH_CLASS--","INSIDE RUN PHASE",UVM_HIGH);
//LOGIC
endtask

endclass: wb_tb
