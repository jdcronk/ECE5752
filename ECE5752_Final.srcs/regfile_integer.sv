`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joshua Cronk
// Design Name: Nexus VLIW Core
// Module Name: regfile_integer
//////////////////////////////////////////////////////////////////////////////////

module regfile_integer(rd_idx, rd_out,         // read ports
		               wr_idx, wr_data, wr_en, // write ports
		               wr_clk
		               );

    input  [6:0]    rd_idx   [`INT_READ_PORTS-1:0]; // 8 read ports
    input  [6:0]    wr_idx  [`INT_WRITE_PORTS-1:0]; // 4 write ports
    input [63:0]    wr_data [`INT_WRITE_PORTS-1:0]; // data for the write ports
    input 	        wr_en   [`INT_WRITE_PORTS-1:0]; // write enable bits for the write ports
    input 	        wr_clk;
    
    output [63:0] rd_out[`INT_READ_PORTS-1:0];
    
    reg [63:0] 	 rd_out     [`INT_READ_PORTS-1:0];
    reg [63:0] 	 registers    [`NUM_INT_REGS-1:0];   // 64-bit Registers
    
    wire [63:0] rd_reg[`INT_READ_PORTS-1:0];
    
    genvar 	 i, y;
    
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
                else if (wr_en[3] && (wr_idx[3] == rd_idx[i]))
                    rd_out[i] = wr_data[3];  // internal forwarding
                else if (wr_en[2] && (wr_idx[2] == rd_idx[i]))
                    rd_out[i] = wr_data[2];  // internal forwarding
                else if (wr_en[1] && (wr_idx[1] == rd_idx[i]))
                    rd_out[i] = wr_data[1];  // internal forwarding
                else if (wr_en[0] && (wr_idx[0] == rd_idx[i]))
                    rd_out[i] = wr_data[0];  // internal forwarding
                else
                    rd_out[i] = rd_reg[i];
        end
    endgenerate
    
    always @(posedge wr_clk)
    begin
        if (wr_en[0])
        begin
            if (((wr_en[1] && (wr_idx[0] != wr_idx[1])) || !wr_en[1]) &&
                ((wr_en[2] && (wr_idx[0] != wr_idx[2])) || !wr_en[2]) &&
                ((wr_en[3] && (wr_idx[0] != wr_idx[3])) || !wr_en[3]))
            begin
                registers[wr_idx[0]] <= `SD wr_data[0];
            end
        end
        if (wr_en[1])
        begin
            if (((wr_en[2] && (wr_idx[1] != wr_idx[2])) || !wr_en[2]) &&
                ((wr_en[3] && (wr_idx[1] != wr_idx[3])) || !wr_en[3]))
            begin
                registers[wr_idx[1]] <= `SD wr_data[1];
            end
        end
        if (wr_en[2])
        begin
            if ((wr_en[3] && (wr_idx[2] != wr_idx[3])) || !wr_en[3])
            begin
                registers[wr_idx[2]] <= `SD wr_data[2];
            end
        end        
        if (wr_en[3])
        begin
            registers[wr_idx[3]] <= `SD wr_data[3];
        end                                
    end
endmodule // regfile
