`timescale 1ns / 100ps
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
    
    reg [31:0]    inst         [5:0];
    reg [63:0]    gpRegs       [7:0];
    reg  [4:0]    alu_funcs    [3:0];
    reg  [1:0]    gpOpselect   [7:0];
    reg  [4:0]    mem_dest     [1:0];
    reg  [1:0]    mem_op       [1:0];
    reg [63:0]    Dcache_data  [1:0];
    reg           Dcache_valid [1:0];
        
    wire [63:0]   gpResults           [3:0];
    wire          valid               [3:0];
    wire          mem_full            [1:0];
    wire [63:0]   proc2Dcache_address [1:0];
    wire [63:0]   proc2Dcache_value   [1:0];
    wire  [1:0]   proc2Dcache_command [1:0];
    wire          mem_retire_en       [1:0];
    wire [63:0]   mem_retire_value    [1:0];
    wire  [4:0]   mem_retire_reg      [1:0];
    
    execute execute_stage(
                          .clock(clock),
                          .reset(reset),
                          .inst(inst),
                          .gpRegs(gpRegs),
                          .alu_funcs(alu_funcs),
                          .gpOpselect(gpOpselect),
                          .gpResults(gpResults),
                          .mem_dest(mem_dest),
                          .mem_op(mem_op),
                          .Dcache_data(Dcache_data),
                          .Dcache_valid(Dcache_valid),
                          .valid(valid),
                          .mem_full(mem_full),
                          .proc2Dcache_address(proc2Dcache_address),
                          .proc2Dcache_value(proc2Dcache_value),
                          .proc2Dcache_command(proc2Dcache_command),
                          .mem_retire_en(mem_retire_en),
                          .mem_retire_value(mem_retire_value),
                          .mem_retire_reg(mem_retire_reg)
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
        reset = 1'b1;
    
        @(posedge clock);
        reset = 1'b0; 
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
        inst[1] = 41'b10000000000000000001100000100000001000000; // 0x100 0030 4040        
        alu_funcs[1] = `ALU_ADD;
        gpRegs[2] = 64'h5;
        gpRegs[3] = 64'h10;
        gpOpselect[2] = `ALU_OPA_IS_REGA;
        gpOpselect[3] = `ALU_OPB_IS_REGB;
        @(posedge clock);
        alu_funcs[0] = `NOOP_INST;
        alu_funcs[1] = `NOOP_INST;
        inst[2] = 41'b10000000000000000001100000100000001000000; // 0x100 0030 4040        
        alu_funcs[2] = `NOOP_INST;
        gpRegs[4] = 64'hF000000080008000;
        gpRegs[5] = 64'h0;
        gpOpselect[4] = `ALU_OPA_IS_REGA;
        gpOpselect[5] = `ALU_OPB_IS_REGB;
        mem_dest[0] = 5'h07;
        mem_op[0] = `BUS_LOAD;
        @(posedge clock);
        mem_op[0] = `BUS_NONE;
        @(posedge clock);
        alu_funcs[1] = `ALU_SUB;
        @(posedge clock);
        alu_funcs[1] = `NOOP_INST;
        @(posedge clock);
        Dcache_data[0] = 64'hFFFF;
        Dcache_valid[0] = 1'b1;
        @(posedge clock);
        Dcache_valid[0] = 1'b0;
    end
endmodule
