`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joshua Cronk
// Design Name: Nexus VLIW Core
// Module Name: mem_alu
//////////////////////////////////////////////////////////////////////////////////

module mem_alu(//Inputs
               clock,
               reset,
               inst,
               regA,
               regB,
               regC,
               mem_op,
               alu_func,
               Dcache_data,
               Dcache_valid,
               //Outputs
               proc2Dcache_address,
               proc2Dcache_value,
               proc2Dcache_command,
               mem_retire_en,
               mem_retire_value,
               mem_retire_reg,
               result,
               mem_full,
               alu_valid
               );
               
    input clock;
    input reset;
    input [40:0]    inst;
    input [63:0]    regA;    // Holds the load addr (or contains the register val for a normal ALU)
    input [63:0]    regB;    // Holds the store addr (or contains the register val for a normal ALU)
    input  [6:0]    regC;    // Destination register
    input  [1:0]    mem_op;
    input  [4:0]    alu_func;
    input [63:0]    Dcache_data;
    input           Dcache_valid;
    
    output reg [63:0]   proc2Dcache_address;
    output reg [63:0]   proc2Dcache_value;
    output reg  [1:0]   proc2Dcache_command;
    output reg          mem_retire_en;
    output reg [63:0]   mem_retire_value;
    output reg  [6:0]   mem_retire_reg;
    output     [63:0]   result;
    output              mem_full;
    output              alu_valid;
    
    reg  [6:0]   dest_reg;
    
    wire [4:0] start_alu;
    wire       commit_load;
    wire       commit_store;
       
    assign commit_load  = (mem_op == `BUS_LOAD);
    assign commit_store = (mem_op == `BUS_STORE);
    assign mem_full     = (proc2Dcache_command != `BUS_NONE);
    assign start_alu    = (mem_full | (mem_op != `BUS_NONE)) ? `NOOP_INST : alu_func;  
    
    always @(posedge clock) begin
        if (reset) begin
            dest_reg             <= `SD 0;
            proc2Dcache_address  <= `SD 0;
            proc2Dcache_value    <= `SD 0;
            proc2Dcache_command  <= `SD `BUS_NONE;
            mem_retire_en        <= `SD 0;
            mem_retire_value     <= `SD 0;
            mem_retire_reg       <= `SD 0;
        end
        else begin
            if (commit_load) begin
                dest_reg             <= `SD regC;
                proc2Dcache_address  <= `SD regA;
                proc2Dcache_value    <= `SD 0;
                proc2Dcache_command  <= `SD `BUS_LOAD;
            end
            else if (commit_store) begin
                dest_reg             <= `SD 0;
                proc2Dcache_address  <= `SD regB;
                proc2Dcache_value    <= `SD regA;
                proc2Dcache_command  <= `SD `BUS_STORE;
            end
            
            if (Dcache_valid && (proc2Dcache_command == `BUS_LOAD)) begin
                mem_retire_en        <= `SD 1;
                mem_retire_value     <= `SD Dcache_data;
                mem_retire_reg       <= `SD dest_reg;
                dest_reg             <= `SD 0;
                proc2Dcache_address  <= `SD 0;
                proc2Dcache_value    <= `SD 0;
                proc2Dcache_command  <= `SD `BUS_NONE;
            end
            else if (proc2Dcache_command == `BUS_STORE) begin
                mem_retire_en        <= `SD 0;
                mem_retire_value     <= `SD 0;
                mem_retire_reg       <= `SD 0;
                dest_reg             <= `SD 0;
                proc2Dcache_address  <= `SD 0;
                proc2Dcache_value    <= `SD 0;
                proc2Dcache_command  <= `SD `BUS_NONE;
            end
            else begin
                mem_retire_en        <= `SD 0;
                mem_retire_value     <= `SD 0;
                mem_retire_reg       <= `SD 0;
            end
        end
    end
    
    ////////////////////////////////////////////////////
    // Integer ALU
    ////////////////////////////////////////////////////
    integer_alu int_mem_alu(
                            .opa(regA),
                            .opb(regB),
                            .func(start_alu),
                            .result(result),
                            .valid(alu_valid)
                            );
    
endmodule
