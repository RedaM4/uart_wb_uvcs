
class uart_env extends uvm_env;
  `uvm_component_utils(uart_env)

  uart_tx_agent tx_agent;
  uart_rx_agent rx_agent;

  function new(string name="uart_env", uvm_component parent);
          super.new(name, parent);
`uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)

  endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);  
    `uvm_info(get_type_name(), "Inside Build Phase!", UVM_HIGH)
    
   tx_agent = uart_tx_agent::type_id::create("tx_agent", this);
   rx_agent = uart_rx_agent::type_id::create("rx_agent", this);
endfunction


  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);  
      `uvm_info(get_type_name(), "Inside Connect Phase!", UVM_HIGH)
      
        // tx_agent.mon.mon_ap_tx.connect(scoreboard.uart_tx_imp);
        // rx_agent.mon.mon_ap_rx.connect(scoreboard.uart_rx_imp);

  endfunction
endclass