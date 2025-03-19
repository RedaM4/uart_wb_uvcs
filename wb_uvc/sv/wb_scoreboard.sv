///Abdulmalik did this


class wb_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(wb_scoreboard);

  uvm_analysis_imp#(n_cpu_transaction, wb_scoreboard) expected_export; // master
  uvm_analysis_imp#(n_cpu_transaction, wb_scoreboard) actual_export;   // slave

  n_cpu_transaction expected_trans; 
  n_cpu_transaction actual_trans;   

  function new(string name = "wb_scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info("--SCOREBOARD_CLASS--", "INSIDE CONSTRUCTOR", UVM_HIGH);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("--SCOREBOARD_CLASS--", "INSIDE BUILD PHASE", UVM_HIGH);

    expected_export = new("expected_export", this);
    actual_export   = new("actual_export", this);
  endfunction

  function void write_expected(n_cpu_transaction trans);
    expected_trans = trans; 
    `uvm_info("--SCOREBOARD_CLASS--", $sformatf("Received Expected Transaction: Address=0x%h, Data=0x%h, M_STATE=%s",
                                                expected_trans.address, expected_trans.data, expected_trans.M_STATE.name()), UVM_HIGH);
    check_transactions(); 
  endfunction

  function void write_actual(n_cpu_transaction trans);
    actual_trans = trans; 
    `uvm_info("--SCOREBOARD_CLASS--", $sformatf("Received Actual Transaction: Address=0x%h, Data=0x%h, M_STATE=%s",
                                                actual_trans.address, actual_trans.data, actual_trans.M_STATE.name()), UVM_HIGH);
    check_transactions(); 
  endfunction

  function void check_transactions();
    if (expected_trans != null && actual_trans != null) begin
      if (expected_trans.compare(actual_trans)) begin
        `uvm_info("--SCOREBOARD_CLASS--", "Transaction Match\nExpected and actual transactions are correct", UVM_HIGH);
      end else begin
        `uvm_error("--SCOREBOARD_CLASS--", "Transaction Mismatch\nExpected and actual transactions are incorrect");
      end
    end
  endfunction

endclass: wb_scoreboard
