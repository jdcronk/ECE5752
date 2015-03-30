/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  regfile.v                                           //
//                                                                     //
//  Description :  This module creates the Regfile                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////


`timescale 1ns/100ps


module regfile_integer(rda_idx, rda_out,                // read port A
		       rdb_idx, rdb_out,                // read port B
		       rdc_idx, rdc_out,                // read port C
		       rdd_idx, rdd_out,                // read port D
		       rde_idx, rde_out,                // read port E
		       rdf_idx, rdf_out,                // read port F
		       rdg_idx, rdg_out,                // read port G
		       rdh_idx, rdh_out,                // read port H
		       wra_idx, wra_data, wra_en,       // write port A
		       wrb_idx, wrb_data, wrb_en,       // write port B
		       wrc_idx, wrc_data, wrc_en,       // write port C
		       wrd_idx, wrd_data, wrd_en,       // write port D
		       wre_idx, wre_data, wre_en,       // write port E
		       wrf_idx, wrf_data, wrf_en,       // write port F
		       wr_clk);

   input [4:0]   rda_idx, rdb_idx, rdc_idx, rdd_idx,
		 rde_idx, rdf_idx, rdg_idx, rdh_idx;
   input [4:0] 	 wra_idx, wrb_idx, wrc_idx,
		 wrd_idx, wre_idx, wrf_idx;
   input [63:0]  wra_data, wrb_data, wrc_data,
		 wrd_data, wre_data, wrf_data;
   input 	 wra_en, wrb_en, wrc_en,
		 wrd_en, wre_en, wrf_en;
   input 	 wr_clk;

   output [63:0] rda_out, rdb_out, rdc_out, rdd_out,
		 rde_out, rdf_out, rdg_out, rdh_out;
   
   reg [63:0] 	 rda_out, rdb_out, rdc_out, rdd_out,
		 rde_out, rdf_out, rdg_out, rdh_out;
   reg [63:0] 	 registers[31:0];   // 32, 64-bit Registers

   wire [63:0] 	 rda_reg = registers[rda_idx];
   wire [63:0] 	 rdb_reg = registers[rdb_idx];
   wire [63:0] 	 rdc_reg = registers[rdc_idx];
   wire [63:0] 	 rdd_reg = registers[rdd_idx];
   wire [63:0] 	 rde_reg = registers[rde_idx];
   wire [63:0] 	 rdf_reg = registers[rdf_idx];
   wire [63:0] 	 rdg_reg = registers[rdg_idx];
   wire [63:0] 	 rdh_reg = registers[rdh_idx];

   //
   // Read port A
   //
   always @*
     if (rda_idx == `ZERO_REG)
       rda_out = 0;
     else if (wr_en && (wr_idx == rda_idx))
       rda_out = wr_data;  // internal forwarding
     else
       rda_out = rda_reg;

   //
   // Read port B
   //
   always @*
     if (rdb_idx == `ZERO_REG)
       rdb_out = 0;
     else if (wr_en && (wr_idx == rdb_idx))
       rdb_out = wr_data;  // internal forwarding
     else
       rdb_out = rdb_reg;

   //
   // Write port A
   //
   always @(posedge wr_clk)
     if (wra_en)
       begin
	  registers[wra_idx] <= `SD wra_data;
       end

endmodule // regfile
