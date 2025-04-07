`ifndef __EXECUTE_SV
`define __EXECUTE_SV

module execute
    import common::*;
    import pipes::*;(
        input word_t rs_data,
        input word_t rt_data,
        input word_t imm_ext,
        input logic [3:0] alu_control,
        input logic alu_src,
        input logic branch,
        output word_t alu_result,
        output logic zero,
        output logic branch_taken
    );
    // ALU 操作数
    word_t alu_operand2;
    assign alu_operand2 = alu_src ? imm_ext : rt_data;

    // 实例化 ALU
    alu alu_inst (
        .srca(rs_data),
        .srcb(alu_operand2),
        .alufunc(alu_control),
        .result(alu_result),
        .zero(zero)
    );

    // 分支判断
    logic compare_result;
    assign compare_result = (rs_data == rt_data);
    assign branch_taken = branch && compare_result;

    // 调试信息
    initial begin
        $monitor("Execute: rs_data = %h, rt_data = %h, imm_ext = %h, alu_src = %b, alu_operand2 = %h, alu_control = %b, alu_result = %h, compare_result = %b, branch = %b, branch_taken = %b",
                 rs_data, rt_data, imm_ext, alu_src, alu_operand2, alu_control, alu_result, compare_result, branch, branch_taken);
    end
endmodule

`endif 
