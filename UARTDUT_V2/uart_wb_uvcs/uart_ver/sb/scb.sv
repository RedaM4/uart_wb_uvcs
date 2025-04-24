class scb extends uvm_scoreboard;
  `uvm_component_utils(scb)


`uvm_analysis_imp_decl(_uart_tx)
  uvm_analysis_imp_uart_tx#(uart_packet, scb) uart_tx_imp;

`uvm_analysis_imp_decl(_uart_rx)
   uvm_analysis_imp_uart_rx#(uart_packet, scb) uart_rx_imp;



  function new(string name = "scb", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uart_tx_imp = new("uart_tx_imp", this);
    uart_rx_imp = new("uart_rx_imp", this);

  endfunction



  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    

  endfunction
endclass