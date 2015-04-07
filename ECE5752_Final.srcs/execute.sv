`timescale 1ns / 100ps

module execute (// Inputs
                clock,
                reset,
                inst,
                gpRegs,
                alu_funcs,
                gpOpselect,
                
                // Outputs
                gpResults
                );
                
    input           clock;
    input           reset;
    input [31:0]    inst        [5:0];
    input [63:0]    gpRegs      [7:0];
    input  [4:0]    alu_funcs   [3:0];
    input  [1:0]    gpOpselect  [7:0];
    
    output [63:0]   gpResults   [3:0];
    
    reg [63:0] alu_op_mux_out [3:0];
    
    wire [63:0] alu_imm [1:0];
    
    genvar 	 i;
    
    generate
        for (i=0; i < 2; i=i+1) begin:ALU_imm
            assign alu_imm[i] = {{57{inst[32]}}, inst[i][19:13]};
        end
    endgenerate
            
    
    //
    // ALU opA mux
    //
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
    
    //
    // ALU opB mux
    //
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
    
endmodule