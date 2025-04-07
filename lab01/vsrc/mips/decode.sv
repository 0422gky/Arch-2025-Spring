`ifndef __DECODE_SV
`define __DECODE_SV

module decode
    import common::*;
    import pipes::*;(
        input logic clk, reset,
        input word_t instruction,
        input word_t regfile_rd1,
        input word_t regfile_rd2,
        output creg_addr_t regfile_ra1,
        output creg_addr_t regfile_ra2,
        output creg_addr_t regfile_wa,
        output word_t imm_ext,
        output logic [3:0] alu_control,
        output logic reg_write,
        output logic mem_read,
        output logic mem_write,
        output logic branch,
        output logic mem_to_reg,
        output logic jump,
        output word_t jump_addr
    );

    // 提取指令字段
    logic [5:0] opcode;
    logic [4:0] rs, rt, rd;
    logic [15:0] imm;
    logic [5:0] funct;

    assign opcode = instruction[31:26];
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign rd = instruction[15:11];
    assign imm = instruction[15:0];
    assign funct = instruction[5:0];

    // 默认值
    always_comb begin
        reg_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        branch = 1'b0;
        jump = 1'b0;
        mem_to_reg = 1'b0;
        alu_control = 4'b0000;
        imm_ext = {{16{imm[15]}}, imm}; // 符号扩展立即数
        jump_addr = 32'b0;

        case (opcode)
            6'b000000: begin // R 型指令
                reg_write = 1'b1;
                case (funct)
                    6'b100000: alu_control = 4'b0001; // ADD
                    6'b100010: alu_control = 4'b0010; // SUB
                    6'b100100: alu_control = 4'b0011; // AND
                    6'b100101: alu_control = 4'b0100; // OR
                    6'b101010: alu_control = 4'b0101; // SLT
                    default: alu_control = 4'b0000;
                endcase
            end
            6'b100011: begin // LW
                reg_write = 1'b1;
                mem_read = 1'b1;
                mem_to_reg = 1'b1;
                alu_control = 4'b0001; // ADD
            end
            6'b101011: begin // SW
                mem_write = 1'b1;
                alu_control = 4'b0001; // ADD
            end
            6'b001000: begin // ADDI
                reg_write = 1'b1;
                alu_control = 4'b0001; // ADD
            end
            6'b000100: begin // BEQ
                branch = 1'b1;
                alu_control = 4'b0010; // SUB
            end
            6'b000010: begin // J
                jump = 1'b1;
                jump_addr = {instruction[31:28], instruction[25:0], 2'b00};
            end
            default: begin
                // 保持默认值
            end
        endcase
    end

    // 连接寄存器文件
    assign regfile_ra1 = rs;
    assign regfile_ra2 = rt;
    assign regfile_wa = (opcode == 6'b000000) ? rd : rt;

    // 调试信息
    initial begin
        $monitor("Decode: opcode = %h, rs = %d, rt = %d, rd = %d, imm = %h, imm_ext = %h, alu_control = %b, reg_write = %b, mem_read = %b, mem_write = %b, branch = %b, jump = %b",
                 opcode, rs, rt, rd, imm, imm_ext, alu_control, reg_write, mem_read, mem_write, branch, jump);
    end
endmodule

`endif
