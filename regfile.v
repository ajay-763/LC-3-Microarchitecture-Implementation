`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:58:32 06/29/2022 
// Design Name: 
// Module Name:    regfile 
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
module regfile(
    input [15:0] in,
    input load,
    input [2:0] dr,
    input [2:0] sr1,
    input [2:0] sr2,
    output [15:0] out1,
    output [15:0] out2
    );
	reg [15:0] mem [0:7];
	
	assign out1 = mem[sr1];
	assign out2 = mem[sr2];
	
	always @(load)
		if(load==1'b1)
			mem[dr] = in;

endmodule
