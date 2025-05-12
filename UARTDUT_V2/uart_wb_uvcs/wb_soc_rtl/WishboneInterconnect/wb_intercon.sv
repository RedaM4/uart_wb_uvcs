module wb_intercon
   (input         wb_clk_i,
    input         wb_rst_i,

    // IO ( wb master signals )
    input  [31:0] wb_io_adr_i,
    input  [31:0] wb_io_dat_i,
    input   [3:0] wb_io_sel_i,
    input         wb_io_we_i,
    input         wb_io_cyc_i,
    input         wb_io_stb_i,
    input   [2:0] wb_io_cti_i,
    input   [1:0] wb_io_bte_i,
    output [31:0] wb_io_dat_o,
    output        wb_io_ack_o,
    output        wb_io_err_o,
    output        wb_io_rty_o,

    // SPI 1 SIGNALS 
    output [31:0] wb_spi_1_adr_o,
    output [31:0] wb_spi_1_dat_o,
    output  [3:0] wb_spi_1_sel_o,
    output        wb_spi_1_we_o,
    output        wb_spi_1_cyc_o,
    output        wb_spi_1_stb_o,
    output  [2:0] wb_spi_1_cti_o,
    output  [1:0] wb_spi_1_bte_o,
    input  [31:0] wb_spi_1_dat_i,
    input         wb_spi_1_ack_i,
    input         wb_spi_1_err_i,
    input         wb_spi_1_rty_i,

    // SPI 2 SIGNALS 
    output [31:0] wb_spi_2_adr_o,
    output [31:0] wb_spi_2_dat_o,
    output  [3:0] wb_spi_2_sel_o,
    output        wb_spi_2_we_o,
    output        wb_spi_2_cyc_o,
    output        wb_spi_2_stb_o,
    output  [2:0] wb_spi_2_cti_o,
    output  [1:0] wb_spi_2_bte_o,
    input  [31:0] wb_spi_2_dat_i,
    input         wb_spi_2_ack_i,
    input         wb_spi_2_err_i,
    input         wb_spi_2_rty_i,

    // UART SIGNALS 
    output [31:0] wb_uart_adr_o,
    output [31:0] wb_uart_dat_o,
    output  [3:0] wb_uart_sel_o,
    output        wb_uart_we_o,
    output        wb_uart_cyc_o,
    output        wb_uart_stb_o,
    output  [2:0] wb_uart_cti_o,
    output  [1:0] wb_uart_bte_o,
    input  [31:0] wb_uart_dat_i,
    input         wb_uart_ack_i,
    input         wb_uart_err_i,
    input         wb_uart_rty_i
);


wb_mux
  #(.num_slaves (3),
    .MATCH_ADDR ({32'h00000000, 32'h00000010, 32'h10000020}),
    .MATCH_MASK ({32'hfffffff0, 32'hfffffff0, 32'hffffffe0}))
 wb_mux_io
   (.wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wbm_adr_i (wb_io_adr_i),
    .wbm_dat_i (wb_io_dat_i),
    .wbm_sel_i (wb_io_sel_i),
    .wbm_we_i  (wb_io_we_i),
    .wbm_cyc_i (wb_io_cyc_i),
    .wbm_stb_i (wb_io_stb_i),
    .wbm_cti_i (wb_io_cti_i),
    .wbm_bte_i (wb_io_bte_i),
    .wbm_dat_o (wb_io_dat_o),
    .wbm_ack_o (wb_io_ack_o),
    .wbm_err_o (wb_io_err_o),
    .wbm_rty_o (wb_io_rty_o),
    .wbs_adr_o ({wb_spi_1_adr_o, wb_spi_2_adr_o, wb_uart_adr_o}),
    .wbs_dat_o ({wb_spi_1_dat_o, wb_spi_2_dat_o, wb_uart_dat_o}),
    .wbs_sel_o ({wb_spi_1_sel_o, wb_spi_2_sel_o, wb_uart_sel_o}),
    .wbs_we_o  ({wb_spi_1_we_o,  wb_spi_2_we_o,  wb_uart_we_o}),
    .wbs_cyc_o ({wb_spi_1_cyc_o, wb_spi_2_cyc_o, wb_uart_cyc_o}),
    .wbs_stb_o ({wb_spi_1_stb_o, wb_spi_2_stb_o, wb_uart_stb_o}),
    .wbs_cti_o ({wb_spi_1_cti_o, wb_spi_2_cti_o, wb_uart_cti_o}),
    .wbs_bte_o ({wb_spi_1_bte_o, wb_spi_2_bte_o, wb_uart_bte_o}),
    .wbs_dat_i ({wb_spi_1_dat_i, wb_spi_2_dat_i, wb_uart_dat_i}),
    .wbs_ack_i ({wb_spi_1_ack_i, wb_spi_2_ack_i, wb_uart_ack_i}),
    .wbs_err_i ({wb_spi_1_err_i, wb_spi_2_err_i, wb_uart_err_i}),
    .wbs_rty_i ({wb_spi_1_rty_i, wb_spi_2_rty_i, wb_uart_rty_i}));

    //   0x00000000 - 0x0000000f SPI
    //   0x00000010 - 0x0000001f SPI
    //   0x00000020 - 0x0000003f UART

endmodule
