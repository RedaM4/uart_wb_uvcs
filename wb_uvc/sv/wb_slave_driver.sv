class wb_slave_driver extends uvm_driver #(n_cpu_transaction);

`uvm_component_utils(n_cpu_transaction);

n_cpu_transaction item;

virtual interface wb_if vif;


function new(string name="wb_slave_driver", uvm_component parent);
super.new(name,parent);
`uvm_info("--DRIVER_CLASS--","INSIDE CONSTRUCTOR",UVM_HIGH);
endfunction

function void start_of_simulation_phase(uvm_phase phase);
super.start_of_simulation_phase(phase);

`uvm_info("--DRIVER_CLASS--","START OF SIMULATION PHASE",UVM_HIGH);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("--DRIVER_CLASS--","INSIDE BUILD PHASE",UVM_HIGH);
item = n_cpu_transaction::type_id::create("item");

if(!(wb_vif_config::get(this,"","vif",vif)))begin
`uvm_error("DRIVER CLASS", "Failed to get vif from config db");
end
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
`uvm_info("--DRIVER_CLASS--","INSIDE CONNECT PHASE",UVM_HIGH);
endfunction

/*
task run_phase(uvm_phase phase);

`uvm_info("--DRIVER_CLASS--","INSIDE RUN PHASE",UVM_HIGH);


    fork
      get_and_drive();
      reset_signals();
    join
  endtask : run_phase

  // Gets packets from the sequencer and passes them to the driver. 
  task get_and_drive();
    @(posedge vif.reset);
    @(negedge vif.reset);
    `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)
    forever begin
      // Get new item from the sequencer
      seq_item_port.get_next_item(req);

      `uvm_info(get_type_name(), $sformatf("Sending Packet :\n%s", req.sprint()), UVM_HIGH)
       
      // concurrent blocks for packet driving and transaction recording
      fork
        // send packet
        begin
          // for acceleration efficiency, write unsynthesizable dynamic payload array directly into 
          // interface static payload array
          foreach (req.payload[i])
            vif.payload_mem[i] = req.payload[i];
          // send rest of YAPP packet via individual arguments
          vif.send_to_dut(req.lenght, req.addr, req.parity, req.packet_delay);
        end
        // trigger transaction at start of packet (trigger signal from interface)
        @(posedge vif.drvstart) void'(begin_tr(req, "Driver_YAPP_Packet"));
      join

      // End transaction recording
      end_tr(req);
      num_sent++;
      // Communicate item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive

  // Reset all TX signals
  task reset_signals();
    forever 
     vif.yapp_reset();
  endtask : reset_signals

  // UVM report_phase
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: YAPP TX driver sent %0d packets", num_sent), UVM_LOW)
  endfunction : report_phase


*/
endclass: wb_slave_driver

