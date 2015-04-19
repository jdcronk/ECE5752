`timescale 1ns / 100ps

`define ADD_R0_R1_R2_1 41'b10000001_000000_0000010_0000001_0000000_000000
`define ADD_R3_R3_R3_1 41'b10000001_000000_0000011_0000011_0000011_000000
`define ADD_R0_R0_R0   41'b10000000_000000_0000000_0000000_0000000_000000

module back_end_tb;

    reg         clock;  // System Clock
    reg         reset;  // System Reset
    reg  [31:0] clock_count;
    reg [127:0] inst_bundle  [1:0]; // The six incoming instructions in their bundles
    reg         valid        [1:0];
    
    wire        stall_buffer [1:0];
    wire [63:0] cdb_data     [3:0];

    back_end be0(
	       	     .clock(clock),
		         .reset(reset),
		         .inst_bundle(inst_bundle),
		         .valid(valid),
		         .stall_buffer(stall_buffer),
		         .cdb_data(cdb_data)
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
        @(posedge clock);
        /*
        `SD;
        inst_bundle[0] = {`NOOP_INST,`NOOP_INST,`NOOP_INST,5'b00000};
        @(posedge clock);
        inst_bundle[0][86:46] = `ADD_R0_R1_R2_1;
        inst_bundle[0][127:87] = `ADD_R3_R3_R3_1;
        valid[0]             = 1'b1;
        @(posedge clock);
        valid[0]             = 1'b0;
        @(posedge clock);
        valid[0]             = 1'b0;
        @(posedge clock);
        valid[0]             = 1'b0;
        @(posedge clock);
        valid[0]             = 1'b0;
        @(posedge clock);
        inst_bundle[0][86:46] = `ADD_R0_R0_R0;
        valid[0]             = 1'b1;
        @(posedge clock);
        valid[0]             = 1'b0;
        */
    end		
    
    always @(posedge clock)
    begin
        if (reset) begin
            inst_bundle[0] <= `SD {`NOOP_INST,`NOOP_INST,`NOOP_INST,5'b00000};
            inst_bundle[1] <= `SD {`NOOP_INST,`NOOP_INST,`NOOP_INST,5'b00000};
            valid[0]       <= `SD 0;
            valid[1]       <= `SD 0; 
            clock_count    <= `SD 0;
        end
        else begin
            if (clock_count == 0) begin
                inst_bundle[0][86:46]  <= `SD `ADD_R0_R1_R2_1;
                inst_bundle[0][127:87] <= `SD `ADD_R3_R3_R3_1;
                inst_bundle[1]         <= `SD {`NOOP_INST,`NOOP_INST,`NOOP_INST,5'b00000};
                valid[0]               <= `SD 1;
                valid[1]               <= `SD 0;
            end
            else if (clock_count == 1) begin
                valid[0] <= `SD 0;
                valid[1] <= `SD 0;
            end
            else begin
                inst_bundle[0] <= `SD {`NOOP_INST,`NOOP_INST,`NOOP_INST,5'b00000};
                inst_bundle[1] <= `SD {`NOOP_INST,`NOOP_INST,`NOOP_INST,5'b00000};
                valid[0]       <= `SD 0;
                valid[1]       <= `SD 0; 
            end
            
            clock_count <= `SD (clock_count + 1);
            reset       <= `SD 0;
        end
    end         
endmodule
