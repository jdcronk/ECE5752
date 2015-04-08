`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2015 10:04:14 PM
// Design Name: 
// Module Name: reg_file_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module reg_file_tb;
    integer i,y;
    reg clock;
    reg [4:0]       rd_idx[`INT_READ_PORTS-1:0];    // 8 read ports
    reg [4:0]       wr_idx[`INT_WRITE_PORTS-1:0];   // 6 write ports
    reg [63:0]      wr_data[`INT_WRITE_PORTS-1:0]; // data for the write ports
    reg             wr_en[`INT_WRITE_PORTS-1:0];    // write enable bits for the write ports
 
    wire [63:0] rd_out[`INT_READ_PORTS-1:0];
    
    regfile_integer REG (.rd_idx(rd_idx), 
                         .rd_out(rd_out),         
                         .wr_idx(wr_idx), 
                         .wr_data(wr_data), 
                         .wr_en(wr_en),
                         .wr_clk(clock)
                   );
    // Generate System Clock
    always
        begin
        #(`VERILOG_CLOCK_PERIOD/2.0);
        clock = ~clock;
    end
    
    initial
        begin
        clock = 1'b0;
    
        // Pulse the reset signal
        $display("@@\n@@\n@@  %t  Asserting blahblahSystem reset......", $realtime);
  
      @(posedge clock);
        //@(posedge clock);
    
      @(posedge clock);
      @(posedge clock);
        `SD;
    // This reset is at an odd time to avoid the pos & neg clock edges
    
    $display("@@  %t  Deasserting System reset......\n@@\n@@", $realtime);
    @(posedge clock);
    for (i = 0; i < `INT_READ_PORTS; i=i+1) begin:INIT
        rd_idx[i] = 0;
    end
    y = 0;
    for (i = 0; i < `INT_WRITE_PORTS; i=i+1) begin:INIT2
        @(posedge clock);
        wr_idx[i] = y;
        wr_data[i] = 64'hDEADBEEF;
        wr_en[i] = 1;
        y=y+1;
    end 
    @(posedge clock);
    wr_idx[0] = 0;
    wr_data[0] = 64'hDEADBEEF;
    wr_en[0] = 1;
    rd_idx[0] = 0;
    @(posedge clock);
    wr_idx[1] = 5;
    wr_data[1] = 64'hC001C0DE;
    wr_en[0] = 0;
    wr_en[1] = 1;
    rd_idx[0] = 0;
    rd_idx[1] = 5;
    for (i = 0; i < `INT_WRITE_PORTS; i=i+1) begin:INIT3
        @(posedge clock);
        wr_idx[i] = 0;
        wr_data[i] = 64'hFFFFFFFF;
        wr_en[i] = 1;
    end
    @(posedge clock);
    wr_en[0] = 0;
    wr_en[1] = 0;
    wr_en[2] = 0;
    wr_en[3] = 0;
    @(posedge clock);
    rd_idx[0] = 5;
    rd_idx[1] = 6;
    wr_idx[0] = 5;
    wr_idx[1] = 6;
    wr_idx[2] = 5;
    wr_idx[3] = 6;
    wr_data[0] = 64'hAAAAAAAA;
    wr_data[1] = 64'hBBBBBBBB;
    wr_data[2] = 64'hCCCCCCCC;
    wr_data[3] = 64'hDDDDDDDD;
    wr_en[0] = 1;
    wr_en[1] = 1;
    wr_en[2] = 1;
    wr_en[3] = 1;
end
endmodule
