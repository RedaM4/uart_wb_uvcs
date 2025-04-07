
class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    uart_tb tb; 
    uart_1_seq seq ;   
    uvm_objection obj ;
 

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("BASE_TEST", "\n\nNew phase ", UVM_HIGH)
    endfunction

    // Build phase
   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("BASE_TEST", "\nBuild phase started", UVM_HIGH)

    tb = uart_tb::type_id::create("tb", this);
    `uvm_info("BASE_TEST", "\nEnvironment created", UVM_HIGH)

     //uvm_config_wrapper::set(this,"tb.env.tx_agent.seqr.run_phase", "default_sequence", uart_1_seq::get_type());
    
    uvm_config_wrapper::set(this, "tb.env.tx_agent.seqr.run_phase", "default_sequence", uart_1_seq::get_type());


    //------------IMPORTANT
   uvm_config_wrapper::set(this, "tb.env.rx_agent.seqr.run_phase", "default_sequence", uart_1_seq::get_type()); 
//----------------------------



    // uvm_config_wrapper::set(this, "","default_sequence",::get_type());
    `uvm_info("BASE_TEST", "\nDefault sequence configured", UVM_HIGH)
    endfunction

     task run_phase(uvm_phase phase);
     super.run_phase(phase);
        `uvm_info("BASE_TEST", "\nStarting sequence", UVM_MEDIUM)
        seq = uart_1_seq::type_id::create("seq");
        // phase.raise_objection(this);

        // seq.start(tb.env.tx_agent.seqr);
        // phase.drop_objection(this);
        
    endtask

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("BASE_TEST", "End of elaboration phase", UVM_HIGH)
        uvm_top.print_topology();
    endfunction

endclass




