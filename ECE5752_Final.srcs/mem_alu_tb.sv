`timescale 1ns / 100ps

module mem_alu_tb;
    integer i;
    reg clock, reset;
    reg [31:0]    inst;
    reg [63:0]    regA;    // Holds the load addr (or contains the register val for a normal ALU)
    reg [63:0]    regB;    // Holds the store addr (or contains the register val for a normal ALU)
    reg  [4:0]    regC;    // Destination register
    reg  [1:0]    mem_op;
    reg  [4:0]    alu_func;
    reg           valid;
    reg [63:0]    Dcache_data;
    reg           Dcache_valid;
    
    wire [63:0]   proc2Dcache_address;
    wire [63:0]   proc2Dcache_value;
    wire  [1:0]   proc2Dcache_command;
    wire          mem_retire_en;
    wire [63:0]   mem_retire_value;
    wire  [4:0]   mem_retire_reg;
    wire [63:0]   result;
    wire          mem_full;
    wire          alu_valid;
    mem_alu mem_alu_0(
                      .clock(clock),
                      .reset(reset),
                      .inst(inst),
                      .regA(regA),
                      .regB(regB),
                      .regC(regC),
                      .mem_op(mem_op),
                      .alu_func(alu_func),
                      .valid(valid),
                      .Dcache_data(Dcache_data),
                      .Dcache_valid(Dcache_valid),
                      .proc2Dcache_address(proc2Dcache_address),
                      .proc2Dcache_value(proc2Dcache_value),
                      .proc2Dcache_command(proc2Dcache_command),
                      .mem_retire_en(mem_retire_en),
                      .mem_retire_value(mem_retire_value),
                      .mem_retire_reg(mem_retire_reg),
                      .result(result),
                      .mem_full(mem_full),
                      .alu_valid(alu_valid)
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
        inst = 41'b0;
        regA = 64'hF000000080000000;
        regB = 64'h0;
        regC = 5'h05;
        mem_op = `BUS_LOAD;
        alu_func = `ALU_ADD;
        valid = 1'b1;
        Dcache_data = 64'h0;
        Dcache_valid = 0;
        @(posedge clock);
        valid = 1'b0;
        alu_func = `NOOP_INST;
        mem_op = `BUS_NONE;
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        Dcache_data = 64'h500;
        Dcache_valid = 1;
        @(posedge clock);
        Dcache_valid = 0;
    end    
                      
endmodule
