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
                      dest_reg,
                      mem_op,
                      valid_inst
                      );
    input [40:0] inst;
    input        valid;
    
    output reg [1:0] opa_select;
    output reg [1:0] opb_select;
    output reg [4:0] alu_func;
    output reg [1:0] dest_reg;
    output reg [1:0] mem_op;
    output           valid_inst;
    
    reg illegal;
    
    assign valid_inst = valid & ~illegal;
    
    always @* begin
        opa_select = `ALU_OPA_IS_REGA;
        opb_select = `ALU_OPB_IS_REGB;
        alu_func = `NOOP_INST;
        dest_reg = `DEST_NONE;
        mem_op = `BUS_NONE;
        illegal = `FALSE;
        if (valid) begin
            case (inst[40:33])
                `ADD_INST: begin
                            alu_func = `ALU_ADD;
                            dest_reg = `DEST_REG1;
                           end
                `ADD_P1_INST: begin
                               alu_func = `ALU_ADD_P1;
                               dest_reg = `DEST_REG1;
                              end
                `ADD_IMM_INST: begin
                                alu_func = `ALU_ADD;
                                dest_reg = `DEST_REG1;
                                opb_select = `ALU_OPB_IS_IMM;
                               end 
                `SUB_INST: begin
                            
                           end
                `SUB_M1_INST: begin
                              end
                `SUB_IMM_INST: begin
                               end
                `AND_INST: begin
                           end
                `OR_INST: begin
                          end
                `XOR_INST: begin
                           end
                `AND_IMM_INST: begin
                               end
                `OR_IMM_INST: begin
                              end
                `XOR_IMM_INST: begin
                               end
                `CMP_LT_INST: begin
                              end
                `CMP_GT_INST: begin
                              end
                `CMP_EQ_INST: begin
                              end
                `CMP_NE_INST: begin
                              end
                `CMP_LE_INST: begin
                              end
                `CMP_GE_INST: begin
                              end
                `SLL_INST: begin
                           end
                `SRL_INST: begin
                           end
            endcase
        end
    end
    
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
              mem_op,
              valid_inst
              );

    integer i;
    //Inputs
    input         clock;
    input         reset;
    input         valid       [1:0];
    input [127:0] inst_bundle [1:0]; // The six incoming instructions in their bundles
    input         mem_full    [1:0]; // What mem units currently have an operation
            
    //Outputs
    output [40:0] expanded_insts                  [5:0]; // The six expanded instructions
    output  [6:0] rd_idx_expanded [`INT_READ_PORTS-1:0];
    output  [6:0] dest_registers                  [3:0];
    output  [4:0] alu_funcs                       [3:0];
    output  [1:0] gpOpselect                      [7:0];
    output  [1:0] mem_op                          [1:0];
    output        valid_inst                      [5:0];
    
    // Register operands
    wire [6:0] r1_idx [5:0];
    wire [6:0] r2_idx [5:0];
    wire [6:0] r3_idx [5:0];
    
    assign r1_idx[0] = inst_bundle[0][17:11];
    assign r1_idx[1] = inst_bundle[0][58:52];
    assign r1_idx[2] = inst_bundle[0][99:93];
    assign r1_idx[3] = inst_bundle[1][17:11];
    assign r1_idx[4] = inst_bundle[1][58:52];
    assign r1_idx[5] = inst_bundle[1][99:93];
    
    assign r2_idx[0] = inst_bundle[0][24:18];
    assign r2_idx[1] = inst_bundle[0][66:59];
    assign r2_idx[2] = inst_bundle[0][106:99];
    assign r2_idx[3] = inst_bundle[1][24:18];
    assign r2_idx[4] = inst_bundle[1][66:59];
    assign r2_idx[5] = inst_bundle[1][106:99];
    
    assign r3_idx[0] = inst_bundle[0][32:25];
    assign r3_idx[1] = inst_bundle[0][74:67];
    assign r3_idx[2] = inst_bundle[0][114:107];
    assign r3_idx[3] = inst_bundle[1][32:25];
    assign r3_idx[4] = inst_bundle[1][74:67];
    assign r3_idx[5] = inst_bundle[1][114:107];
    
    assign expanded_insts[0] = inst_bundle[0][45:5];
    assign expanded_insts[1] = inst_bundle[0][86:46];
    assign expanded_insts[2] = inst_bundle[0][127:87];
    assign expanded_insts[3] = inst_bundle[1][45:5];
    assign expanded_insts[4] = inst_bundle[1][86:46];
    assign expanded_insts[5] = inst_bundle[1][127:87];
    
    single_decoder dec0(
                        .inst(inst_bundle[0][45:5]),
                        .valid(valid[0]),
                        .opa_select(),
                        .opb_select(),
                        .alu_func(),
                        .dest_reg(),
                        .mem_op(),
                        .valid_inst()
                        );
    single_decoder dec1(
                        .inst(inst_bundle[0][86:46]),
                        .valid(valid[0]),
                        .opa_select(),
                        .opb_select(),
                        .alu_func(),
                        .dest_reg(),
                        .mem_op(),
                        .valid_inst()
                        );
    single_decoder dec2(
                        .inst(inst_bundle[0][127:87]),
                        .valid(valid[0]),
                        .opa_select(),
                        .opb_select(),
                        .alu_func(),
                        .dest_reg(),
                        .mem_op(),
                        .valid_inst()
                        );
    always @* begin
        
    end
    
endmodule