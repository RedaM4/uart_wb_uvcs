class wb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(wb_scoreboard)

  uvm_analysis_imp#(n_cpu_transaction, wb_scoreboard) master_imp;
  uvm_analysis_imp#(n_cpu_transaction, wb_scoreboard) slave_imp;

  n_cpu_transaction master_trans;
  n_cpu_transaction slave_trans;

  int match_count = 0;
  int mismatch_count = 0;
  bit master_received = 0;
  bit slave_received = 0;

  function new(string name = "wb_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_imp = new("master_imp", this);
    slave_imp = new("slave_imp", this);
  endfunction

  function void write_master(input n_cpu_transaction trans);
    master_trans = trans;
    master_received = 1;
    `uvm_info("SCOREBOARD", $sformatf("Received from Master: %s", trans.sprint()), UVM_HIGH)
    check_transactions();
  endfunction

  function void write_slave(input n_cpu_transaction trans);
    slave_trans = trans;
    slave_received = 1;
    `uvm_info("SCOREBOARD", $sformatf("Received from Slave: %s", trans.sprint()), UVM_HIGH)
    check_transactions();
  endfunction

  function void write(input n_cpu_transaction t, uvm_analysis_imp #(n_cpu_transaction, wb_scoreboard) imp);
    if (imp == master_imp) begin
      write_master(t);
    end
    else if (imp == slave_imp) begin
      write_slave(t);
    end
  endfunction

  function void check_transactions();
    if (master_received && slave_received) begin
      `uvm_info("SCOREBOARD", $sformatf("Comparing:\nMaster: %s\nSlave: %s", 
                                       master_trans.sprint(), slave_trans.sprint()), UVM_HIGH)

      if (master_trans.compare(slave_trans)) begin
        match_count++;
        `uvm_info("SCOREBOARD", "Transaction Match", UVM_MEDIUM)
      end
      else begin
        mismatch_count++;
        `uvm_error("SCOREBOARD", "Transaction Mismatch!")
        `uvm_info("SCOREBOARD", $sformatf("Expected:\n%s\nActual:\n%s",
                                         master_trans.sprint(), slave_trans.sprint()), UVM_LOW)
      end

      master_received = 0;
      slave_received = 0;
    end
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SCOREBOARD", $sformatf("Test Summary:\nMatches: %0d\nMismatches: %0d", 
                                     match_count, mismatch_count), UVM_LOW)

    if (mismatch_count == 0)
      `uvm_info("SCOREBOARD", "*** TEST PASSED ***", UVM_NONE)
    else
      `uvm_error("SCOREBOARD", "*** TEST FAILED ***")
  endfunction

  
endclass
