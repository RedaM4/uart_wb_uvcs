class uart_var_mcsequencer extends uvm_sequencer;
  `uvm_component_utils(uart_var_mcsequencer)


    uart_rx_sequencer  uart_seqr ; 
    wb_master_sequencer wb_sequencer; 

  
  function new(string name = "uart_var_mcsequencer", uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)
  endfunction: new



endclass