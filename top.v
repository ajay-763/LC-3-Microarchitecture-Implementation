`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:51:09 06/30/2022 
// Design Name: 
// Module Name:    top 
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
module top #(parameter WORDSIZE = 16)(
    input [WORDSIZE-1:0] in,
    output [WORDSIZE-1:0] out
    );
	
	wire [WORDSIZE-1:0] bus; //Global bus
	
	//----------------------Instruction Register----------------------
	
	wire [WORDSIZE-1:0] instruction_in;
	wire [WORDSIZE-1:0] instruction;
	wire LD_IR;
	
	d_latch #(.SIZE(WORDSIZE)) instruction_register (.in(instruction_in), .out(instruction), .load(LD_IR));
	
	wire GATE_IR;
	
	tribuffer #(.SIZE(WORDSIZE)) bus_to_ir (.in(bus), .out(instruction_in), .en(GATE_IR));
	
	//-----------------------------Memory-----------------------------
	
	wire [WORDSIZE-1:0] mem_data_in;
	wire [WORDSIZE-1:0] mem_data_out;
	wire [WORDSIZE-1:0] mem_addr;
	wire MEM_EN, MEM_RW;
	
	memory #(.ADDR_SIZE(WORDSIZE), .DATA_SIZE(WORDSIZE)) mem (.in(mem_data_in), 
																.out(mem_data_out),
																.addr(mem_addr),
																.en(MEM_EN),
																.ctrl(MEM_RW));
	
	wire [WORDSIZE-1:0] mdr_in;
	wire [WORDSIZE-1:0] mdr_out;
	wire [WORDSIZE-1:0] mar_in;
	wire [WORDSIZE-1:0] mar_out;
	wire MDR_LD, MAR_LD, MDR_IO;
	
	d_latch #(.SIZE(WORDSIZE)) mdr (.in(mdr_in),
												.out(mdr_out),
												.load(MDR_LD));
	d_latch #(.SIZE(WORDSIZE)) mar (.in(mar_in),
												.out(mar_out),
												.load(MAR_LD));
	
	wire tsb_to_mdr, mdr_to_tsb;
	
	mux #(.INSIZE(2), .SELSIZE(1), .DATASIZE(1)) mdr_mux_in (.in({mem_out, tsb_to_mdr}),
																				.out(mdr_in),
																				.sel(MDR_IO));
																				
	dmux #(.OUTSIZE(2), .SELSIZE(1), .DATASIZE(1)) mdr_mux_out (.out({mdr_to_tsb, mem_in}),
																				.in(mdr_out),
																				.sel(MDR_IO));
	
	wire GATE_MDRI, GATE_MDRO, GATE_MAR;
	
	tribuffer #(.SIZE(WORDSIZE)) bus_to_mdr (.in(bus),
													.out(tsb_to_mdr),
													.en(GATE_MDRI));
	tribuffer #(.SIZE(WORDSIZE)) mdr_to_bus (.in(mdr_to_tsb),
													.out(bus),
													.en(GATE_MDRO));
	tribuffer #(.SIZE(WORDSIZE)) bus_to_mar (.in(bus),
													.out(mar_in),
													.en(GATE_MAR));
													
	//---------------------------Register file-----------------------------
	
	wire [WORDSIZE-1:0] reg_in;
	wire [WORDSIZE-1:0] reg_out1;
	wire [WORDSIZE-1:0] reg_out2;
	wire [2:0] dr;
	wire [2:0] sr1;
	wire [2:0] sr2;
	wire LD_REG;
	
	regfile regs (.in(reg_in),
					.dr(dr),
					.load(LD_REG),
					.sr1(sr1),
					.sr2(sr2),
					.out1(reg_out1),
					.out2(reg_out2));
	
	wire GATE_REG;
	
	tribuffer #(.SIZE(WORDSIZE)) bus_to_reg (.in(bus), .out(reg_in), .en(GATE_REG));
	
	//-----------------------------ALU-----------------------------
	
	wire [WORDSIZE-1:0] alu_in2;
	wire [WORDSIZE-1:0] alu_out;
	wire [1:0] ALU_CTRL;
	
	alu alu (.in1(reg_out1),
				.in2(alu_in2),
				.ctrl(ALU_CTRL),
				.out(alu_out));
				
	wire GATE_ALU;
				
	tribuffer alu_to_bus (.in(alu_out), .out(bus), .en(GATE_ALU));
	
	wire [WORDSIZE-1:0] immediate_val;
	
	sext #(.INSIZE(5), .OUTSIZE(WORDSIZE)) immediate_sext (.in(instruction [4:0]), .out(immediate_val));
	
	mux #(.INSIZE(2), .SELSIZE(1), .DATASIZE(16)) sr2mux (.in({reg_out2, immediate_val}),
																			.out(alu_in2),
																			.sel(instruction[5]));
	
	//---------------Program counter and branching-----------------
	
	wire [WORDSIZE-1:0] pc_in;
	wire [WORDSIZE-1:0] pc_out;
	wire LD_PC;
	
	d_latch #(.SIZE(16)) pc (.in(pc_in), .out(pc_out), .load(LD_PC));
	
	wire [WORDSIZE-1:0] addr21;
	wire [WORDSIZE-1:0] addr22;
	wire [WORDSIZE-1:0] addr23;
	wire [WORDSIZE-1:0] addr24;
	wire [WORDSIZE-1:0] addr2;
	wire [WORDSIZE-1:0] addr1;
	wire [1:0] ADDR2MUX;
	wire [1:0] ADDR1MUX;
	
	mux #(.INSIZE(4), .SELSIZE(2), .DATASIZE(16)) addr2mux (.in({addr21, addr22, addr23, addr24}), .out(addr2), .sel(ADDR2MUX));
	mux #(.INSIZE(2), .SELSIZE(1), .DATASIZE(16)) addr1mux (.in({reg_out1, pc_out}), .out(addr1), .sel(ADDR1MUX));
	
	sext #(.INSIZE(11), .OUTSIZE(WORDSIZE)) sextaddr21 (.in(instruction [10:0]), .out(addr21));
	sext #(.INSIZE(9), .OUTSIZE(WORDSIZE)) sextaddr22 (.in(instruction [8:0]), .out(addr22));
	sext #(.INSIZE(6), .OUTSIZE(WORDSIZE)) sextaddr23 (.in(instruction [5:0]), .out(addr23));
	
	wire [WORDSIZE-1:0] newpc;
	assign newpc = addr1 + addr2;
	
	wire [WORDSIZE-1:0] inc_pc;
	assign inc_pc = pc_out + 1;
	
	wire [WORDSIZE-1:0] tsb_to_pcmux;
	wire [1:0] PCMUX;
	
	mux #(.INSIZE(4), .SELSIZE(2), .DATASIZE(16)) pcmux (.in({tsb_to_pcmux, newpc, inc_pc, {WORDSIZE{1'b0}}}), .out(pc_in), .sel(PCMUX));
	
	wire GATE_PCMUX;
	
	tribuffer #(.SIZE(WORDSIZE)) bus_to_pcmux (.in(bus), .out(tsb_to_pcmux), .en(GATE_PCMUX));
	
	//-----------------------MARMUX-------------------------
	
	wire [WORDSIZE-1:0] marmux_out;
	wire MARMUX;
	
	mux #(.INSIZE(2), .SELSIZE(1), .DATASIZE(16)) marmux (.in({{{8{1'b0}}, instruction[7:0]}, newpc}), .out(marmux_out), .sel(MARMUX));
	
	wire GATE_MARMUX;
	
	tribuffer #(.SIZE(WORDSIZE)) marmux_to_bus (.in(marmux_out), .out(bus), .en(GATE_MARMUX));
	
endmodule
