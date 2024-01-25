// #############################################################################################################################
// REGISTER FILE
// 
// 32个32位寄存器
// 
// 命令只需场景：
// - instruction decode阶段读取操作数
// - write back阶段向rd写
// 
// todo:reg file上流水后部件抢用，读写冲突
// #############################################################################################################################
`include "src/defines.v"

module REG_FILE #(parameter LEN = 32)
                 (input wire clk,            // clock
                  input rst,
                  input rdy_in,
                  input [1:0] rf_signal,     // nop、读、写
                  input wire [4:0] rs1,      // index of rs1
                  input wire [4:0] rs2,      // index of rs2
                  input wire [4:0] rd,       // index of rd
                  input [LEN-1:0] data,      // write back data
                  input write_back_enabled,
                  output [LEN-1:0] rs1_data,
                  output [LEN-1:0] rs2_data,
                  output [1:0] rf_status);
    
    // 32 registers
    reg [4:0]               rs1_index;
    reg [4:0]               rs2_index;
    reg [LEN-1:0]           register[31:0];
    
    reg [1:0]               status;
    assign rf_status = status;
    
    assign rs1_data = register[rs1_index];
    assign rs2_data = register[rs2_index];
    
    always @(posedge clk) begin
        if (rst) begin
            for (integer i = 0 ;i < 32 ;i = i + 1) begin
                register[i] <= 0;
            end
        end
    end
    
    always @(posedge clk) begin
        if ((!rst)&&rdy_in)begin
            // 读
            rs1_index = rs1;
            rs2_index = rs2;
            // 写
            if (write_back_enabled)begin
                if (rf_signal == `RF_WRITE) begin
                    register[rd] <= data;
                end
                status <= `RF_FINISHED;
            end
            else begin
                status <= `RF_NOP;
            end
        end
    end
    
    // register value 
    wire [31:0] reg0Value  = register[0];
    wire [31:0] reg1Value  = register[1];
    wire [31:0] reg2Value  = register[2];
    wire [31:0] reg3Value  = register[3];
    wire [31:0] reg4Value  = register[4];
    wire [31:0] reg5Value  = register[5];
    wire [31:0] reg6Value  = register[6];
    wire [31:0] reg7Value  = register[7];
    wire [31:0] reg8Value  = register[8];
    wire [31:0] reg9Value  = register[9];
    wire [31:0] reg10Value = register[10];
    wire [31:0] reg11Value = register[11];
    wire [31:0] reg12Value = register[12];
    wire [31:0] reg13Value = register[13];
    wire [31:0] reg14Value = register[14];
    wire [31:0] reg15Value = register[15];
    wire [31:0] reg16Value = register[16];
    wire [31:0] reg17Value = register[17];
    wire [31:0] reg18Value = register[18];
    wire [31:0] reg19Value = register[19];
    wire [31:0] reg20Value = register[20];
    wire [31:0] reg21Value = register[21];
    wire [31:0] reg22Value = register[22];
    wire [31:0] reg23Value = register[23];
    wire [31:0] reg24Value = register[24];
    wire [31:0] reg25Value = register[25];
    wire [31:0] reg26Value = register[26];
    wire [31:0] reg27Value = register[27];
    wire [31:0] reg28Value = register[28];
    wire [31:0] reg29Value = register[29];
    wire [31:0] reg30Value = register[30];
    wire [31:0] reg31Value = register[31];

endmodule
