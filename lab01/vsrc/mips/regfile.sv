`ifndef __REGFILE_SV
`define __REGFILE_SV

module regfile
    import common::*;
    import pipes::*;(
        input logic clk, reset,
        // read ports
        input creg_addr_t ra1, ra2,
        output word_t rd1, rd2,
        // write port
        input creg_addr_t wa,
        input word_t wd,
        input logic we
    );
    // 寄存器文件
    word_t [31:0] regs, regs_nxt;

    // 读端口
    assign rd1 = (ra1 == 0) ? 32'b0 : regs[ra1];
    assign rd2 = (ra2 == 0) ? 32'b0 : regs[ra2];

    // 写端口
    always_ff @(posedge clk) begin
        if (reset) begin
            regs <= '0;
        end else begin
            regs <= regs_nxt;
        end
    end

    // 组合逻辑写
    always_comb begin
        regs_nxt = regs;
        if (we && (wa != 0)) begin
            regs_nxt[wa] = wd;
        end
    end

    // 调试信息
    initial begin
        $monitor("Regfile: ra1 = %d, ra2 = %d, wa = %d, we = %b, wd = %h, rd1 = %h, rd2 = %h",
                 ra1, ra2, wa, we, wd, rd1, rd2);
    end
endmodule

`endif
