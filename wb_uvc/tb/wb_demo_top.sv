import uvm_pkg::*;
`include "uvm_macros.svh"
//import uvc package
import clock_and_reset_pkg::*;


`include "wb_demo_tb.sv"
`include "wb_test_lib.sv"

module tb_top;
    

logic clk;
logic reset;

clkgen clkgen (
    .clock(clk),
    .run_clock(1'b1),
    .clock_period(32'10)
)

  initial begin
    reset <= 1'b0;
    @(negedge clk)
      #1 reset <= 1'b0;
    @(negedge clk)
      #1 reset <= 1'b1;
  end

wb_if wb_intif(clk, reset);

initial begin
wb_vif_config::set(null,"uvm_test_top.testBench.env.*","vif",wb_intif);

//clock_and_reset_vif_config::set(null,"uvm_test_top.testBench.clk_n_rst.*","vif",hw_top.clk_n_rst_if);



    run_test(random_wb_packet);
// force hw_top.in0_clk = 0;
// release hw_top.in0_clk;
end


initial begin
   #50000;
    $display("SYSTEM TIMEOUT!!!");
     $finish;
end


initial begin
    string dumpfile_name;
    
    if ($value$plusargs("DUMPFILE=%s", dumpfile_name)) begin
        $dumpfile(dumpfile_name); 
    end else begin
        $dumpfile("default_dump.vcd"); 
    end
    
    $dumpvars(); 
end



endmodule: tb_top
