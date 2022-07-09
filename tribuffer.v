`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:29:12 06/29/2022 
// Design Name: 
// Module Name:    tribuffer 
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
module tribuffer #(parameter SIZE = 16)(
    input [SIZE-1:0] in,
    input en,
    output [SIZE-1:0] out
    );
	assign out = en ? in : {SIZE{1'bz}};

endmodule
