`ifndef __FETCH_SV
`define __FETCH_SV

module fetch
    import common::*;
    import pipes::*;(
        input logic clk,reset, //时钟和复位信号
        input logic jump,
        input u32 jump_addr,
        output u32 pc,
        output u32 instruction
    );

    //pc update
    u32 pc_next;
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'b0; // 复位时 PC 初始化为 0
        end else begin
            pc <= pc_next; // 更新 PC 为下一个地址
        end
    end

    // PC 选择逻辑
    always_comb begin
        if (jump) begin
            pc_next = jump_addr; // 跳转到目标地址
        end else begin
            pc_next = pc + 4; // 顺序执行，PC + 4
        end
    end

    //是否需要实例化指令内存？？
    // 实例化指令内存
    imem imem_inst (
        .pc(pc),
        .instruction(instruction)
    );
endmodule

/* maybe userful */
module pcselect
    import common::*;
    import pipes::*;(
        input u1 clk, reset,
        input u32 pc_plus,
        input u32 jump_addr,
        input u1 jump,
        output u32 pc_selected
    );

endmodule

`endif
