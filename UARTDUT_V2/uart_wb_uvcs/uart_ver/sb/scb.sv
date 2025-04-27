class big_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(big_scoreboard)

  // analysis imports
  uvm_analysis_imp#(uart_packet, big_scoreboard) uart_tx_imp;
  uvm_analysis_imp#(uart_packet, big_scoreboard) uart_rx_imp;
  // uvm_analysis_imp#(n_cpu_transaction, big_scoreboard) wb_master_imp;


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uart_tx_imp = new("uart_tx_imp", this);
    uart_rx_imp = new("uart_rx_imp", this);
    // wb_master_imp = new("wb_master_imp", this);

  endfunction

  function void write(uart_packet pkt);
    `uvm_info("BIG_SCOREBOARD", $sformatf("Received UART Packet: %p", pkt), UVM_MEDIUM)
    
  endfunction

endclass