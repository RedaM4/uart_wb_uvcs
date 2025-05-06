`include "uvm_macros.svh"

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

  n_cpu_transaction  wb_data[$];
  
  // Statistics
  int packet_count;
  int error_count;
  int matched_count;
  int wb_op_count;
  int skipped;
  bit mode;

  logic [7:0] expected;


  function new(string name, uvm_component parent);
    super.new(name, parent);
    skipped = 0;
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
      uart_packet uart_pkt;
      `uvm_info("RX_SB", $sformatf("Received UART Packet: %h", pkt.data), UVM_MEDIUM)
      $cast(uart_pkt, pkt.clone());
      // Print queue contents
      print_ref_model_queues();
      fork check_uart(uart_pkt.data); join_none

    endfunction


    function void write_tx(uart_packet pkt);
      uart_packet uart_pkt;
      `uvm_info("TX_SB", $sformatf("Trans UART Packet: %h", pkt.data), UVM_MEDIUM)
      $display("pkt data at tx  %h", pkt.data);
      $cast(uart_pkt, pkt.clone());
      ref_model.rx_queue.push_back(uart_pkt.data);  
      // Print queue contents
      print_ref_model_queues();
    endfunction


    function void write_wb(n_cpu_transaction pkt);
      n_cpu_transaction wb_pkt;
      `uvm_info("WB_SB", $sformatf("WB Transaction: Addr=%h, Data=%h", pkt.address, pkt.data), UVM_MEDIUM)
      $cast(wb_pkt, pkt.clone());
      ref_model.update(wb_pkt.address[7:0], wb_pkt.data, (wb_pkt.M_STATE == WRITE) ? 1 : 0);
      wb_data.push_back(wb_pkt);
      mode = (wb_pkt.M_STATE == WRITE) ? 1 : 0;
      if(wb_pkt.M_STATE == READ && wb_pkt.address == 0) check_uart(wb_pkt.data);

    endfunction


    task check_uart(logic [7:0] data);

        if(mode == 1) begin
          expected = ref_model.tx_queue.pop_front();
          // $display("[COMPARE][WRITE] Expected (RX): %h | Actual (RX): %h", expected, data);
          if (expected != data && expected != 8'hx) begin
                error_count++;
                `uvm_error("DATA_MISMATCH", 
                  $sformatf("RX data mismatch! Expected: %h, Received: %h",
                          expected, data))
              end else if(expected == data) begin
                `uvm_info("DATA_MATCH", $sformatf("RX data matched: %h", data), UVM_HIGH)
                  // $display("[COMPARE][WRITE][MATCH] Expected (RX): %h | Actual (RX): %h", expected, data);
                matched_count++;
              end else begin
                skipped++;
              end
        end
        else begin 
          expected = ref_model.rx_queue.pop_front();
          // $display("[COMPARE][READ] Expected (TX): %h | Actual (TX): %h", expected, data);
          if (expected != data && expected != 8'hx) begin
                error_count++;
                `uvm_error("DATA_MISMATCH", 
                  $sformatf("TX data mismatch! Expected: %h, Received: %h",
                          expected, data))
              end else if(expected == data) begin
                `uvm_info("DATA_MATCH", $sformatf("TX data matched: %h", data), UVM_HIGH)
                matched_count++;
              end else begin
                skipped++;
              end
        end
    endtask


function void report_phase(uvm_phase phase);
  super.report_phase(phase);
`uvm_info("SB_REPORT",
          $sformatf("\n================== Scoreboard Summary ==================\n%-12s : %0d\n%-12s : %0d\n========================================================",
                    "Errors", error_count,
                    "Matched", matched_count),
          UVM_MEDIUM)
endfunction



task print_ref_model_queues();
  int i;
  $display("\n\n\nREFRENCE MODEL");
  $display("====== TX Queue Contents ======");
  for (i = 0; i < ref_model.tx_queue.size(); i++) begin
    $display("TX[%0d] = %h", i, ref_model.tx_queue[i]);
  end

  $display("====== RX Queue Contents ======");
  for (i = 0; i < ref_model.rx_queue.size(); i++) begin
    $display("RX[%0d] = %h", i, ref_model.rx_queue[i]);
  end

  $display("====== WB DATA Queue Contents ======");
  for (i = 0; i < wb_data.size(); i++) begin
    $display("wb[%0d] data = %h, state = %s, address = %h", i, wb_data[i].data, wb_data[i].M_STATE == WRITE ? "write" : "read", wb_data[i].address);
  end

  $display("\n\n\n");
endtask




endclass