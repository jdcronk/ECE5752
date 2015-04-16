`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joshua Cronk
// Design Name: Nexus VLIW Core
// Module Name: execute
//////////////////////////////////////////////////////////////////////////////////

module execute (// Inputs
                clock,
                reset,
                inst,
                gpRegs,
                alu_funcs,
                gpOpselect,
                mem_dest,
                mem_op,
                Dcache_data,
                Dcache_valid,
                                
                // Outputs
                gpResults,
                valid,
                mem_full,
                proc2Dcache_address,
                proc2Dcache_value,
                proc2Dcache_command,
                mem_retire_en,
                mem_retire_value,
                mem_retire_reg
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
    input [40:0]    inst        [5:0];
    ////////////////////////////////////////////
    // 8 Register values will come in
    // Assignments:
    //       0 -> ALU 0 OpA
    //       1 -> ALU 0 OpB
    //       2 -> ALU 1 OpA
    //       3 -> ALU 1 OpB
    //       4 -> MEM ALU 0 OpA
    //       5 -> MEM ALU 0 OpB
    //       6 -> MEM ALU 1 OpA
    //       7 -> MEM ALU 1 OpB
    input [63:0]    gpRegs       [7:0];
    input  [4:0]    alu_funcs    [3:0];
    input  [1:0]    gpOpselect   [7:0];
    input  [6:0]    mem_dest     [1:0];
    input  [1:0]    mem_op       [1:0];
    input [63:0]    Dcache_data  [1:0];
    input           Dcache_valid [1:0];
    
    output [63:0]   gpResults           [3:0];
    output          valid               [3:0];
    output          mem_full            [1:0];
    output [63:0]   proc2Dcache_address [1:0];
    output [63:0]   proc2Dcache_value   [1:0];
    output  [1:0]   proc2Dcache_command [1:0];
    output          mem_retire_en       [1:0];
    output [63:0]   mem_retire_value    [1:0];
    output  [6:0]   mem_retire_reg      [1:0];
    
    reg [63:0] alu_op_mux_out [3:0];
    reg [63:0] mem_op_mux_out [3:0];
    
    wire [63:0] alu_imm     [1:0];
    wire [63:0] mem_alu_imm [1:0];
    
    genvar 	 i;
    
    generate
        for (i=0; i < 2; i=i+1) begin:ALU_imm
            assign alu_imm[i] = {{57{inst[i][32]}}, inst[i][19:13]};
        end
    endgenerate
    
    generate
        for (i=0; i < 2; i=i+1) begin:ALU_mem_imm
            assign mem_alu_imm[i] = {{57{inst[i+2][32]}}, inst[i+2][19:13]};
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
    // MEM ALU opA mux
    ////////////////////////////////////////////////////
    generate
        for (i=4; i < 8 ; i=i+2) begin:MEM_ALU_opA
            always @*
            begin
                case (gpOpselect[i])
                    `ALU_OPA_IS_REGA: mem_op_mux_out[i - 4] = gpRegs[i];
                endcase
            end
        end
    endgenerate        
 
    ////////////////////////////////////////////////////
    // MEM ALU opB mux
    ////////////////////////////////////////////////////
    generate
        for (i=5; i < 8 ; i=i+2) begin:MEM_ALU_opB
            always @*
            begin
                case (gpOpselect[i])
                    `ALU_OPB_IS_REGB: mem_op_mux_out[i - 4] = gpRegs[i];
                    `ALU_OPB_IS_IMM:  mem_op_mux_out[i - 4] = mem_alu_imm[i >> 1];
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
                      .regA(mem_op_mux_out[0]),
                      .regB(mem_op_mux_out[1]),
                      .regC(mem_dest[0]),
                      .mem_op(mem_op[0]),
                      .alu_func(alu_funcs[2]),
                      .Dcache_data(Dcache_data[0]),
                      .Dcache_valid(Dcache_valid[0]),
                      .proc2Dcache_address(proc2Dcache_address[0]),
                      .proc2Dcache_value(proc2Dcache_value[0]),
                      .proc2Dcache_command(proc2Dcache_command[0]),
                      .mem_retire_en(mem_retire_en[0]),
                      .mem_retire_value(mem_retire_value[0]),
                      .mem_retire_reg(mem_retire_reg[0]),
                      .result(gpResults[2]),
                      .mem_full(mem_full[0]),
                      .alu_valid(valid[2])
                      );
    ////////////////////////////////////////////////////
    // Mem ALU 0 (can be used as a normal ALU)
    ////////////////////////////////////////////////////
    mem_alu mem_alu_1(
                      .clock(clock),
                      .reset(reset),
                      .inst(inst[3]),
                      .regA(mem_op_mux_out[2]),
                      .regB(mem_op_mux_out[3]),
                      .regC(mem_dest[1]),
                      .mem_op(mem_op[1]),
                      .alu_func(alu_funcs[3]),
                      .Dcache_data(Dcache_data[1]),
                      .Dcache_valid(Dcache_valid[1]),
                      .proc2Dcache_address(proc2Dcache_address[1]),
                      .proc2Dcache_value(proc2Dcache_value[1]),
                      .proc2Dcache_command(proc2Dcache_command[1]),
                      .mem_retire_en(mem_retire_en[1]),
                      .mem_retire_value(mem_retire_value[1]),
                      .mem_retire_reg(mem_retire_reg[1]),
                      .result(gpResults[3]),
                      .mem_full(mem_full[1]),
                      .alu_valid(valid[3])
                      );   
endmodule