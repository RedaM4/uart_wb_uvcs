// updated for checking lsr and ack bits

class wb_master_monitor extends uvm_monitor;
  `uvm_component_utils(wb_master_monitor)

  uvm_analysis_port #(n_cpu_transaction) mon_ap;
  virtual wb_if vif;
  n_cpu_transaction #(8) trans;

  localparam LSR_ADDRESS = 8'h05; 

  function new(string name = "wb_master_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    trans = n_cpu_transaction#(8)::type_id::create("trans");
    mon_ap = new("mon_ap", this);
    if (!uvm_config_db#(virtual wb_if)::get(this, "", "vif", vif))
      `uvm_error("MONITOR", "Failed to get vif from config db");
  endfunction

  task run_phase(uvm_phase phase);
    fork
      monitor_reset();
      monitor_transactions();
    join
  endtask

  task monitor_reset();
    forever begin
      @(posedge vif.reset);
      `uvm_info("MONITOR", "Reset detected", UVM_MEDIUM)
    end
  endtask

  task monitor_transactions();
    forever begin
      @(posedge vif.clock);

      if (!(vif.STB_O && vif.CYC_O))
        continue;

      trans.address = vif.ADR_O;
      trans.M_STATE = vif.WE_O ? WRITE : READ;

      wait(vif.ACK_I); 

      if (vif.WE_O) begin
        trans.data = vif.DAT_O;

        if (trans.address == LSR_ADDRESS) begin
          if (vif.DAT_I[5]) begin 
            `uvm_info("MONITOR", $sformatf("Write to LSR Allowed: Addr=0x%0h Data=0x%0h", 
                                          trans.address, trans.data), UVM_HIGH)
            mon_ap.write(trans);
          end
          else begin
            `uvm_info("MONITOR", "Write to LSR but THRE bit not set, ignoring.", UVM_LOW)
          end
        end
        else begin
          // Normal write to other addresses
          `uvm_info("MONITOR", $sformatf("Write: Addr=0x%0h Data=0x%0h", 
                                        trans.address, trans.data), UVM_HIGH)
          mon_ap.write(trans);
        end

      end
      else begin
        trans.data = vif.DAT_I;

        if (trans.address == LSR_ADDRESS) begin
          if (trans.data[0]) begin 
            `uvm_info("MONITOR", $sformatf("Read from LSR Allowed: Addr=0x%0h Data=0x%0h", 
                                          trans.address, trans.data), UVM_HIGH)
            mon_ap.write(trans);
          end
          else begin
            `uvm_info("MONITOR", "Read from LSR but DR bit not set, ignoring.", UVM_LOW)
          end
        end
        else begin
          `uvm_info("MONITOR", $sformatf("Read: Addr=0x%0h Data=0x%0h", 
                                        trans.address, trans.data), UVM_HIGH)
          mon_ap.write(trans);
        end
      end

    end
  endtask

endclass
