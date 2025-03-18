


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//Abdulmalik please do this

//////////////////////////////////////////////////////////
class wb_master_monitor extends uvm_monitor;

`uvm_component_utils(wb_master_monitor); 

function new(string name = "wb_master_monitor", uvm_component parent);
super.new(name,parent); 
`uvm_info("--MONITOR_CLASS--","INSIDE CONSTRUCTOR",UVM_HIGH);
endfunction

function void start_of_simulation_phase(uvm_phase phase);
super.start_of_simulation_phase(phase);
`uvm_info("--MONITOR_CLASS--","START OF SIMULATION PHASE",UVM_HIGH);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("--MONITOR_CLASS--","INSIDE BUILD PHASE",UVM_HIGH);
endfunction


function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
`uvm_info("--MONITOR_CLASS--","INSIDE CONNECT PHASE",UVM_HIGH);
endfunction


task run_phase(uvm_phase phase);
super.run_phase(phase);
`uvm_info("--MONITOR_CLASS--","INSIDE RUN PHASE",UVM_HIGH);

endtask

endclass: wb_master_monitor