`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joshua Cronk
// Design Name: Nexus VLIW Core
// Module Name: back_end
//////////////////////////////////////////////////////////////////////////////////

module back_end( //Inputs
		         clock,
		         reset,
		         inst_bundle
		         
		         //Outputs
		        );
    integer i;
    		        
    // Inputs
    input         clock;  // System Clock
    input         reset;  // System Reset
    input [127:0] inst_bundle [1:0]; // The six incoming instructions in their bundles
    
    // Outputs
    
    // Internal Registers
    reg [31:0] exp_reg_inst_bundle                 [5:0];
    reg  [4:0] exp_reg_rd_idx      [`INT_READ_PORTS-1:0];
    
    reg [31:0] reg_ext_inst_bundle                 [5:0];
    reg [63:0] reg_ext_rd_out      [`INT_READ_PORTS-1:0];
    
    //Internal Wires
    wire reset_signal;
    
    // Wires from Expand
    wire [31:0] inst_bundle_expanded                 [5:0];
    wire  [4:0] rd_idx_expanded      [`INT_READ_PORTS-1:0];
    
    // Wires from register read
    wire [63:0] rd_reg_out      [`INT_READ_PORTS-1:0];
    
    assign reset_signal = reset;

    ////////////////////////////////////////////////////
    // ~ Expand Stage ~
    // - This stage will assign the instructions to the
    //   correct ex unit
    ////////////////////////////////////////////////////
    expand expand_stage (
                         .clock(clock),
                         .reset(reset),
                         .inst_bundle(inst_bundle),
                         .expanded_insts(inst_bundle_expanded)
                         );
    
    ////////////////////////////////////////////////////
    // ~ Expand Stage/Register Read Stage 
    //                           Pipeline Register~
    ////////////////////////////////////////////////////
    always @(posedge clock)
    begin
        if(reset_signal)
        begin
            for (i = 0; i < 6; i = i + 1)
            begin
                exp_reg_inst_bundle[i] <= `SD `NOOP_INST;
            end
            for (i = 0; i < `INT_READ_PORTS; i = i + 1)
            begin
                exp_reg_rd_idx[i] <= `SD 0;
            end
        end
        else
        begin
            exp_reg_inst_bundle <= `SD inst_bundle_expanded;
            exp_reg_rd_idx      <= `SD rd_idx_expanded; 
        end
    end
    
    ////////////////////////////////////////////////////
    // ~ Register Read Stage ~
    // - This stage will read the correct data for each
    //   execute unit
    ////////////////////////////////////////////////////
    regfile_integer REG_INT (
                             .rd_idx(exp_reg_rd_idx), 
                             .rd_out(rd_reg_out),
                             .wr_idx(), 
                             .wr_data(), 
                             .wr_en(),
                             .wr_clk(clock)
	                         );
	                         
    ////////////////////////////////////////////////////
    // ~ Register Read Stage/Execute Stage 
    //                           Pipeline Register~
    ////////////////////////////////////////////////////
    always @(posedge clock)
    begin
        if(reset_signal)
            begin
                for (i = 0; i < 6; i = i + 1)
                begin
                    reg_ext_inst_bundle[i] <= `SD `NOOP_INST;
                end
                for (i = 0; i < `INT_READ_PORTS; i = i + 1)
                begin
                    reg_ext_rd_out[i] <= `SD 0;
                end
            end
            else
            begin
                reg_ext_inst_bundle <= `SD exp_reg_inst_bundle;
                reg_ext_rd_out      <= `SD rd_reg_out;
            end
    end
     
    ////////////////////////////////////////////////////
    // ~ Execute Stage ~
    // - This stage will execute the instructions
    ////////////////////////////////////////////////////
    execute execute_stage(
                          .clock(clock),
                          .reset(reset),
                          .inst(reg_ext_inst_bundle),
                          .gpRegs(reg_ext_rd_out),
                          .alu_funcs(),
                          .gpOpselect(),
                          .mem_dest(),
                          .mem_op(),
                          .Dcache_data(),
                          .Dcache_valid(),
                          .gpResults(),
                          .valid(),
                          .mem_full(),
                          .proc2Dcache_address(),
                          .proc2Dcache_value(),
                          .proc2Dcache_command(),
                          .mem_retire_en(),
                          .mem_retire_value(),
                          .mem_retire_reg()
                          );
    ////////////////////////////////////////////////////
    // ~ Common Data Bus (CDB) ~
    // - This will move the data to the needed registers
    ////////////////////////////////////////////////////
    
endmodule
