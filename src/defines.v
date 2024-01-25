// #############################################################################################################################
// DEFINE
// 
// 为二进制编码重命名，增加可读性
// #############################################################################################################################

// sign bit
`define     ZERO                2'b00
`define     POS                 2'b01
`define     NEG                 2'b11

// SIGNAL
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ALU 计算控制信号
// ----------------------------------------------------------
`define     ALU_NOP                 3'b000
`define     BINARY                  3'b001
`define     IMM_BINARY              3'b010
`define     BRANCH_COND             3'b011
`define     MEM_ADDR                3'b100
`define     PC_BASED                3'b101
`define     IMM                     3'b110

// binary
`define     ADD                     4'b0000

// IMM
`define     ADDI                    3'b000
`define     SLTI                    3'b010

// MEM 访存信号
// ----------------------------------------------------------
`define     MEM_NOP                 2'b00
`define     WRITE                   2'b01
`define     READ_DATA               2'b10
`define     READ_INST               2'b11

// MEM 访存状态
// ----------------------------------------------------------
`define     RESTING                 2'b00
`define     WORKING                 2'b01
`define     IF_FINISHED             2'b10
`define     R_W_FINISHED            2'b11

// Data Size
// ----------------------------------------------------------
`define     NOT_ACCESS              2'b00
`define     BYTE                    2'b01
`define     HALF                    2'b10
`define     WORD                    2'b11

// BRANCH
// ----------------------------------------------------------
`define     NOT_BRANCH              2'b00
`define     UNCONDITIONAL           2'b01
`define     CONDITIONAL             2'b10
`define     UNCONDITIONAL_RESULT    2'b11 // jalr

// WB 写寄存器
// ----------------------------------------------------------
`define     WB_NOP                  2'b00
`define     MEM_TO_REG              2'b01
`define     ARITH                   2'b10
`define     INCREASED_PC            2'b11

// Reg File 访问信号
`define     RF_NOP                  2'b00
`define     RF_WRITE                2'b01
`define     RF_FINISHED             2'b10