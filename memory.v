`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:00:56 07/09/2022 
// Design Name: 
// Module Name:    memory 
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
module memory #(parameter ADDR_SIZE = 16, DATA_SIZE = 16)(
    input [DATA_SIZE-1:0] in,
    input [ADDR_SIZE-1:0] addr,
    input en,
    input ctrl,
    output reg [DATA_SIZE-1:0] out
    );
	reg [DATA_SIZE - 1 : 0] mem [0 : 2**4];
	always @(in, addr, en, ctrl) begin
		if(en == 1'b1)begin
			if(ctrl == 1'b0)begin
				out = mem [addr];
			end
			else begin
				mem [addr] = in;
			end
		end
	end

endmodule
