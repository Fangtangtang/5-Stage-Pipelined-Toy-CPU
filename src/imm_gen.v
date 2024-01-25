// #############################################################################################################################
// IMMIDIATE GENETATOR
// 
// 根据输入的instruction，提取出立即数，并符号位拓展
// 
// 指令格式
// 31           25 24         20 19         15 14 12 11          7 6       0
// +--------------+-------------+-------------+-----+-------------+---------+
// |   func7      |     rs2     |     rs1     |func3|     rd      | opcode  |   R-type
// |         imm[11:0]          |     rs1     |func3|     rd      | opcode  |   I-type
// |  imm[11:5]   |     rs2     |     rs1     |func3|  imm[4:0]   | opcode  |   S-type
// | imm[12|10:5] |     rs2     |     rs1     |func3| imm[4:1|11] | opcode  |   B-type
// |                   imm[31:12]                   |     rd      | opcode  |   U-type
// |             imm[20|10:1|11|19:12]              |     rd      | opcode  |   J-type
// 
// #############################################################################################################################
module IMMEDIATE_GENETATOR#(parameter LEN = 32)
                           (input chip_enable,
                            input [LEN-1:0] instruction,
                            input wire [5:0] inst_type,
                            output reg signed [LEN-1:0] immediate);
    
    wire sign_bit;
    assign sign_bit = instruction[31];
    
    wire signed [LEN-1:0] R_imm = 0;
    wire signed [LEN-1:0] I_imm = {{20{sign_bit}}, instruction[31:20]};
    wire signed [LEN-1:0] S_imm = {{20{sign_bit}}, instruction[31:25], instruction[11:7]};
    // B:在立即数中已经处理移位
    wire signed [LEN-1:0] B_imm = {{19{sign_bit}}, sign_bit, instruction[7], instruction[30:25], instruction[11:8],1'b0};
    wire signed [LEN-1:0] U_imm = {instruction[31:12],{12{1'b0}}};
    // J:在立即数中已经处理移位
    wire signed [LEN-1:0] J_imm = {{12{sign_bit}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21],1'b0};
    
    // MUX to select
    always @(*) begin
        if (chip_enable)begin
            case (inst_type)
                6'b100000:immediate = R_imm;
                6'b010000:immediate = I_imm;
                6'b001000:immediate = S_imm;
                6'b000100:immediate = B_imm;
                6'b000010:immediate = U_imm;
                6'b000001:immediate = J_imm;
            endcase
        end
    end
endmodule // imm_gen
