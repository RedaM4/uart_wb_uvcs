class uart_tx_monitor extends uvm_monitor;
  `uvm_component_utils(uart_tx_monitor)
  
  virtual uart_if vif;
  uvm_analysis_port#(uart_packet) mon_ap;
  uart_packet pkt;

//Constructor
  function new(string name= "uart_tx_monitor", uvm_component parent);
         super.new(name, parent);
 `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)

    mon_ap = new("mon_ap", this);
  endfunction
//build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(), "Build Phase!", UVM_HIGH)

    if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif))
      `uvm_fatal("TX_MONITOR", "Failed to get interface handle")
  endfunction

//connect_phase
 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), "Connect Phase!", UVM_HIGH)
  endfunction: connect_phase
  
//run_phase
  // task run_phase(uvm_phase phase);
  // pkt=uart_packet::type_id::create("pkt");
  //  // @(negedge vif.clk)
  //       @(negedge vif.clk)
  //      // @(posedge vif.clk)

  //   forever begin

  //    // wait (vif.rx == 0); 
  //   //@(negedge vif.clk)
  //   // pkt.baud_rate = vif.baud_rate;
  //    vif.rx_2_data(pkt.data) ; 
  //     `uvm_info("zRECEIVED", $sformatf("Received packet:\n%s", pkt.sprint()), UVM_HIGH)

  //       end
  // endtask


task run_phase(uvm_phase phase);
    pkt = uart_packet::type_id::create("pkt");
    forever begin
        // Wait for idle state (rx == 1) and start bit (rx == 0)
        wait (vif.rx == 1);
        wait (vif.rx == 0);

        // Small delay to ensure stability
         repeat (2) @(negedge vif.clk);

        // Sample the data
        vif.rx_2_data(pkt.data);
        $display("Monitor: Received packet with data = %h at time %0t", pkt.data, $time);
        `uvm_info("zRECEIVED", $sformatf("Received packet:\n%s", pkt.sprint()), UVM_HIGH)
        mon_ap.write(pkt);  // Send the packet to the analysis port
    end
endtask
    function void start_of_simulation_phase(uvm_phase phase);
            `uvm_info(get_type_name(), "start of simulation phase", UVM_HIGH)
    endfunction
endclass
    //   // // Monitor TX signal and convert to packet
    //   // uart_packet packet;
    //   // // Logic to sample TX signal and create packet
    //   // mon_ap.write(packet);