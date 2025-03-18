


///////////////////////////////////////////////////////////

//Abdulmalik please did this

//////////////////////////////////////////////////////////
class wb_master_monitor extends uvm_monitor;

  `uvm_component_utils(wb_master_monitor);

  n_cpu_transaction trans; 
  uvm_analysis_port#(n_cpu_transaction) analysis_port; 
  virtual interface wb_master_if vif; 

  function new(string name = "wb_master_monitor", uvm_component parent);
    super.new(name, parent);
    `uvm_info("--MONITOR_CLASS--", "INSIDE CONSTRUCTOR", UVM_HIGH);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("--MONITOR_CLASS--", "INSIDE BUILD PHASE", UVM_HIGH);

    analysis_port = new("analysis_port", this);

    if(!(wb_vif_config::get(this,"","vif",vif)))begin
        `uvm_error("DRIVER CLASS", "Failed to get vif from config db");
    end
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("--MONITOR_CLASS--", "INSIDE RUN PHASE", UVM_HIGH);

    forever begin
      @(posedge vif.clk);

      trans = n_cpu_transaction::type_id::create("trans");

      if (vif.STB_O) begin
        trans.address = vif.ADR_O;
        trans.data    = vif.WE_O ? vif.DAT_O : vif.DAT_I; 
        trans.M_STATE = vif.WE_O ? WRITE : READ;

        while (!vif.ACK_I) begin
          @(posedge vif.clk);
        end
      end else begin
        trans.address = vif.ADR_O; 
        trans.data    = 0;         
        trans.M_STATE = IDLE;      
      end

      if (trans != null) begin
        analysis_port.write(trans);
        `uvm_info("--MONITOR_CLASS--", $sformatf("Captured Transaction: Address=0x%h, Data=0x%h, M_STATE=%s",
                                                 trans.address, trans.data, trans.M_STATE.name()), UVM_HIGH);
      end
    end
  endtask

endclass: wb_master_monitor
