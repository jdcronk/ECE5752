`timescale 1ns / 100ps

module back_end_tb;

    reg         clock;  // System Clock
    reg         reset;  // System Reset
    reg [127:0] inst_bundle [1:0]; // The six incoming instructions in their bundles
    reg         valid       [1:0];

    back_end be0(
	       	     .clock(clock),
		         .reset(reset),
		         .inst_bundle(inst_bundle),
		         .valid(valid)
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
        @(posedge clock);
        reset = 1'b1;
            
        @(posedge clock);
        reset = 1'b0; 
        @(posedge clock);
        `SD;
        @(posedge clock);
        inst_bundle[0][86:46] = 41'b10000001000000000010000010000000001000000;
        valid[0]             = 1'b1;
        @(posedge clock);
        valid[0]             = 1'b0;
    end		         
endmodule
