// #############################################################################################################################
// MAIN MEMORY
// 
// 组合逻辑+时序逻辑
// 和cache协作
// 
// - read在主存中使用组合逻辑取数，在cache用时序更新，确保读到的是正确的
// - write在主存中使用时序逻辑修改，在caceh中用组合逻辑，确保index和data在写的时候是对牢的
// #############################################################################################################################
`include "src/defines.v"

module MAIN_MEMORY#(parameter ADDR_WIDTH = 17,
                    parameter LEN = 32,
                    parameter BYTE_SIZE = 8)
                   (input wire clk,
                    input [BYTE_SIZE-1:0] writen_data,
                    input [ADDR_WIDTH-1:0] mem_vis_addr,
                    input [1:0] mem_vis_signal,
                    output [BYTE_SIZE-1:0] mem_data);
    
    reg [BYTE_SIZE-1:0] storage [0:2**ADDR_WIDTH-1];
    reg [BYTE_SIZE-1:0] read_data;
    
    assign mem_data = read_data;
    // 编译为二进制的测试点命名为test.data
    initial begin
        for (integer i = 0;i<2**ADDR_WIDTH;i = i+1) begin
            storage[i] = 0;
        end
        $readmemh("/mnt/f/repo/ToyCPU/user/testspace/test.data", storage);
    end
    
    always @(posedge clk) begin
        if (mem_vis_signal == `WRITE) begin
            storage[mem_vis_addr] <= writen_data;
        end
            if (mem_vis_signal == `READ_DATA||mem_vis_signal == `READ_INST) begin
                read_data <= storage[mem_vis_addr];
            end
    end

endmodule