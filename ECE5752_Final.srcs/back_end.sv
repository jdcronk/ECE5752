`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joshua Cronk
// Design Name: Nexus VLIW Core
// Module Name: back_end
//////////////////////////////////////////////////////////////////////////////////

module back_end( //Inputs
		         clock,
		         reset,
		         inst_bundle,
		         valid,
		         
		         //Outputs
		         stall_buffer,
		         cdb_data
		        );
    integer i;
    		        
    // Inputs
    input         clock;  // System Clock
    input         reset;  // System Reset
    input [127:0] inst_bundle  [1:0]; // The six incoming instructions in their bundles
    input         valid        [1:0];
    // Outputs
    output        stall_buffer [1:0]; // Stall the buffer if inst is waiting
    output [63:0] cdb_data     [3:0];
    
    // Internal Registers
    // Registers from expand to the regsiter read
    reg [40:0] exp_reg_inst_bundle                 [5:0];
    reg  [6:0] exp_reg_rd_idx      [`INT_READ_PORTS-1:0];
    reg  [6:0] exp_reg_dest_reg                    [3:0];
    reg  [4:0] exp_reg_alu_funcs                   [3:0];
    reg  [1:0] exp_reg_gpOpselect                  [7:0];
    reg  [1:0] exp_reg_mem_op                      [1:0]; 
    
    // Registers from the register read to execute
    reg [40:0] reg_ext_inst_bundle                 [5:0];
    reg [63:0] reg_ext_rd_out      [`INT_READ_PORTS-1:0];
    reg  [6:0] reg_ext_dest_regs                   [3:0];
    reg  [4:0] reg_ext_alu_funcs                   [3:0];
    reg  [1:0] reg_ext_gpOpselect                  [7:0];
    reg  [1:0] reg_ext_mem_op                      [1:0];     
    
    //Internal Wires
    wire reset_signal;
    
    // Wires from Expand
    wire [40:0] inst_bundle_expanded                 [5:0];
    wire  [6:0] rd_idx_expanded      [`INT_READ_PORTS-1:0];
    wire  [6:0] dest_registers                       [3:0];
    wire  [4:0] exp_alu_funcs                        [3:0];
    wire  [1:0] exp_gpOpselect                       [7:0];
    wire  [1:0] exp_mem_op                           [1:0]; 
    
    // Wires from register read
    wire [63:0] rd_reg_out      [`INT_READ_PORTS-1:0];
    
    // Wires from execute
    wire [63:0] ex_alu_results  [3:0];
    wire        ex_alu_valid    [3:0];
    wire [63:0] ex_mem_results  [1:0];
    wire        ex_mem_valid    [1:0];
    wire  [6:0] ex_mem_reg_dest [1:0];
    wire        ex_mem_full     [1:0]; 
    
    // Wires from CDB
    wire        CDB_reg_en    [3:0];
    wire [63:0] CDB_reg_value [3:0];
    wire  [6:0] CDB_reg_dest  [3:0];
    
    assign reset_signal = reset;
    assign cdb_data = CDB_reg_value;

    ////////////////////////////////////////////////////
    // ~ Expand Stage ~
    // - This stage will assign the instructions to the
    //   correct ex unit
    ////////////////////////////////////////////////////
    expand expand_stage (
                         .clock(clock),
                         .reset(reset),
                         .valid(valid),
                         .inst_bundle(inst_bundle),
                         .mem_full(ex_mem_full),
                         .expanded_insts(inst_bundle_expanded),
                         .rd_idx_expanded(rd_idx_expanded),
                         .dest_registers(dest_registers),
                         .alu_funcs(exp_alu_funcs),
                         .gpOpselect(exp_gpOpselect),
                         .mem_op(exp_mem_op),
                         .valid_inst(),
                         .stall_buffer(stall_buffer)
                         );
    
    ////////////////////////////////////////////////////
    // ~ Expand Stage/Register Read Stage 
    //                           Pipeline Register~
    ////////////////////////////////////////////////////
    always @(posedge clock)
    begin
        if(reset_signal)
        begin
            for (i = 0; i < 6; i = i + 1)
            begin
                exp_reg_inst_bundle[i] <= `SD `NOOP_INST;
            end
            for (i = 0; i < `INT_READ_PORTS; i = i + 1)
            begin
                exp_reg_rd_idx[i]     <= `SD 0;
                exp_reg_gpOpselect[i] <= `SD 0;
            end
            for (i = 0; i < 4; i = i + 1)
            begin
                exp_reg_dest_reg[i]  <= `SD 0;
                exp_reg_alu_funcs[i] <= `SD `NOOP_INST;
            end
            for (i = 0; i < 1; i = i + 1)
            begin
                exp_reg_mem_op[i] <= `SD `BUS_NONE;
            end
        end
        else
        begin
            exp_reg_inst_bundle <= `SD inst_bundle_expanded;
            exp_reg_rd_idx      <= `SD rd_idx_expanded;
            exp_reg_dest_reg    <= `SD dest_registers; 
            exp_reg_alu_funcs   <= `SD exp_alu_funcs;
            exp_reg_gpOpselect  <= `SD exp_gpOpselect;
            exp_reg_mem_op      <= `SD exp_mem_op;
        end
    end
    
    ////////////////////////////////////////////////////
    // ~ Register Read Stage ~
    // - This stage will read the correct data for each
    //   execute unit
    ////////////////////////////////////////////////////
    regfile_integer REG_INT (
                             .rd_idx(exp_reg_rd_idx), 
                             .rd_out(rd_reg_out),
                             .wr_idx(CDB_reg_dest), 
                             .wr_data(CDB_reg_value), 
                             .wr_en(CDB_reg_en),
                             .reset(reset),
                             .wr_clk(clock)
	                         );
	                         
    ////////////////////////////////////////////////////
    // ~ Register Read Stage/Execute Stage 
    //                           Pipeline Register~
    ////////////////////////////////////////////////////
    always @(posedge clock)
    begin
        if(reset_signal)
            begin
                for (i = 0; i < 6; i = i + 1)
                begin
                    reg_ext_inst_bundle[i] <= `SD `NOOP_INST;
                end
                for (i = 0; i < `INT_READ_PORTS; i = i + 1)
                begin
                    reg_ext_rd_out[i]     <= `SD 0;
                    reg_ext_gpOpselect[i] <= `SD 0;
                end
                for (i = 0; i < 4; i = i + 1)
                begin
                    reg_ext_dest_regs[i] <= `SD 0;
                    reg_ext_alu_funcs[i] <= `SD `NOOP_INST;
                end
                for (i = 0; i < 1; i = i + 1)
                begin
                    reg_ext_mem_op[i] <= `SD `BUS_NONE;
                end
            end
            else
            begin
                reg_ext_inst_bundle <= `SD exp_reg_inst_bundle;
                reg_ext_rd_out      <= `SD rd_reg_out;
                reg_ext_dest_regs   <= `SD exp_reg_dest_reg;
                reg_ext_alu_funcs   <= `SD exp_reg_alu_funcs;
                reg_ext_gpOpselect  <= `SD exp_reg_gpOpselect;
                reg_ext_mem_op      <= `SD exp_reg_mem_op;
            end
    end
     
    ////////////////////////////////////////////////////
    // ~ Execute Stage ~
    // - This stage will execute the instructions
    ////////////////////////////////////////////////////
    execute execute_stage(
                          .clock(clock),
                          .reset(reset),
                          .inst(reg_ext_inst_bundle),
                          .gpRegs(reg_ext_rd_out),
                          .alu_funcs(reg_ext_alu_funcs),
                          .gpOpselect(reg_ext_gpOpselect),
                          .mem_dest(reg_ext_dest_regs[3:2]),
                          .mem_op(reg_ext_mem_op),
                          .Dcache_data(),
                          .Dcache_valid(),
                          .gpResults(ex_alu_results),
                          .valid(ex_alu_valid),
                          .mem_full(ex_mem_full),
                          .proc2Dcache_address(),
                          .proc2Dcache_value(),
                          .proc2Dcache_command(),
                          .mem_retire_en(ex_mem_valid),
                          .mem_retire_value(ex_mem_results),
                          .mem_retire_reg(ex_mem_reg_dest)
                          );
                          
    ////////////////////////////////////////////////////
    // ~ Common Data Bus (CDB) ~
    // - This will move the data to the needed registers
    ////////////////////////////////////////////////////
    cdb cdb_0(
              .clock(clock),
              .reset(reset),
              .alu_valid(ex_alu_valid),
              .alu_result(ex_alu_results),
              .mem_valid(ex_mem_valid),
              .mem_result(ex_mem_results),
              .alu_dest(reg_ext_dest_regs),
              .mem_dest(ex_mem_reg_dest),  
              .CDB_en(CDB_reg_en),
              .CDB_value(CDB_reg_value),
              .CDB_dest(CDB_reg_dest)
              );
endmodule
