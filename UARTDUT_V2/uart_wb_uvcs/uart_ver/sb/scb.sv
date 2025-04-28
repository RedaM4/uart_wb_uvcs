class big_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(big_scoreboard)

  uart_ver_ref ref_model;  // Reference model instance

  // Analysis ports
  `uvm_analysis_imp_decl(_rx)
  `uvm_analysis_imp_decl(_wb)

  uvm_analysis_imp_rx#(uart_packet, big_scoreboard) uart_rx_imp;
  uvm_analysis_imp_wb#(n_cpu_transaction, big_scoreboard) wb_master_imp;

  // Expected data storage
  uart_packet expected_pkt;
  bit expecting_data = 0;
  
  // Statistics
  int packet_count;
  int error_count;
  int wb_op_count;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    packet_count = 0;
    error_count = 0;
    wb_op_count = 0;
    ref_model = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uart_rx_imp = new("uart_rx_imp", this);
    wb_master_imp = new("wb_master_imp", this);
  endfunction

  // Handle Wishbone transactions
  function void write_wb(n_cpu_transaction pkt);
    wb_op_count++;
    `uvm_info("WB_SB", $sformatf("WB Transaction: Addr=%h, Data=%h, %s", 
                               pkt.address, pkt.data, 
                               (pkt.M_STATE == WRITE) ? "WRITE" : "READ"), UVM_MEDIUM)
    
    // Update reference model
    ref_model.update(pkt.address[7:0], pkt.data, (pkt.M_STATE == WRITE) ? 0 : 1);
    
    // For reads, compare with reference model
    if (pkt.M_STATE == READ) begin
      logic [7:0] expected = ref_model.read(pkt.address[7:0]);
      if (pkt.data !== expected) begin
        error_count++;
        `uvm_error("WB_MISMATCH", 
          $sformatf("Register read mismatch! Addr=%h, Expected=%h, Actual=%h",
                   pkt.address, expected, pkt.data))
      end
    end
    
    // If this is a write to TX register, store as expected data
    if ((pkt.M_STATE == WRITE) && pkt.address[7:0] == 8'h0) begin
      expected_pkt = uart_packet::type_id::create("expected_pkt");
      expected_pkt.data = pkt.data ;
      expecting_data = 1;
      `uvm_info("TX_EXP", $sformatf("Expecting TX data: %h", pkt.data), UVM_HIGH)
    end
  endfunction

  // Handle received UART packets and perform immediate checking
  function void write_rx(uart_packet pkt);
    `uvm_info("RX_SB", $sformatf("Received UART Packet: %h", pkt.data), UVM_MEDIUM)
    packet_count++;
    
    if (expecting_data) begin
      if (expected_pkt.data !== pkt.data) begin
        error_count++;
        `uvm_error("DATA_MISMATCH", 
          $sformatf("TX data mismatch! Expected: %h, Received: %h",
                   expected_pkt.data, pkt.data))
      end
      else begin
        `uvm_info("DATA_MATCH", $sformatf("TX data matched: %h", pkt.data), UVM_HIGH)
      end
      expecting_data = 0;
    end
    else begin
      `uvm_warning("UNEXPECTED_DATA", 
        $sformatf("Received unexpected UART data: %h", pkt.data))
      error_count++;
    end
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SB_REPORT",
      $sformatf("Scoreboard Summary:\n  WB Operations: %d UART Packets: %d  Errors: %d", 
               wb_op_count, packet_count, error_count), UVM_MEDIUM)
    
    if (expecting_data) begin
      `uvm_warning("SB_REPORT", $sformatf("Still expecting TX data that was never received (expected: %h)", 
                                        expected_pkt.data))
    end
  endfunction
endclass