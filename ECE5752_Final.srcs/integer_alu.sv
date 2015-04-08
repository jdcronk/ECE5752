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
                   result,
                   valid
                   );
    input  [63:0] opa;
    input  [63:0] opb;
    input   [4:0] func;
    
    output [63:0] result;
    output        valid;
    
    reg [63:0] result;
    reg        valid;
    
    // This function computes a signed less-than operation
    function signed_lt;
        input [63:0] a, b;
    
        if (a[63] == b[63]) 
            signed_lt = (a < b); // signs match: signed compare same as unsigned
        else
            signed_lt = a[63];   // signs differ: a is smaller if neg, larger if pos
    endfunction
    
    // This function computes a signed greater-than operation
    function signed_gt;
        input [63:0] a, b;
        
        if (a[63] == b[63]) 
            signed_gt = (a > b); // signs match: signed compare same as unsigned
        else
            signed_gt = b[63];   // signs differ: b is smaller if neg, larger if pos
    endfunction
    
    always @*
    begin
        valid = 1'b1;
        case (func)
            `ALU_ADD:       result = opa + opb;
            `ALU_ADD_P1:    result = opa + opb + 1;
            `ALU_SUB:       result = opa - opb;
            `ALU_SUB_M1:    result = opa - opb - 1;
            `ALU_AND:       result = opa & opb;
            `ALU_OR:        result = opa | opb;
            `ALU_XOR:       result = opa ^ opb;
            `ALU_CMPLT:     result = { 63'd0, signed_lt(opa, opb) };
            `ALU_CMPGT:     result = { 63'd0, signed_gt(opa, opb) };
            `ALU_CMPEQ:     result = { 63'd0, opa == opb };
            `ALU_CMPNE:     result = { 63'd0, opa != opb };
            `ALU_CMPLE:     result = { 63'd0, (signed_lt(opa, opb) || (opa == opb)) };
            `ALU_CMPGE:     result = { 63'd0, (signed_gt(opa, opb) || (opa == opb)) };
            `ALU_SLL:       result = opa << opb[5:0];
            `ALU_SRL:       result = opa >> opb[5:0];
            default:        begin
                            result = 64'hdeadbeefdeadbeef;
                            valid = 1'b0;
                            end
        endcase
    end
endmodule
