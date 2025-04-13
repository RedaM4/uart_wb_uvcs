module hw_top;

logic clock,reset;
  logic [31:0]  clock_period;
  logic         run_clock;



uart_if in_uart(clock) ; 
wb_master_if in_wb(clock, reset)

uart_top uart_inst (
    .wb_clk_i(clock),
    .wb_rst_i(reset),
    .wb_adr_i(in_wb.WB_ADDR_I),
    .wb_dat_i(in_wb.WB_DAT_I),
    .wb_dat_o(in_wb.WB_DAT_O),
    .wb_we_i(in_wb.WB_WE_I),
    .wb_stb_i(in_wb.WB_STB_I),
    .wb_cyc_i(in_wb.WB_CYC_I),
    .wb_ack_o(in_wb.WB_ACK_O),
    .wb_sel_i(in_wb.WB_SEL_I),
    //.int_o(int_o),

        .stx_pad_o(in_uart.tx),
    .srx_pad_i(in_uart.rx),


)


clock_and_reset_if clk_rst_if (
    .clock(clock),
    .reset(reset),
    .run_clock(run_clock),
    .clock_period(clock_period)
);



endmodule