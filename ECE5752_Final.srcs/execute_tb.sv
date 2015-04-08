`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2015 11:09:50 PM
// Design Name: 
// Module Name: execute_tb
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


module execute_tb;
    integer i;
    reg clock, reset;
    
    reg [31:0]    inst        [5:0];
    reg [63:0]    gpRegs      [7:0];
    reg  [4:0]    alu_funcs   [3:0];
    reg  [1:0]    gpOpselect  [7:0];
        
    wire [63:0]   gpResults   [3:0];
    wire          valid       [3:0];
    
    execute execute_stage(
                          .clock(clock),
                          .reset(reset),
                          .inst(inst),
                          .gpRegs(gpRegs),
                          .alu_funcs(alu_funcs),
                          .gpOpselect(gpOpselect),
                          .gpResults(gpResults),
                          .valid(valid)
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
        reset = 1'b0;
        // Pulse the reset signal
        $display("@@\n@@\n@@  %t  Asserting blahblahSystem reset......", $realtime);
    
        @(posedge clock);
    
    
        @(posedge clock);
        @(posedge clock);
        `SD;
        @(posedge clock);
        for(i=0;i < 6; i=i+1) begin:INT
            inst[i] = `NOOP_INST;
        end
        for(i=0;i < 8; i=i+1) begin:INT2
            gpRegs[i] = 64'h0;
        end
        for(i=0;i < 4; i=i+1) begin:INT3
            alu_funcs[i] = `NOOP_INST;
        end
        for(i=0;i < 8; i=i+1) begin:INT4
            gpOpselect[i] = 2'b00;
        end
        @(posedge clock);
        inst[0] = 41'b10000000000000000001100000100000001000000; // 0x100 0030 4040        
        alu_funcs[0] = `ALU_ADD;
        gpRegs[0] = 64'h1;
        gpRegs[1] = 64'h2;
        gpOpselect[0] = `ALU_OPA_IS_REGA;
        gpOpselect[1] = `ALU_OPB_IS_REGB;
        @(posedge clock);
        alu_funcs[0] = `NOOP_INST;
    end
endmodule
