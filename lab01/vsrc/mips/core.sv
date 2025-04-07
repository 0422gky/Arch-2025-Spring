`ifndef __CORE_SV
`define __CORE_SV

module core
    import common::*;
    import pipes::*;(
        input logic clk, reset,
        /* instruction memory */
        output u32 instr_addr,
        input u32 instruction,
        /* data memory */
        output u32 data_addr,
        input word_t read_data,
        output word_t write_data,
        output u1 write_enable
    );
    
    /* instruction */
    u32 pc, pc_next;
    assign instr_addr = pc;

    /* Decode 阶段 */
    logic [4:0] regfile_ra1, regfile_ra2, regfile_wa;
    logic [31:0] regfile_rd1, regfile_rd2, imm_ext;
    logic [3:0] alu_control;
    logic reg_write, mem_read, mem_write, branch;
    logic jump;
    logic [31:0] jump_addr;
    logic mem_to_reg;

    decode decode_inst (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .regfile_rd1(regfile_rd1),
        .regfile_rd2(regfile_rd2),
        .regfile_ra1(regfile_ra1),
        .regfile_ra2(regfile_ra2),
        .regfile_wa(regfile_wa),
        .imm_ext(imm_ext),
        .alu_control(alu_control),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .mem_to_reg(mem_to_reg),
        .jump(jump),
        .jump_addr(jump_addr)
    );

    /* Execute 阶段 */
    logic [31:0] alu_result;
    logic zero, branch_taken;
    logic alu_src;

    // ALU 输入选择
    assign alu_src = (instruction[31:26] == 6'b001000) || // ADDI
                    (instruction[31:26] == 6'b100011) || // LW
                    (instruction[31:26] == 6'b101011);   // SW

    execute execute_inst (
        .rs_data(regfile_rd1),
        .rt_data(regfile_rd2),
        .imm_ext(imm_ext),
        .alu_control(alu_control),
        .alu_src(alu_src),
        .branch(branch),
        .alu_result(alu_result),
        .zero(zero),
        .branch_taken(branch_taken)
    );

    /* Memory 阶段 */
    memory memory_inst (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(alu_result),
        .write_data(regfile_rd2),
        .read_data(read_data)
    );

    /* Regfile */
    logic [31:0] reg_write_data;
    assign reg_write_data = mem_to_reg ? read_data : alu_result;

    regfile regfile_inst(
        .clk(clk), 
        .reset(reset),
        .ra1(regfile_ra1), 
        .ra2(regfile_ra2),
        .rd1(regfile_rd1), 
        .rd2(regfile_rd2),
        .wa(regfile_wa),
        .wd(reg_write_data),
        .we(reg_write)
    );

    /* 内存接口 */
    assign data_addr = alu_result;
    assign write_enable = mem_write;
    assign write_data = regfile_rd2;

    /* PC 更新逻辑 */
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'b0;
        end else begin
            pc <= pc_next;
        end
    end

    always_comb begin
        if (jump) begin
            pc_next = jump_addr;
        end else if (branch_taken) begin
            pc_next = pc + 4 + (imm_ext << 2);
        end else begin
            pc_next = pc + 4;
        end
    end

    // 调试信号
    initial begin
        $monitor("PC = %h, Instruction = %h, Branch = %b, Jump = %b, Branch_taken = %b, PC_next = %h, ALU_result = %h, ALU_src = %b, mem_to_reg = %b, reg_write_data = %h",
                 pc, instruction, branch, jump, branch_taken, pc_next, alu_result, alu_src, mem_to_reg, reg_write_data);
    end
endmodule

`endif
