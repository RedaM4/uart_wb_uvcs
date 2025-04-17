import riscv_types::*;

module data_path #(
    parameter DMEM_DEPTH = 1024, 
    parameter IMEM_DEPTH = 1024
)(
    input logic clk, 
    input logic reset_n,
    // ...
    // ...
);

    // =========================================================================== //
    //    List of the signals needed to be propagated to the WB stage for tracer
    // =========================================================================== //
    `ifdef tracer
    // TRACER IP INSTANTIATION
        logic [31:0] rvfi_insn;
        logic [4:0]  rvfi_rs1_addr;
        logic [4:0]  rvfi_rs2_addr;
        logic [31:0] rvfi_rs1_rdata;
        logic [31:0] rvfi_rs2_rdata;
        logic [4:0]  rvfi_rd_addr;
        logic [31:0] rvfi_rd_wdata;
        logic [31:0] rvfi_pc_rdata;
        logic [31:0] rvfi_pc_wdata;
        logic [31:0] rvfi_mem_addr;
        logic [31:0] rvfi_mem_wdata;
        logic [31:0] rvfi_mem_rdata;
        logic        rvfi_valid;

        assign rvfi_insn      = inst_wb;
        assign rvfi_rs1_addr  = rs1_wb;
        assign rvfi_rs2_addr  = rs2_wb;
        assign rvfi_rd_addr   = rd_wb;
        assign rvfi_rs1_rdata = reg_rdata1_wb;
        assign rvfi_rs2_rdata = reg_rdata2_wb;
        assign rvfi_rd_wdata  = reg_wdata_wb;
        assign rvfi_pc_rdata  = current_pc_wb;
        assign rvfi_pc_wdata  = pc_sel_wb ? current_pc_if1 : current_pc_mem;
        assign rvfi_mem_addr  = 32'd0;
        assign rvfi_mem_rdata = 32'd0;
        assign rvfi_mem_wdata = 32'd0;
        assign rvfi_valid     = (inst_wb[6:0] == 0) ? 1'b0 : 1'b1; // it's not according to spec, but can work if we always generate the valid instruction
    `endif

endmodule 
