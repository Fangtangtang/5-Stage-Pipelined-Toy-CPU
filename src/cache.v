// #############################################################################################################################
// CACHE
// 
// 接口：
// - 信号：clk
// - cpu交互：地址，数据（inst、data），操作指令，finished
// - memory交互：地址，数据，操作指令
// 
// cpu和memory交互的中间单元
// 主要用于辨别取instruction还是data
// - data有大小，load读取后一律符号位拓展后再output，store写低位数据
// 简易版(memory controler)，cashe size4
// 状态机取数据
// 
// #############################################################################################################################
`include "src/defines.v"

module CACHE#(parameter ADDR_WIDTH = 17,
              parameter LEN = 32,
              parameter BYTE_SIZE = 8)
             (input wire clk,
              input [ADDR_WIDTH-1:0] mem_inst_addr,   // instruction fetch
              input inst_fetch_enabled,
              output reg [LEN-1:0] instruction,
              input [ADDR_WIDTH-1:0] mem_data_addr,   // memory visit
              input mem_vis_enabled,
              input [LEN-1:0] mem_write_data,
              input [1:0] memory_vis_signal,
              input [1:0] memory_vis_data_size,
              output reg [LEN-1:0] mem_read_data,
              output reg [1:0] mem_vis_status,
              input [BYTE_SIZE-1:0] mem_data,         // interact with main memory
              output [BYTE_SIZE-1:0] mem_writen_data, // 写入memory的数据
              output [ADDR_WIDTH-1:0] mem_vis_addr,   // 访存地址
              output [1:0] mem_vis_signal);
    
    
    reg [BYTE_SIZE-1:0] storage [0:3];
    reg [2:0] MEM_VIS_CNT = 0;
    
    reg [LEN-1:0] data;
    
    reg [ADDR_WIDTH-1:0] addr;
    assign mem_vis_addr = addr;
    
    reg [BYTE_SIZE-1:0] writen_data;
    assign mem_writen_data = writen_data;
    
    reg [1:0] mem_vis_type = 0;
    reg [1:0] data_size    = 0;
    assign mem_vis_signal  = mem_vis_type;
    
    always @(posedge clk) begin
        case (MEM_VIS_CNT)
            // 刚开始访存
            5:begin
                MEM_VIS_CNT = MEM_VIS_CNT - 1;
                mem_vis_status <= `WORKING;
                // write
                if (mem_vis_type == `WRITE) begin
                    writen_data <= mem_write_data[15:8];
                    addr <= addr + 1;
                end
                // read
                else begin
                    addr <= addr + 1;
                end
            end
            4:begin
                MEM_VIS_CNT = MEM_VIS_CNT - 1;
                mem_vis_status <= `WORKING;
                // write
                if (mem_vis_type == `WRITE) begin
                    writen_data <= mem_write_data[23:16];
                    addr <= addr + 1;
                end
                // read
                else begin
                    addr <= addr+1;
                    storage[0] = mem_data;
                end
            end
            3:begin
                MEM_VIS_CNT = MEM_VIS_CNT - 1;
                mem_vis_status <= `WORKING;
                // write
                if (mem_vis_type == `WRITE) begin
                    writen_data <= mem_write_data[31:24];
                    addr <= addr+1;
                end
                // read
                else begin
                    addr <= addr+1;
                    storage[1] = mem_data;
                end
            end
            2:begin
                MEM_VIS_CNT = MEM_VIS_CNT - 1;
                // write
                if (mem_vis_type == `WRITE) begin
                end
                // read
                else begin
                    storage[2] = mem_data;
                end
            end
            1:begin
                MEM_VIS_CNT = MEM_VIS_CNT - 1;
                if (mem_vis_type == `WRITE) begin
                    mem_vis_status <= `R_W_FINISHED;
                end
                else if (mem_vis_type == `READ_DATA)begin
                    mem_vis_status <= `R_W_FINISHED;
                    storage[3] = mem_data;
                    
                    mem_read_data = {storage[3],storage[2],storage[1],storage[0]};
                end
                else if (mem_vis_type == `READ_INST) begin
                    mem_vis_status <= `IF_FINISHED;
                    storage[3] = mem_data;
                    
                    instruction = {storage[3],storage[2],storage[1],storage[0]};
                end
            end
            0:begin
                if (mem_vis_type == `MEM_NOP) begin
                    if (inst_fetch_enabled) begin
                        mem_vis_type <= `READ_INST;
                        addr        = mem_inst_addr;
                        MEM_VIS_CNT = 5;
                        mem_vis_status <= `WORKING;
                    end
                    
                    else
                    if (mem_vis_enabled) begin
                        data_size <= memory_vis_data_size;
                        case (memory_vis_signal)
                            `MEM_NOP:begin
                                mem_vis_type <= `READ_DATA; // 形式记号
                                MEM_VIS_CNT = 0;
                                mem_vis_status <= `R_W_FINISHED;
                            end
                            `READ_DATA:begin
                                mem_vis_type <= `READ_DATA;
                                addr = mem_data_addr;
                                case (memory_vis_data_size)
                                    `BYTE:MEM_VIS_CNT = 2;
                                    `HALF:MEM_VIS_CNT = 3;
                                    `WORD:MEM_VIS_CNT = 5;
                                    default:
                                    $display("[ERROR]:unexpected data_size in load\n");
                                endcase
                                MEM_VIS_CNT = 5;
                                mem_vis_status <= `WORKING;
                            end
                            `READ_INST:begin
                                mem_vis_type <= `READ_INST;
                                addr        = mem_inst_addr;
                                MEM_VIS_CNT = 5;
                                mem_vis_status <= `WORKING;
                            end
                            `WRITE:begin
                                mem_vis_type <= `WRITE;
                                addr = mem_data_addr;
                                data = mem_write_data;
                                writen_data <= mem_write_data[7:0];
                                case (memory_vis_data_size)
                                    `BYTE:MEM_VIS_CNT = 2;
                                    `HALF:MEM_VIS_CNT = 3;
                                    `WORD:MEM_VIS_CNT = 5;
                                    default:
                                    $display("[ERROR]:unexpected data_size in store\n");
                                endcase
                                mem_vis_status <= `WORKING;
                            end
                        endcase
                    end
                end
                else begin
                    mem_vis_type   <= `MEM_NOP;
                    mem_vis_status <= `RESTING;
                end
            end
            default:
            $display("[ERROR]:unexpected counter\n");
        endcase
    end
    
    
endmodule
