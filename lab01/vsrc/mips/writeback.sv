`ifndef __WRITEBACK_SV
`define __WRITEBACK_SV

module writeback
    import common::*;
    import pipes::*;(
        input logic [31:0] alu_result,    // 来自 ALU 的运算结果
        input logic [31:0] read_data,     // 来自数据存储器的读取数据
        input logic mem_to_reg,           // 数据来源选择信号
        input logic reg_write,            // 寄存器写使能信号
        input logic [4:0] regfile_wa,     // 写入寄存器的地址
        output logic [31:0] write_data    // 写回寄存器的数据
    );
    
     // 根据 mem_to_reg 信号选择写回寄存器的数据来源
    assign write_data = (mem_to_reg) ? read_data : alu_result;

endmodule

`endif
