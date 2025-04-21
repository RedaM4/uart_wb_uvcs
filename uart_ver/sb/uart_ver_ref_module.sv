class uart_ver_ref extends uvm_component;
  `uvm_component_utils(uart_ver_ref)
        
        uvm_analysis_port #(uart_packet) uart_valid_port;
        
          `uvm_analysis_imp_decl(_uart)
          `uvm_analysis_imp_decl(_wb)

          uvm_analysis_imp_uart  #(uart_packet, uart_ver_ref) uart_in; 
          uvm_analysis_imp_wb  #(n_cpu_transaction, uart_ver_ref) wb_in;

function new(string name, uvm_component parent);
    super.new(name, parent);
        
    uart_in = new("uart_in", this);  
    wb_in = new("wb_in", this);
    uart_valid_port = new("uart_valid_port", this);
endfunction


function void write_wb(n_cpu_transaction tr);



endfunction


  function void write_uart(uart_packet packet);
    uart_packet ypkt;


  endfunction




  function void report_phase(uvm_phase phase);
    super.report_phase(phase);

  endfunction: report_phase



endclass 

