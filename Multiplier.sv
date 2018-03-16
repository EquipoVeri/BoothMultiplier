/******************************************************************* 
* Name:
*	Multiplier.sv
* Description:
* 	This module realize a sequential multiplier
* Inputs:
*	clk,reset,start,multiplier,multiplicand,
* Outputs:
* 	ready,product,sign
* Versión:  
*	1.0
* Author: 
*	Felipe Garcia & Diego Reyna
* Fecha: 
*	21/02/2018 
*********************************************************************/
module Multiplier
#(
	parameter WORD_LENGTH = 16
) 
(	// Input ports
	input clk,
	input reset,
	//input start,
	input [WORD_LENGTH-1 : 0] Multiplier,
	input [WORD_LENGTH-1 : 0] Multiplicand,

	
	// Output ports
	//output ready,
	output sign,
	output [WORD_LENGTH-1 : 0] Result
);

bit enable_bit;
bit flag0_bit;
bit Pzero_bit;
bit s_bit;
bit P32_bit;
bit P33_bit;
bit Psum_bit;
bit Psel_bit;

wire [(WORD_LENGTH*2)-1 : 0] A_w;
wire [(WORD_LENGTH*2)-1 : 0] S_w;
wire [(WORD_LENGTH*2)-1 : 0] P_w;
wire [(WORD_LENGTH*2)-1 : 0] Sum_w;
wire [(WORD_LENGTH*2)-1 : 0] SumInit_w;
wire [(WORD_LENGTH*2)-1 : 0] SumResult_w;
wire [(WORD_LENGTH*2)-1 : 0] Ainit_w;
wire [(WORD_LENGTH*2)-1 : 0] Sinit_w;
wire [(WORD_LENGTH*2)-1 : 0] Pinit_w;
wire [(WORD_LENGTH*2)-1 : 0] Ashift_w;
wire [(WORD_LENGTH*2)-1 : 0] Sshift_w;
wire [(WORD_LENGTH*2)-1 : 0] Pshift_w;


assign Ainit_w = {Multiplier,{WORD_LENGTH{1'b0}},1'b0}; //Multiplier
assign Sinit_w = {(~Multiplier + 1),17'b0};
assign Pinit_w = {{WORD_LENGTH{1'b0}},Multiplicand,1'b0}; //Multiplicand

//assign Pzero_bit = () ? 1'b1 : 1'b0;
assign P32_bit = P_w[(WORD_LENGTH*2)-1];
assign P33_bit = P_w[(WORD_LENGTH*2)];

assign Psel_bit = P32_bit ^ P33_bit;
assign Psum_bit = (P33_bit == 0) ? 1'b1 : 1'b0;

assign Pshift_w = P_w << 1;




Multiplexer2to1
#(
	.NBits(WORD_LENGTH)
)
Mux_Multiplicand
(
	.Selector(flag0_bit),
	.MUX_Data0(Pinit_w),
	.MUX_Data1(Pshift_w),
	.MUX_Output(P_w)
);

Multiplexer2to1
#(
	.NBits(WORD_LENGTH)
)
Mux_Multiplier
(
	.Selector(P33_bit),
	.MUX_Data0(Ainit_w),
	.MUX_Data1(Sinit_w),
	.MUX_Output(SumInit_w)
);


Multiplexer2to1
#(
	.NBits(WORD_LENGTH)
)
Mux_Sum
(
	.Selector(Psum_bit),
	.MUX_Data0(A_w),
	.MUX_Data1(S_w),
	.MUX_Output(SumInit_w)
);

/*
Multiplexer2to1
#(
	.NBits(WORD_LENGTH)
)
Mux
(
	.Selector(),
	.MUX_Data0(),
	.MUX_Data1(),
	.MUX_Output()
);*/

Adder
#(
	.WORD_LENGTH(WORD_LENGTH)
)
Adder_Mult
(
	.selector(1'b1),
	.Data1(P_w),
	.Data2(SumInit_w),
	.result(Sum_w)
);

Register
#(
	.Word_Length(WORD_LENGTH)
)
R_reg
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.Data_Input(Sum_w),
	.Data_Output(SumResult_w)
);

CounterWithFunction counter
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.flag0(flag0_w),
	.flag32(enable_w) 
);



endmodule


