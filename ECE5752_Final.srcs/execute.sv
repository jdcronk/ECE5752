`timescale 1ns / 100ps

module execute (// Inputs
                clock,
                reset,
                inst,
                gpRegs,
                alu_funcs,
                gpOpselect,
                
                // Outputs
                gpResults,
                valid
                );
                
    input           clock;
    input           reset;
    ////////////////////////////////////////////
    // There are 6 instruction ports
    // Port assingments:
    //       0 -> ALU 0
    //       1 -> ALU 1
    //       2 -> MEM ALU 0  (LD 0)
    //       3 -> MEM ALU 1  (ST 0)
    //       4 -> BR 0
    //       5 -> BR 1
    input [31:0]    inst        [5:0];
    input [63:0]    gpRegs      [7:0];
    input  [4:0]    alu_funcs   [3:0];
    input  [1:0]    gpOpselect  [7:0];
    
    output [63:0]   gpResults   [3:0];
    output          valid       [3:0];
    
    reg [63:0] alu_op_mux_out [3:0];
    reg [63:0] mem_op_mux_out [3:0];
    
    wire [63:0] alu_imm [1:0];
    
    genvar 	 i;
    
    generate
        for (i=0; i < 2; i=i+1) begin:ALU_imm
            assign alu_imm[i] = {{57{inst[i][32]}}, inst[i][19:13]};
        end
    endgenerate
               
    ////////////////////////////////////////////////////
    // ALU opA mux
    ////////////////////////////////////////////////////
    generate
        for (i=0; i < 4; i=i+2) begin:ALU_opA
            always @*
            begin
                case (gpOpselect[i])
                    `ALU_OPA_IS_REGA: alu_op_mux_out[i] = gpRegs[i]; 
                endcase
            end
        end
    endgenerate
    
    ////////////////////////////////////////////////////
    // ALU opB mux
    ////////////////////////////////////////////////////
    generate
        for (i=1; i < 4 ; i=i+2) begin:ALU_opB
            always @*
            begin
                case (gpOpselect[i])
                    `ALU_OPB_IS_REGB: alu_op_mux_out[i] = gpRegs[i]; 
                    `ALU_OPB_IS_IMM:  alu_op_mux_out[i] = alu_imm[i >> 1];
                endcase
            end
        end
    endgenerate    
    
    ////////////////////////////////////////////////////
    // Integer ALU 0
    ////////////////////////////////////////////////////
    integer_alu int_alu0(
                         .opa(alu_op_mux_out[0]),
                         .opb(alu_op_mux_out[1]),
                         .func(alu_funcs[0]),
                         .result(gpResults[0]),
                         .valid(valid[0])
                         );
    ////////////////////////////////////////////////////
    // Integer ALU 1
    ////////////////////////////////////////////////////                         
    integer_alu int_alu1(
                         .opa(alu_op_mux_out[2]),
                         .opb(alu_op_mux_out[3]),
                         .func(alu_funcs[1]),
                         .result(gpResults[1]),
                         .valid(valid[1])
                         );
    ////////////////////////////////////////////////////
    // Mem ALU 0 (can be used as a normal ALU)
    ////////////////////////////////////////////////////
    mem_alu mem_alu_0(
                      .clock(clock),
                      .reset(reset),
                      .inst(inst[2]),
                      .regA(),
                      .regB(),
                      .regC(),
                      .mem_op(),
                      .alu_func(),
                      .valid(),
                      .Dcache_data(),
                      .Dcache_valid(),
                      .proc2Dcache_address(),
                      .proc2Dcache_value(),
                      .proc2Dcache_command(),
                      .mem_retire_en(),
                      .mem_retire_value(),
                      .mem_retire_reg(),
                      .result(),
                      .mem_full(),
                      .alu_valid()
                      );
    ////////////////////////////////////////////////////
    // Mem ALU 0 (can be used as a normal ALU)
    ////////////////////////////////////////////////////
    mem_alu mem_alu_1(
                      .clock(clock),
                      .reset(reset),
                      .inst(inst[3]),
                      .regA(),
                      .regB(),
                      .regC(),
                      .mem_op(),
                      .alu_func(),
                      .valid(),
                      .Dcache_data(),
                      .Dcache_valid(),
                      .proc2Dcache_address(),
                      .proc2Dcache_value(),
                      .proc2Dcache_command(),
                      .mem_retire_en(),
                      .mem_retire_value(),
                      .mem_retire_reg(),
                      .result(),
                      .mem_full(),
                      .alu_valid()
                      );   
endmodule