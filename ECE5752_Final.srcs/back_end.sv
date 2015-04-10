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
		        );
    integer i;
    		        
    // Inputs
    input        clock;  // System Clock
    input        reset;  // System Reset
    input [31:0] inst_bundle [5:0]; // The six incoming instructions
    
    // Outputs
    
    // Internal Registers
    reg [31:0] exp_reg_inst_bundle                 [5:0];
    reg  [4:0] exp_reg_rd_idx      [`INT_READ_PORTS-1:0];
    
    //Internal Wires
    wire reset_signal;
    
    // Wires from Expand
    wire [31:0] inst_bundle_expanded                 [5:0];
    wire  [4:0] rd_idx_expanded      [`INT_READ_PORTS-1:0];
    
    assign reset_signal = reset;

    ////////////////////////////////////////////////////
    // ~ Expand Stage ~
    // - This stage will assign the instructions to the
    //   correct ex unit
    ////////////////////////////////////////////////////
    expand expand_stage (
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
                             .rd_out(),
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
         
     end
     
     ////////////////////////////////////////////////////
     // ~ Execute Stage ~
     // - This stage will execute the instructions
     ////////////////////////////////////////////////////
     execute execute_stage(
                           .clock(clock),
                           .reset(reset),
                           .inst(),
                           .gpRegs(),
                           .alu_funcs(),
                           .gpOpselect(),
                           .gpResults(),
                           .valid()
                           );
endmodule
