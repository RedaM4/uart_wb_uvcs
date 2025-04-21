module hw_top;

logic clock,reset;
  logic [31:0]  clock_period;
  logic         run_clock;



uart_if in_uart(clock) ; 
wb_if in_wb(clock, reset);



//***************************************************
//   NEEDS TO CHECK
//***************************************************

 wb_soc_top wb_top (

    .wb_clk(clock),
    .wb_rst(reset),
    .wb_m2s_adr(in_wb.ADR_O),
    .wb_m2s_dat(in_wb.DAT_I), 
    .wb_m2s_sel(), 
    .wb_m2s_we(in_wb.WE_O),
    .wb_m2s_cyc(in_wb.CYC_O),
    .wb_m2s_stb(in_wb.STB_O),
    .wb_s2m_dat(in_wb.DAT_O), 
    .wb_s2m_ack(in_wb.ACK_I),
  
    // uart
    .o_uart_tx(in_uart.tx),
    .i_uart_rx(in_uart.rx)
);


clock_and_reset_if clk_rst_if (
    .clock(clock),
    .reset(reset),
    .run_clock(run_clock),
    .clock_period(clock_period)
);

  clkgen clkgen (
    .clock(clock ),
    .run_clock(run_clock),
    .clock_period(clock_period)
  );



endmodule