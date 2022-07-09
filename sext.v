`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:57:51 07/09/2022 
// Design Name: 
// Module Name:    sext 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sext #(parameter INSIZE = 4, OUTSIZE = 16) (
    input [INSIZE - 1:0] in,
    output [OUTSIZE - 1:0] out
    );
	assign out [OUTSIZE - 1 : INSIZE] = {(OUTSIZE - INSIZE) {1'b0} };
	assign out [INSIZE-1 : 0] = in;

endmodule
