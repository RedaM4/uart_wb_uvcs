


///////////////////////////////////////////////////////////

//Abdulmalik please did this

//////////////////////////////////////////////////////////
cclass wb_master_monitor extends uvm_monitor;

  `uvm_component_utils(wb_master_monitor);

  wb_transaction trans;

  uvm_analysis_port#(wb_transaction) analysis_port;

  virtual wb_if vif;

  function new(string name = "wb_master_monitor", uvm_component parent);
    super.new(name, parent);
    `uvm_info("--MONITOR_CLASS--", "INSIDE CONSTRUCTOR", UVM_HIGH);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("--MONITOR_CLASS--", "INSIDE BUILD PHASE", UVM_HIGH);

    analysis_port = new("analysis_port", this);

    if (!uvm_config_db#(virtual wb_if)::get(this, "", "vif", vif)) begin
      `uvm_error("--MONITOR_CLASS--", "Virtual interface not found!")
    end
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("--MONITOR_CLASS--", "INSIDE RUN PHASE", UVM_HIGH);

    forever begin
      @(posedge vif.clk iff vif.STB_O);

      trans = wb_transaction::type_id::create("trans");

      trans.address = vif.ADR_O;
      trans.data    = vif.WE_O ? vif.DAT_O : vif.DAT_I; 
      trans.M_STATE = vif.WE_O ? WRITE : READ;

      @(posedge vif.clk iff vif.ACK_I);

      analysis_port.write(trans);

      `uvm_info("--MONITOR_CLASS--", $sformatf("Captured Transaction: Address=0x%h, Data=0x%h, M_STATE=%s", 
                                               trans.address, trans.data, trans.M_STATE.name()), UVM_HIGH);
    end
  endtask

endclass: wb_master_monitor
