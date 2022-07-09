`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:27:31 07/09/2022 
// Design Name: 
// Module Name:    dmux 
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
module dmux #(
		parameter OUTSIZE=2, SELSIZE=1, DATASIZE = 16
	)
	(
    input [DATASIZE - 1:0] in,
    output reg [DATASIZE - 1:0] out [0:OUTSIZE - 1],
    input [SELSIZE-1:0] sel
    );
	always @(in, sel)begin
		out = {OUTSIZE{16'h0000}};
		out[sel] = in;
	end

endmodule