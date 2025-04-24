class uart_rx_monitor extends uvm_monitor;
  `uvm_component_utils(uart_rx_monitor)
   virtual uart_if vif;
     uart_packet pkt;

  uvm_analysis_port#(uart_packet) mon_ap_rx;

//Constructor
  function new(string name = "uart_rx_monitor", uvm_component parent);
         super.new(name, parent);
 `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)

  mon_ap_rx = new("mon_ap_rx", this);
  endfunction
//build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("MON_CLASS", "Build Phase!", UVM_HIGH)

    if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif))
      `uvm_fatal("RX_MONITOR", "Failed to get interface handle")
  endfunction

//connect_phase
 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), "Connect Phase!", UVM_HIGH)
  endfunction: connect_phase
  
//rx monitor
task run_phase(uvm_phase phase);
      // @(posedge vif.rx); 
       forever begin
    pkt = uart_packet::type_id::create("pkt");
        //  @(posedge vif.clk);
        vif.tx_2_data(pkt.data);//reads tx
        `uvm_info("z Recived FROM RX MON RECEIVED", $sformatf("Received packet:\n%s", pkt.sprint()), UVM_HIGH)
          //  mon_ap_rx.write(pkt.data);
       end

endtask

    function void start_of_simulation_phase(uvm_phase phase);
            `uvm_info(get_type_name(), "start of simulation phase", UVM_HIGH)
    endfunction
endclass