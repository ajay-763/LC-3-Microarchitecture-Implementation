`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:27:58 06/28/2022 
// Design Name: 
// Module Name:    mux 
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
module mux #(
		parameter INSIZE=2, SELSIZE=1, DATASIZE = 16
	)
	(
    input [DATASIZE*INSIZE -1:0] in,
    output reg [DATASIZE - 1:0] out,
    input [SELSIZE-1:0] sel
    );
	 always @(in , sel)begin
		out = in[(sel+1)*DATASIZE-1:sel*DATASIZE];
	 end

endmodule
