`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2015 08:48:25 PM
// Design Name: 
// Module Name: nexus_vliw
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


module nexus_vliw(//Inputs
		          clock,
		          reset
		          );
   // Inputs
   input clock;  // System Clock
   input reset;  // System Reset

   front_end f0 (// Inputs
		         .clock  (clock),
		         .reset  (reset)
		         );

   back_end b0 (// Inputs
		        .clock  (clock),
		        .reset  (reset)
		        );
      
endmodule
