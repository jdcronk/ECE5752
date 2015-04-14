`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joshua Cronk
// Design Name: Nexus VLIW Core
// Module Name: expand
//////////////////////////////////////////////////////////////////////////////////

module single_decoder(//Inputs
                      inst,
                      valid,
                      //Outputs
                      opa_select,
                      opb_select,
                      alu_func,
                      mem_op
                      );

endmodule

module expand(//Inputs
              clock,
              reset,
              valid,
              inst_bundle,
              mem_full,
              //Outputs
              expanded_insts,
              rd_idx_expanded,
              dest_registers,
              alu_funcs,
              gpOpselect,
              mem_op
              );

    integer i;
    //Inputs
    input         clock;
    input         reset;
    input         valid       [1:0];
    input [127:0] inst_bundle [1:0]; // The six incoming instructions in their bundles
    input         mem_full    [1:0]; // What mem units currently have an operation
            
    //Outputs
    output [31:0] expanded_insts                  [5:0]; // The six expanded instructions
    output  [4:0] rd_idx_expanded [`INT_READ_PORTS-1:0];
    output  [4:0] dest_registers                  [3:0];
    output  [4:0] alu_funcs                       [3:0];
    output  [1:0] gpOpselect                      [7:0];
    output  [1:0] mem_op                          [1:0]; 
    
    always @*
    begin
        
    end
    
endmodule