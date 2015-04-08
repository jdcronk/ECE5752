/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  regfile.v                                           //
//                                                                     //
//  Description :  This module creates the Regfile                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////


`timescale 1ns/100ps


module regfile_integer(rd_idx, rd_out,         // read ports
		               wr_idx, wr_data, wr_en, // write ports
		               wr_clk
		               );

    input  [4:0]    rd_idx   [`INT_READ_PORTS-1:0]; // 8 read ports
    input  [4:0]    wr_idx  [`INT_WRITE_PORTS-1:0]; // 4 write ports
    input [63:0]    wr_data [`INT_WRITE_PORTS-1:0]; // data for the write ports
    input 	        wr_en   [`INT_WRITE_PORTS-1:0]; // write enable bits for the write ports
    input 	        wr_clk;
    
    output [63:0] rd_out[`INT_READ_PORTS-1:0];
    
    reg [63:0] 	 rd_out     [`INT_READ_PORTS-1:0];
    reg [63:0] 	 registers    [`NUM_INT_REGS-1:0];   // 64-bit Registers
    
    wire [63:0] rd_reg[`INT_READ_PORTS-1:0];
    
    genvar 	 i;
    
    generate
        for (i=0; i < `INT_READ_PORTS; i=i+1) begin:READ_WIRE
            assign rd_reg[i] = registers[rd_idx[i]];
        end
    endgenerate
    
    generate
        for (i=0; i < `INT_READ_PORTS; i=i+1) begin:READ
            always @*
                if (rd_idx[i] == `ZERO_REG)
                    rd_out[i] = 0;
                else if (wr_en[0] && (wr_idx[0] == rd_idx[i]))
                    rd_out[i] = wr_data[0];  // internal forwarding
                else if (wr_en[1] && (wr_idx[1] == rd_idx[i]))
                    rd_out[i] = wr_data[1];  // internal forwarding
                else if (wr_en[2] && (wr_idx[2] == rd_idx[i]))
                    rd_out[i] = wr_data[2];  // internal forwarding
                else if (wr_en[3] && (wr_idx[3] == rd_idx[i]))
                    rd_out[i] = wr_data[3];  // internal forwarding
                else
                    rd_out[i] = rd_reg[i];
        end
    endgenerate
    
    generate
        for (i=0; i < `INT_WRITE_PORTS; i=i+1) begin:WRITE
            always @(posedge wr_clk)
                if (wr_en[i])
                begin
                    registers[wr_idx[i]] <= `SD wr_data[i];
                end
        end
    endgenerate


endmodule // regfile
