class wb_env extends uvm_env;

`uvm_component_utils(wb_env);

yapp_tx_agent agent;

//alu_scoreboard scoreboard;


function new(string name = "yapp_tx_env", uvm_component parent);
super.new(name,parent); 
`uvm_info("--ENV_CLASS--","INSIDE CONSTRUCTOR",UVM_HIGH);
endfunction

function void start_of_simulation_phase(uvm_phase phase);
super.start_of_simulation_phase(phase);
`uvm_info("--ENV_CLASS--","START OF SIMULATION PHASE",UVM_HIGH);
endfunction


function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("--ENV_CLASS--","INSIDE BUILD PHASE",UVM_HIGH);
agent = yapp_tx_agent::type_id::create("agent",this); 
//scoreboard= alu_scoreboard::type_id::create("scoreboard",this);
endfunction



function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
`uvm_info("--ENV_CLASS--","INSIDE CONNECT PHASE",UVM_HIGH);
//agent.monitor.mon_port.connect(scoreboard.scoreboard_port);
endfunction


task run_phase(uvm_phase phase);
super.run_phase(phase);
`uvm_info("--ENV_CLASS--","INSIDE RUN PHASE",UVM_HIGH);
//LOGIC
endtask

endclass: yapp_tx_env