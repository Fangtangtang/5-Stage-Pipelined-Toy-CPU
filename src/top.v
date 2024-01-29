// #############################################################################################################################
// TOP
// #############################################################################################################################
`include"src/cpu.v"
`include"src/cache.v"
`include"src/main_memory.v"

module top#(parameter SIM = 0,
            parameter LEN = 32)
           (input wire EXCLK,
            input wire btnC,
            output wire Tx,
            input wire Rx,
            output wire led);
    
    localparam SYS_CLK_FREQ = 100000000;		 // 系统时钟频率
    localparam UART_BAUD_RATE = 115200;			 // UART通信的波特率（数据在串行通信中传输的速率。它表示每秒传输的位数）
    localparam ADDR_WIDTH = 20;
    localparam BYTE_SIZE  = 8;
    
    reg rst;
    reg rst_delay;
    
    wire clk;	          // 时钟
    assign clk = EXCLK; // 内部时钟和外部输入的时钟相连
    
    always @(posedge clk or posedge btnC)
    begin
        if (btnC)
        begin
            rst       <= 1'b1;
            rst_delay <= 1'b1;
        end
        else
        begin
            rst_delay <= 1'b0;
            rst       <= rst_delay;
        end
    end
    
    wire cpu_rdy = 1;
    
    wire [LEN-1:0] instruction;
    wire [LEN-1:0] mem_read_data;
    wire [1:0] mem_vis_status;
    wire [LEN-1:0] mem_write_data;
    wire [ADDR_WIDTH-1:0] mem_inst_addr;
    wire [ADDR_WIDTH-1:0] mem_data_addr;
    wire inst_fetch_enabled;
    wire mem_vis_enabled;
    wire [1:0] memory_vis_signal;
    wire [1:0] memory_vis_data_size;
    
    
    CPU #(.LEN(LEN),
    .ADDR_WIDTH(ADDR_WIDTH))
    cpu(
    .clk(clk),
    .rst(rst),
    .rdy_in(cpu_rdy),
    .instruction(instruction),
    .mem_read_data(mem_read_data),
    .mem_vis_status(mem_vis_status),
    .mem_write_data(mem_write_data),
    .mem_inst_addr(mem_inst_addr),
    .mem_data_addr(mem_data_addr),
    .inst_fetch_enabled(inst_fetch_enabled),
    .mem_vis_enabled(mem_vis_enabled),
    .memory_vis_signal(memory_vis_signal),
    .memory_vis_data_size(memory_vis_data_size)
    );
    
    wire [BYTE_SIZE-1:0] mem_data;
    wire [BYTE_SIZE-1:0] writen_data;
    wire [ADDR_WIDTH-1:0] mem_vis_addr;
    wire [1:0] mem_vis_signal;
    
    CACHE cache(
    .clk(clk),
    .mem_inst_addr(mem_inst_addr),
    .inst_fetch_enabled(inst_fetch_enabled),
    .instruction(instruction),
    .mem_data_addr(mem_data_addr),
    .mem_vis_enabled(mem_vis_enabled),
    .mem_write_data(mem_write_data),
    .memory_vis_signal(memory_vis_signal),
    .memory_vis_data_size(memory_vis_data_size),
    .mem_read_data(mem_read_data),
    .mem_vis_status(mem_vis_status),
    .mem_data(mem_data),
    .mem_writen_data(writen_data),
    .mem_vis_addr(mem_vis_addr),
    .mem_vis_signal(mem_vis_signal)
    );
    
    MAIN_MEMORY main_memory(
    .clk(clk),
    .writen_data(writen_data),
    .mem_vis_addr(mem_vis_addr),
    .mem_vis_signal(mem_vis_signal),
    .mem_data(mem_data)
    );
    
endmodule
