class big_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(big_scoreboard)


    `uvm_analysis_imp_decl(_tx)
    `uvm_analysis_imp_decl(_rx)
    // `uvm_analysis_imp_decl(_wb)

  // analysis imports
  uvm_analysis_imp_rx#(uart_packet, big_scoreboard) uart_tx_imp;
  uvm_analysis_imp_tx#(uart_packet, big_scoreboard) uart_rx_imp;
  // uvm_analysis_imp_wb#(n_cpu_transaction, big_scoreboard) wb_master_imp;

  uart_packet tx_queue[$];
  uart_packet rx_queue[$];
  int packet_count;
  int error_count;


  function new(string name, uvm_component parent);
    super.new(name, parent);
    packet_count = 0;
    error_count = 0;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uart_tx_imp = new("uart_tx_imp", this);
    uart_rx_imp = new("uart_rx_imp", this);
    // wb_master_imp = new("wb_master_imp", this);

  endfunction


  // Write function for TX packets (expected)
  function void write_tx(uart_packet pkt);
    `uvm_info("TX_SB", $sformatf("Expected UART Packet: %h", pkt.data), UVM_MEDIUM)
    tx_queue.push_back(pkt);
    packet_count++;
    // check_matches();
  endfunction

  // Write function for RX packets (actual)
  function void write_rx(uart_packet pkt);
    `uvm_info("RX_SB", $sformatf("Received WB Packet: %h", pkt.data), UVM_MEDIUM)
    rx_queue.push_back(pkt);
    // check_matches();
  endfunction

  //   function void write_wb(n_cpu_transaction pkt);
  //   `uvm_info("RX_SB", $sformatf("Received UART Packet: %h", pkt.data), UVM_MEDIUM)
  //   // rx_queue.push_back(pkt);
  //   // check_matches();
  // endfunction

  //   function void check_matches();
  //   while (tx_queue.size() > 0 && rx_queue.size() > 0) begin
  //     uart_packet tx_pkt = tx_queue.pop_front();
  //     uart_packet rx_pkt = rx_queue.pop_front();
      
  //     if (!tx_pkt.compare(rx_pkt)) begin
  //       error_count++;
  //       `uvm_error("MISMATCH", 
  //         $sformatf("Packet mismatch! Expected: %h, Received: %h", 
  //                  tx_pkt.data, rx_pkt.data))
  //     end
  //     else begin
  //       `uvm_info("MATCH", $sformatf("Packet matched: %h", tx_pkt.data), UVM_HIGH)
  //     end
  //   end
  // endfunction

    function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SB_REPORT",
      $sformatf("Scoreboard Summary: %d packets checked, %d errors", 
               packet_count, error_count), UVM_MEDIUM)
  endfunction
endclass