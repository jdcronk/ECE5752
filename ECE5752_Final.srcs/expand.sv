`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joshua Cronk
// Design Name: Nexus VLIW Core
// Module Name: expand
//////////////////////////////////////////////////////////////////////////////////

module expand(//Inputs
              clock,
              reset,
              inst_bundle,
              //Outputs
              expanded_insts
              );

    //Inputs
    input        clock;
    input        reset;
    input [31:0] inst_bundle [5:0]; // The six incoming instructions
            
    //Outputs
    output [31:0] expanded_insts [5:0]; // The six expanded instructions
endmodule