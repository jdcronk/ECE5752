`timescale 1ns/100ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joshua Cronk
// Design Name: Nexus VLIW Core
// Module Name: cdb
//////////////////////////////////////////////////////////////////////////////////

module cdb(//Inputs
           clock,
           reset,
           alu_valid,
           alu_result,
           mem_valid,
           mem_result,
           alu_dest,
           mem_dest,
           
           //Outputs
           CDB_en,
           CDB_value,
           CDB_dest
           );
    
    integer i;
    input        clock;
    input        reset;
    input        alu_valid  [3:0];
    input [63:0] alu_result [3:0];
    input        mem_valid  [1:0];
    input [63:0] mem_result [1:0];
    input  [6:0] alu_dest   [3:0];
    input  [6:0] mem_dest   [1:0];
    
    output reg        CDB_en    [3:0];
    output reg [63:0] CDB_value [3:0];
    output reg  [6:0] CDB_dest  [3:0];
    
    always @(posedge clock) begin
        if (reset) begin
            for (i = 0; i < 4; i = i + 1) begin:CDB_reset
                CDB_en[i]    <= `SD 0;
                CDB_value[i] <= `SD 0;
                CDB_dest[i]  <= `SD 0;
            end
        end
        else begin
            for (i = 0; i < 2; i = i + 1) begin:CDB_assign_alu
                if (alu_valid[i]) begin
                    CDB_en[i]    <= `SD 1;
                    CDB_value[i] <= `SD alu_result[i];
                    CDB_dest[i]  <= `SD alu_dest[i];
                end
                else begin
                    CDB_en[i]    <= `SD 0;
                    CDB_value[i] <= `SD 0;
                    CDB_dest[i]  <= `SD 0;    
                end
            end
            
            for (i = 0; i < 2; i = i + 1) begin:CDB_assign_mem
                if (alu_valid[i+2]) begin
                    CDB_en[i+2]    <= `SD 1;
                    CDB_value[i+2] <= `SD alu_result[i+2];
                    CDB_dest[i+2]  <= `SD alu_dest[i+2];
                end
                else if (mem_valid[i]) begin
                    CDB_en[i+2]    <= `SD 1;
                    CDB_value[i+2] <= `SD mem_result[i];
                    CDB_dest[i+2]  <= `SD mem_dest[i];
                end
                else begin
                    CDB_en[i+2]    <= `SD 0;
                    CDB_value[i+2] <= `SD 0;
                    CDB_dest[i+2]  <= `SD 0;    
                end
            end
        end
    end
endmodule