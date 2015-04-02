`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2015 09:18:04 PM
// Design Name: 
// Module Name: integer_alu
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


module integer_alu(//Inputs
                   opa,
                   opb,
                   func,
                   // Output
                   result
                   );
    input  [63:0] opa;
    input  [63:0] opb;
    input   [4:0] func;
    
    output [63:0] result;
    
    reg [63:0] result;
    
    always @*
    begin
        case (func)
            `ALU_ADD:      result = opa + opb;
            `ALU_ADD_P1:   result = opa + opb + 1;
            default:       result = 64'hdeadbeefdeadbeef;
        endcase
    end
endmodule
