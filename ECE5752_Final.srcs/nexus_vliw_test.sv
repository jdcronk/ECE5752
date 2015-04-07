`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2015 10:14:35 PM
// Design Name: 
// Module Name: nexus_vliw_test
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


module testbench;
   reg clock;
   reg reset;

   wire [1:0]  proc2mem_command;
   wire [63:0] proc2mem_addr;
   wire [63:0] proc2mem_data;
   wire [4:0]  mem2proc_response;
   wire [63:0] mem2proc_data;
   wire [4:0]  mem2proc_tag;
   
   nexus_vliw nexus_0 ( //Inputs
			.clock(clock),
			.reset(reset)
		      );
   mem memory (// Inputs
               .clk               (clock),
               .proc2mem_command  (proc2mem_command),
               .proc2mem_addr     (proc2mem_addr),
               .proc2mem_data     (proc2mem_data),
	       
               // Outputs
               .mem2proc_response (mem2proc_response),
               .mem2proc_data     (mem2proc_data),
               .mem2proc_tag      (mem2proc_tag)
	       );

   // Generate System Clock
   always
     begin
	#(`VERILOG_CLOCK_PERIOD/2.0);
	clock = ~clock;
     end

   initial
     begin
	clock = 1'b0;
	reset = 1'b0;

	// Pulse the reset signal
	$display("@@\n@@\n@@  %t  Asserting blahblahSystem reset......", $realtime);
	reset = 1'b1;
	@(posedge clock);
	//@(posedge clock);

	
	$readmemh("program.mem", memory.unified_memory);

	@(posedge clock);
	@(posedge clock);
	`SD;
	// This reset is at an odd time to avoid the pos & neg clock edges

	reset = 1'b0;
	$display("@@  %t  Deasserting System reset......\n@@\n@@", $realtime);
     end
   
endmodule
