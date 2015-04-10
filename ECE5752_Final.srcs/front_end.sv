`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2015 10:04:08 PM
// Design Name: 
// Module Name: front_end
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
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
    output [31:0] inst_bundle [5:0]; // The six instructions going to the expand stage
endmodule
