`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joshua Cronk
// Design Name: Nexus VLIW Core
// Module Name: nexus_vliw
//////////////////////////////////////////////////////////////////////////////////


module nexus_vliw(//Inputs
		          clock,
		          reset
		          );
    // Inputs
    input clock;  // System Clock
    input reset;  // System Reset

    wire [127:0] inst_bundle [1:0]; // The six instructions going to the expand stage in their bundles
    
    front_end f0 (// Inputs
                  .clock  (clock),
		          .reset  (reset),
		          .inst_bundle (inst_bundle)
		          );

    back_end be0(
	       	     .clock(clock),
		         .reset(reset),
		         .inst_bundle(inst_bundle),
		         .valid(),
		         .pc(),
		         .stall_buffer(),
		         .cdb_data()
		         );
endmodule
