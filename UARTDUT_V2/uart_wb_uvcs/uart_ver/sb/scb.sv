class big_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(big_scoreboard)

  uart_ver_ref ref_model;  // Reference model instance

  // Analysis ports
  `uvm_analysis_imp_decl(_tx)
  `uvm_analysis_imp_decl(_rx)
  `uvm_analysis_imp_decl(_wb)

  uvm_analysis_imp_tx#(uart_packet, big_scoreboard) uart_tx_imp;
  uvm_analysis_imp_rx#(uart_packet, big_scoreboard) uart_rx_imp;
  uvm_analysis_imp_wb#(n_cpu_transaction, big_scoreboard) wb_master_imp;

  // Expected data storage
  bit expecting_data = 0;
  
  // Statistics
  int packet_count;
  int error_count;
  int matched_count;
  int wb_op_count;


  logic [7:0] expected;

  uart_packet rx_queue[$];
  uart_packet tx_queue[$];
  n_cpu_transaction wb_queue[$];


  function new(string name, uvm_component parent);
    super.new(name, parent);
    packet_count = 0;
    error_count = 0;
    wb_op_count = 0;
    matched_count = 0;
    ref_model = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uart_rx_imp = new("uart_rx_imp", this);
    uart_tx_imp = new("uart_tx_imp", this);
    wb_master_imp = new("wb_master_imp", this);
  endfunction


    function void write_rx(uart_packet pkt);
      `uvm_info("RX_SB", $sformatf("Received UART Packet: %h", pkt.data), UVM_MEDIUM)
      rx_queue.push_back(pkt);  
    endfunction

    function void write_tx(uart_packet pkt);
      `uvm_info("TX_SB", $sformatf("Trans UART Packet: %h", pkt.data), UVM_MEDIUM)
      tx_queue.push_back(pkt);  
    endfunction

    function void write_wb(n_cpu_transaction pkt);
      `uvm_info("WB_SB", $sformatf("WB Transaction: Addr=%h, Data=%h", pkt.address, pkt.data), UVM_MEDIUM)
      wb_queue.push_back(pkt); 

    endfunction

    task check_rx();
      uart_packet pkt;

      if (rx_queue.size() > 0) begin
        pkt = rx_queue.pop_front();
        packet_count++;

        if (expecting_data) begin
          if (expected != pkt.data) begin
            error_count++;
            `uvm_error("DATA_MISMATCH", 
              $sformatf("TX data mismatch! Expected: %h, Received: %h",
                      expected, pkt.data))
          end else begin
            `uvm_info("DATA_MATCH", $sformatf("TX data matched: %h", pkt.data), UVM_HIGH)
            matched_count++;
          end
          expecting_data = 0;
        end else begin
          `uvm_warning("UNEXPECTED_DATA", 
            $sformatf("Received unexpected UART data: %h", pkt.data))
          error_count++;
        end
      end else 
          `uvm_info("Nothing", "No packet to check", UVM_HIGH)
    endtask

    task check_tx();
      uart_packet pkt;

      if ((wb_queue.size() + 1) <= tx_queue.size() && tx_queue.size() > 0) begin
        pkt = tx_queue.pop_front();
        packet_count++;

        if (expected != pkt.data) begin
          error_count++;
          `uvm_error("DATA_MISMATCH", 
            $sformatf("TX data mismatch! Expected: %h, Received: %h",
                    expected, pkt.data))
        end else begin
          `uvm_info("DATA_MATCH", $sformatf("TX data matched: %h", pkt.data), UVM_HIGH)
                      matched_count++;
        end
      end else 
          `uvm_info("Nothing", "No packet to check", UVM_HIGH)
    endtask

    task check_wb();
      n_cpu_transaction pkt;
      
      if (wb_queue.size() > 0) begin
        pkt = wb_queue.pop_front();
        wb_op_count++;

        ref_model.update(pkt.address[7:0], pkt.data, (pkt.M_STATE == WRITE) ? 1: 0);
        if (pkt.M_STATE == READ) begin
          expected = ref_model.read(pkt.address[7:0]);
        end

        if ((pkt.M_STATE == WRITE) && pkt.address[7:0] == 8'h0) begin
          expected = pkt.data;
          expecting_data = 1;
          `uvm_info("TX_EXP", $sformatf("Expecting TX data: %h", pkt.data), UVM_HIGH)
        end
      end
    endtask

    task run_phase(uvm_phase phase);
      #300
      forever begin
        if (wb_queue.size() > 0 && wb_queue[0].data[0] == 1'b1) begin
          check_wb();
          check_tx();
          check_rx();
        end
        #10ns;  // Delay to allow items to accumulate
      end
    endtask

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SB_REPORT",
      $sformatf("Scoreboard Summary:\n  WB Operations: %d UART Packets: %d  Errors: %d Matched: %d ", 
               wb_op_count, packet_count, error_count,matched_count), UVM_MEDIUM)
    
    if (expecting_data) begin
      `uvm_warning("SB_REPORT", $sformatf("Still expecting TX data that was never received (expected: %h)", 
                                        expected))
    end
   endfunction
endclass

  // // Handle Wishbone transactions
  // function void write_wb(n_cpu_transaction pkt);
  //   wb_op_count++;
  //   `uvm_info("WB_SB", $sformatf("WB Transaction: Addr=%h, Data=%h, %s", 
  //                              pkt.address, pkt.data, 
  //                              (pkt.M_STATE == WRITE) ? "WRITE" : "READ"), UVM_MEDIUM)
    
  //   // Update reference model
  //   ref_model.update(pkt.address[7:0], pkt.data, (pkt.M_STATE == WRITE) ? 0 : 1);
    
  //   // For reads, compare with reference model
  //   if (pkt.M_STATE == READ) begin
  //       expected = ref_model.read(pkt.address[7:0]);
  //   end
    
  //   // If this is a write to TX register, store as expected data
  //   if ((pkt.M_STATE == WRITE) && pkt.address[7:0] == 8'h0) begin
  //     expected_pkt = uart_packet::type_id::create("expected_pkt");
  //     expected_pkt.data = pkt.data ;
  //     expecting_data = 1;
  //     `uvm_info("TX_EXP", $sformatf("Expecting TX data: %h", pkt.data), UVM_HIGH)
  //   end
  // endfunction


  // // Handle received UART packets and perform immediate checking
  // function void write_rx(uart_packet pkt);
  //   `uvm_info("RX_SB", $sformatf("Received UART Packet: %h", pkt.data), UVM_MEDIUM)
  //   packet_count++;
    
  //   if (expecting_data) begin
  //     if (expected_pkt.data !== pkt.data) begin
  //       error_count++;
  //       `uvm_error("DATA_MISMATCH", 
  //         $sformatf("TX data mismatch! Expected: %h, Received: %h",
  //                  expected_pkt.data, pkt.data))
  //     end
  //     else begin
  //       `uvm_info("DATA_MATCH", $sformatf("TX data matched: %h", pkt.data), UVM_HIGH)
  //     end
  //     expecting_data = 0;
  //   end
  //   else begin
  //     `uvm_warning("UNEXPECTED_DATA", 
  //       $sformatf("Received unexpected UART data: %h", pkt.data))
  //     error_count++;
  //   end
  // endfunction

  // function void write_tx(uart_packet pkt);
  //   `uvm_info("TX_SB", $sformatf("Trans UART Packet: %h", pkt.data), UVM_MEDIUM)
  //   packet_count++;
    

  //     if (expected != pkt.data) begin
  //       error_count++;
  //       `uvm_error("DATA_MISMATCH", 
  //         $sformatf("TX data mismatch! Expected: %h, Received: %h",
  //                  expected, pkt.data))
  //     end
  //     else begin
  //       `uvm_info("DATA_MATCH", $sformatf("TX data matched: %h", pkt.data), UVM_HIGH)
  //     end

  // endfunction