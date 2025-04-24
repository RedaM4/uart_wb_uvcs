module uart_ver_top;
    import uvm_pkg::*;
`include "uvm_macros.svh"

import uart_pkg::*;
import wb_pkg::*;
import clock_and_reset_pkg::*;


// `include "../tb/uart_ver_integ_mcsequencer.sv"
// `include "../tb/uart_ver_integ_mcseqs_lib.sv"

`include "../tb/uart_ver_tb.sv"
`include "../tb/uart_ver_test_lib.sv"


hw_top dut();


initial begin
    //=============================================

//check path

    //=============================================
    uart_vif_config::set(null,"*tb.uartenv.*","vif",dut.in_uart); 
    wb_vif_config::set(null,"*tb.wbenv.*","vif",dut.in_wb);
    clock_and_reset_vif_config::set(null , "*tb.clk_rst_env.*" , "vif" , dut.clk_rst_if);
    
run_test("base_test") ; 

end



initial begin
$dumpfile("test.vcd");
$dumpvars();
end

//  initial begin

//     #7000;
//  $finish;
//  end


endmodule