class uart_ver_ref_env extends uvm_env;
`uvm_component_utils(uart_ver_ref_env)

  uart_ver_scoreboard  scoreboard;

  function new(string name, uvm_component parent);
    super.new(name, parent);
        `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)

  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
        `uvm_info(get_type_name(), "Build Phase!", UVM_HIGH)

    scoreboard = uart_ver_scoreboard::type_id::create("scoreboard", this);

  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), "Connect Phase!", UVM_HIGH)

 



endfunction: connect_phase


endclass