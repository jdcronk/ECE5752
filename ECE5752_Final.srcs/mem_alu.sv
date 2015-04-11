`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2015 10:10:30 PM
// Design Name: 
// Module Name: mem_alu
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


module mem_alu(//Inputs
               clock,
               reset,
               inst,
               regA,
               regB,
               regC,
               mem_op,
               alu_func,
               valid,
               Dcache_data,
               Dcache_valid,
               //Outputs
               proc2Dcache_address,
               proc2Dcache_value,
               proc2Dcache_command,
               mem_retire_en,
               mem_retire_value,
               mem_retire_reg,
               mem_full
               );
               
    input clock;
    input reset;
    input [31:0]    inst;
    input [63:0]    regA;    // Holds the load addr (or contains the register val for a normal ALU)
    input [63:0]    regB;    // Holds the store addr (or contains the register val for a normal ALU)
    input  [4:0]    regC;    // Destination register
    input  [1:0]    mem_op;
    input  [4:0]    alu_func;
    input           valid;
    input [63:0]    Dcache_data;
    input           Dcache_valid;
    
    output reg [63:0]   proc2Dcache_address;
    output reg [63:0]   proc2Dcache_value;
    output reg  [1:0]   proc2Dcache_command;
    output reg          mem_retire_en;
    output reg [63:0]   mem_retire_value;
    output reg  [4:0]   mem_retire_reg;
    output              mem_full;
    
    reg          mem_valid;
    reg [63:0]   address, value;
    reg  [4:0]   dest_reg;
    reg  [1:0]   mem_op;
    
endmodule
