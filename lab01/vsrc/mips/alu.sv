`ifndef __ALU_SV
`define __ALU_SV

module alu
    import common::*;
    import pipes::*;(
         input logic[31:0] srca, srcb,
        input logic[3:0] alufunc,
        output logic[31:0] result,
        output logic zero //零标志，判断是否需要跳转
    );

    /* TODO: implement your ALU here. */
    
    typedef enum logic[3:0] { 
        ADD = 4'b0001,
        SUB = 4'b0010,
        AND = 4'b0011,
        OR = 4'b0100,
        LESS = 4'b0101
    } ALU_Op;

    always_comb begin
        case(alufunc)
            ADD: result = srca + srcb;
            SUB: result = srca - srcb;
            LESS: result = $signed(srca) < $signed(srcb) ? 32'b1 : 32'b0;
            AND: result = srca & srcb;
            OR: result = srca | srcb;
            default: result = 32'b0;
        endcase
    end
    
    assign zero = (result == 32'b0);
endmodule

`endif
