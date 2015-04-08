`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joshua Cronk
// Design Name: Nexus VLIW Core
// Module Name: back_end
//////////////////////////////////////////////////////////////////////////////////


module back_end( //Inputs
		         clock,
		         reset
		        );
    // Inputs
    input clock;  // System Clock
    input reset;  // System Reset
    
    

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
        
    end
    
    ////////////////////////////////////////////////////
    // ~ Register Read Stage ~
    // - This stage will read the correct data for each
    //   execute unit
    ////////////////////////////////////////////////////
    regfile_integer REG_INT (
                             .rd_idx(), 
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
