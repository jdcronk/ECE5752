`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joshua Cronk
// Design Name: Nexus VLIW Core
// Module Name: front_end
//////////////////////////////////////////////////////////////////////////////////

module front_end(//Inputs
		         clock,
		         reset,
		         //Outputs
		         inst_bundle
		         );
    // Inputs
    input clock;  // System Clock
    input reset;  // System Reset
    
    //Outpus
    output [127:0] inst_bundle [1:0]; // The six instructions going to the expand stage in their bundles
endmodule
