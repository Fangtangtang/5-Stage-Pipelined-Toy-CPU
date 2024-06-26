// #############################################################################################################################
// ALU
// 
// 组合逻辑
// 执行运算专用
// #############################################################################################################################

`include "src/defines.v"

module ALU#(parameter LEN = 32)
           (input [LEN - 1:0] rs1,
            input [LEN - 1:0] rs2,
            input [LEN - 1:0] imm,
            input [LEN - 1:0] pc,
            input [2:0] alu_signal,
            input [3:0] func_code,
            output reg [LEN - 1:0] result,
            output reg [1:0] sign_bits);
    
    always @(*) begin
        case (alu_signal)
            `ALU_NOP:begin
            end
            `BINARY:begin
                case (func_code)
                    `ADD:result = rs1 + rs2;
                    default:
                    $display("[ERROR]:unexpected binary instruction\n");
                endcase
            end
            `IMM_BINARY:begin
                case (func_code[2:0])
                    `ADDI:result = rs1 + imm;
                    `SLTI:result = rs1 < imm ? 1 : 0;
                    default:
                    $display("[ERROR]:unexpected immediate binary instruction\n");
                endcase
            end
            `BRANCH_COND:begin
                result = rs1 - rs2;
            end
            `MEM_ADDR:begin
                result = rs1 + imm;
            end
            `PC_BASED:begin
                result = pc + imm;
            end
            `IMM:begin
                result = imm;
            end
            default :
            $display("[ERROR]:unexpected alu instruction\n");
        endcase
        if (result>0) begin
                    sign_bits = `POS;
                end
                else if (result == 0) begin
                    sign_bits = `ZERO;
                end
                else begin
                    sign_bits = `NEG;
                end
    end    
endmodule
