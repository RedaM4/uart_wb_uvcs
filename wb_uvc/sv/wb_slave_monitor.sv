


///////////////////////////////////////////////////////////

//Abdulmalik did this

//////////////////////////////////////////////////////////
class wb_slave_monitor extends uvm_monitor;

  `uvm_component_utils(wb_slave_monitor);

  n_cpu_transaction trans; 
  uvm_analysis_port#(n_cpu_transaction) analysis_port; 
  virtual interface wb_slave_if vif; 

  function new(string name = "wb_slave_monitor", uvm_component parent);
    super.new(name, parent);
    `uvm_info("--SLAVE_MONITOR_CLASS--", "INSIDE CONSTRUCTOR", UVM_HIGH);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("--SLAVE_MONITOR_CLASS--", "INSIDE BUILD PHASE", UVM_HIGH);

    analysis_port = new("analysis_port", this);

    if(!(wb_vif_config::get(this,"","vif",vif)))begin
        `uvm_error("SLAVE_MONITOR CLASS", "Failed to get vif from config db");
    end
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("--SLAVE_MONITOR_CLASS--", "INSIDE RUN PHASE", UVM_HIGH);

    forever begin
      @(posedge vif.clk);

      trans = n_cpu_transaction::type_id::create("trans");

      if (vif.STB_I) begin
        trans.address = vif.ADR_I;
        trans.data    = vif.WE_I ? vif.DAT_I : vif.DAT_O; 
        trans.M_STATE = vif.WE_I ? WRITE : READ;

        while (!vif.ACK_O) begin
          @(posedge vif.clk);
        end
      end else begin
        trans.address = vif.ADR_I; 
        trans.data    = 0;         
        trans.M_STATE = IDLE;      
      end

      if (trans != null) begin
        analysis_port.write(trans);
        `uvm_info("--SLAVE_MONITOR_CLASS--", $sformatf("Captured Transaction: Address=0x%h, Data=0x%h, M_STATE=%s",
                                                       trans.address, trans.data, trans.M_STATE.name()), UVM_HIGH);
      end
    end
  endtask

endclass: wb_slave_monitor
