    // =================================================================== //
    //   This is the example tb for connecting tracer to the riscv core
    // ================================================================== //

module rv32i_soc_tb;
    logic clk;
    logic reset_n;
    logic o_flash_sclk;
    logic o_flash_cs_n;
    logic o_flash_mosi;
    logic i_flash_miso;
    logic o_uart_tx;
    logic i_uart_rx;
    // more signals can be here 


    // =================================================== //
    //             Instantiation of the SoC
    // =================================================== //
    // Dut instantiation
    rv32i_soc #(
        .IMEM_DEPTH(IMEM_DEPTH),
        .DMEM_DEPTH(DMEM_DEPTH),
        .NO_OF_GPIO_PINS(NO_OF_GPIO_PINS)
    )DUT(
        .*
    );


    // ============================================================================ //
    //     Example connection of tracer with WB stage signals in the data path
    // ============================================================================ //
    `ifdef tracer 
        tracer tracer_inst (
        .clk_i(clk),
        .rst_ni(reset_n),
        .hart_id_i(1),
        .rvfi_insn_t(DUT.rv32i_core_inst.data_path_inst.rvfi_insn),
        .rvfi_rs1_addr_t(DUT.rv32i_core_inst.data_path_inst.rvfi_rs1_addr),
        .rvfi_rs2_addr_t(DUT.rv32i_core_inst.data_path_inst.rvfi_rs2_addr),
        .rvfi_rs3_addr_t(),
        .rvfi_rs3_rdata_t(),
        .rvfi_mem_rmask(),
        .rvfi_mem_wmask(),
        .rvfi_rs1_rdata_t(DUT.rv32i_core_inst.data_path_inst.rvfi_rs1_rdata),
        .rvfi_rs2_rdata_t(DUT.rv32i_core_inst.data_path_inst.rvfi_rs2_rdata),
        .rvfi_rd_addr_t(DUT.rv32i_core_inst.data_path_inst.rvfi_rd_addr),
        .rvfi_rd_wdata_t(DUT.rv32i_core_inst.data_path_inst.rvfi_rd_wdata),
        .rvfi_pc_rdata_t(DUT.rv32i_core_inst.data_path_inst.rvfi_pc_rdata),
        .rvfi_pc_wdata_t(DUT.rv32i_core_inst.data_path_inst.rvfi_pc_wdata),
        .rvfi_mem_addr(DUT.rv32i_core_inst.data_path_inst.rvfi_mem_addr),
        .rvfi_mem_wdata(DUT.rv32i_core_inst.data_path_inst.rvfi_mem_wdata),
        .rvfi_mem_rdata(DUT.rv32i_core_inst.data_path_inst.rvfi_mem_rdata),
        .rvfi_valid(DUT.rv32i_core_inst.data_path_inst.rvfi_valid)
        );
    `endif


    // ============================================================================ //
    //  Logic to Initialize the instruction Memory and Data Memory with .hex files
    // ============================================================================ //


    // ============================================================================ //
    //                        Your Own testbench logic ....
    // ============================================================================ //


endmodule

