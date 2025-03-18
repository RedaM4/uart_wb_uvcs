import uvm_pkg::*;
`include "uvm_macros.svh"
//import uvc package
import clock_and_reset_pkg::*;


`include "wb_demo_tb.sv"
`include "wb_test_lib.sv"

module tb_top;
    
//    logic clk=0;



//always #2 clk = ~clk; 

initial begin
yapp_vif_config::set(null,"uvm_test_top.testBench.yapp_tx.*","vif",hw_top.in0);
channel_vif_config::set(null,"uvm_test_top.testBench.ch0.*","vif",hw_top.ch_if0);
channel_vif_config::set(null,"uvm_test_top.testBench.ch1.*","vif",hw_top.ch_if1);
channel_vif_config::set(null,"uvm_test_top.testBench.ch2.*","vif",hw_top.ch_if2);
hbus_vif_config::set(null,"uvm_test_top.testBench.hbus.*","vif",hw_top.hbus_if0);
clock_and_reset_vif_config::set(null,"uvm_test_top.testBench.clk_n_rst.*","vif",hw_top.clk_n_rst_if);



    run_test();
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
