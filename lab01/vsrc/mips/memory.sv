`ifndef __MEMORY_SV
`define __MEMORY_SV

module memory
    import common::*;
    import pipes::*;(
        input logic clk,                  // 时钟信号
        input logic mem_read,             // 存储器读使能信号
        input logic mem_write,            // 存储器写使能信号
        input logic [31:0] addr,          // 数据存储器地址
        input logic [31:0] write_data,    // 写入数据
        output logic [31:0] read_data     // 读取数据
    );

    // 实例化数据存储器
    dmem dmem_inst (
        .clk(clk),
        .we(mem_write),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );
    
endmodule

`endif
