class uart_ver_tb extends uvm_env;
        `uvm_component_utils(uart_ver_tb)


uart_env uartenv ; 
wb_env wbenv ; 
clock_and_reset_env clk_rst_env ; 

    function new(string name = "router_tb",uvm_component parent);
            super.new(name, parent);
           `uvm_info(get_type_name(), "Inside Constructor!", UVM_LOW)
    endfunction //new()

   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uartenv = uart_env::type_id::create("uartenv", this);
    wbenv = wb_env::type_id::create("wbenv", this);
    clk_rst_env = clock_and_reset_env::type_id::create("clk_rst_env", this);


    endfunction



 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);


    endfunction


  //--------------------------------------------------------
  //start_of_simulation_phase
  //--------------------------------------------------------
function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Running Simulation", UVM_HIGH)
endfunction



endclass