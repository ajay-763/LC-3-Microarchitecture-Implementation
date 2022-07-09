`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:12:45 06/30/2022 
// Design Name: 
// Module Name:    d_latch 
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
module d_latch #(parameter SIZE = 16)(
    input [SIZE-1:0] in,
    input load,
    output reg [SIZE-1:0] out
    );
	always @(load,in)
		if (load == 1'b1)
			out = in;

endmodule
