`timescale 1ns / 100ps

`define ADD_R0_R1_R2_1 41'b10000001_000000_0000010_0000001_0000000_000000
`define ADD_R3_R3_R3_1 41'b10000001_000000_0000011_0000011_0000011_000000
`define ADD_R0_R0_R0   41'b10000000_000000_0000000_0000000_0000000_000000
`define ADD_R2_R6_R7_1 41'b10000001_000000_0000111_0000110_0000010_000000
`define MOV_R0_5       41'b10000010_000000_0000000_0000101_0000000_000000

module back_end_tb;

    reg         clock;  // System Clock
    reg         reset;  // System Reset
    reg  [31:0] clock_count;
    reg [127:0] inst_bundle  [1:0]; // The six incoming instructions in their bundles
    reg         valid        [1:0];
    reg  [63:0] pc           [1:0]; // Program counters for the bundles
    
    wire        stall_buffer [1:0];
    wire [63:0] cdb_data     [3:0];

    back_end be0(
	       	     .clock(clock),
		         .reset(reset),
		         .inst_bundle(inst_bundle),
		         .valid(valid),
		         .pc(pc),
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
        $display("@@\n@@\n@@  %t  Asserting System reset......", $realtime);
        reset = 1'b1;
            
        @(posedge clock);
        $display("@@  %t  Deasserting System reset......\n@@\n@@", $realtime);
        `SD;
        reset = 1'b0;
    end		
    
    always @(posedge clock or posedge reset)
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
                $display("@@  %t  Loading bundle 0......", $realtime);
                inst_bundle[0][86:46]  <= `SD `ADD_R0_R1_R2_1;
                //inst_bundle[0][127:87] <= `SD `ADD_R3_R3_R3_1;
                $display("@@  %t  Loading bundle 1...... ", $realtime);
                inst_bundle[1][86:46]  <= `SD `MOV_R0_5;
                inst_bundle[1][127:87] <= `SD `ADD_R2_R6_R7_1;
                valid[0]               <= `SD 1;
                valid[1]               <= `SD 1;
            end
            else if (clock_count == 1) begin
                $display("@@  %t  Clock 1...... \n", $realtime);
                if(stall_buffer[0] == 1) begin
                    valid[0] <= `SD 1;
                end
                else begin
                    valid[0] <= `SD 0;
                end
                if(stall_buffer[1] == 1) begin
                    valid[1] <= `SD 1;
                end
                else begin
                    valid[1] <= `SD 0;
                end
            end
            else begin
                inst_bundle[0] <= `SD {`NOOP_INST,`NOOP_INST,`NOOP_INST,5'b00000};
                inst_bundle[1] <= `SD {`NOOP_INST,`NOOP_INST,`NOOP_INST,5'b00000};
                valid[0]       <= `SD 0;
                valid[1]       <= `SD 0; 
            end
            
            clock_count <= `SD (clock_count + 1);
        end
    end         
endmodule
