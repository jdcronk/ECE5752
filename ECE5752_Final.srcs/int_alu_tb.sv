`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2015 09:47:11 PM
// Design Name: 
// Module Name: int_alu_tb
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


module int_alu_tb;
    integer i;
    reg clock;
    
    reg  [63:0] opa;
    reg  [63:0] opb;
    reg   [4:0] func;
    
    wire [63:0] result;
    
    integer_alu TEST_ALU(//Inputs
                         .opa(opa),
                         .opb(opb),
                         .func(func),
                         // Output
                         .result(result)
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
    
        // Pulse the reset signal
        $display("@@\n@@\n@@  %t  Asserting blahblahSystem reset......", $realtime);
  
        @(posedge clock);
        //@(posedge clock);
    
        @(posedge clock);
        @(posedge clock);
        `SD;
        // This reset is at an odd time to avoid the pos & neg clock edges
    
        $display("@@  %t  Deasserting System reset......\n@@\n@@", $realtime);
        @(posedge clock);
        opa = 25;
        opb = 20;
        for(i = 0; i < 15; i = i + 1)begin:ALU
           func = i;
           @(posedge clock); 
        end
    end
    
endmodule
