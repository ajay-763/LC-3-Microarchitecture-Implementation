`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:50:42 07/09/2022 
// Design Name: 
// Module Name:    alu 
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
module alu(
    input [15:0] in1,
    input [15:0] in2,
    input [1:0] ctrl,
    output reg [15:0] out
    );
	always @(in1, in2, ctrl)begin
		case (ctrl)
			2'b00 : out = in1 + in2;
			2'b01 : out = in1 & in2;
			2'b10 : out = ~ in1;
			2'b11 : out = in1;
		endcase
	end

endmodule
