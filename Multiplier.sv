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
	parameter WORD_LENGTH = 8
) 
(	// Input ports
	input clk,
	input reset,
	//input start,
	input [WORD_LENGTH-1 : 0] Multiplicand,
	input [WORD_LENGTH-1 : 0] Multiplier,

	
	// Output ports
	//output ready,
	output Sign,
	output [WORD_LENGTH-1 : 0] Result
);

bit enable_bit;
bit flag0_bit;
bit Qsel_bit;
bit Qsum_bit;
bit Sign_bit;

//wire [1:0] select_w;
wire [WORD_LENGTH-1:0] A_w;
wire A0_w;
wire [WORD_LENGTH-1:0] M_w;
wire [WORD_LENGTH-1:0] Q_w;
wire [WORD_LENGTH:0] Areg_w;
wire [WORD_LENGTH-1:0] Mreg_w;
wire [WORD_LENGTH-1:0] Qreg_w;
wire [WORD_LENGTH-1:0] Sum_w;
wire [WORD_LENGTH-1:0] Asum_w;
wire [WORD_LENGTH:0] Ainit_w;
wire [WORD_LENGTH-1:0] Minit_w;
wire [WORD_LENGTH-1:0] Qinit_w;
wire [WORD_LENGTH:0] Ashift_w;
//wire [WORD_LENGTH-1:0] Mshift_w;
//wire [WORD_LENGTH-1:0] Qshift_w;
wire [WORD_LENGTH:0] Result_w;


assign Ainit_w = {WORD_LENGTH+1{1'b0}}; //Multiplier
assign Minit_w = Multiplicand;
assign Qinit_w = Multiplier;
//assign select_w = Q_w[1:0];
assign Qsel_bit = (Q_w[0]) ^ (Q_w[1]);
assign Qsum_bit = Qsel_bit & Q_w[0];


Multiplexer2to1
#(
	.NBits(WORD_LENGTH+1)
)
Mux_Ainit
(
	.Selector(flag0_bit),
	.MUX_Data0(Ainit_w),
	.MUX_Data1(Areg_w >> 1),
	.MUX_Output(A_w)
);

/*
Register
#(
	.Word_Length(WORD_LENGTH+1)
)
Ainit_reg
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.Data_Input(Ashift_w),
	.Data_Output(A_w)
);*/


Multiplexer2to1
#(
	.NBits(WORD_LENGTH)
)
Mux_Minit
(
	.Selector(flag0_bit),
	.MUX_Data0(Minit_w),
	.MUX_Data1( Mreg_w >> 1),
	.MUX_Output(M_w)
);


Multiplexer2to1
#(
	.NBits(WORD_LENGTH)
)
Mux_Qinit
(
	.Selector(flag0_bit),
	.MUX_Data0(Qinit_w),
	.MUX_Data1(Qreg_w << 1),
	.MUX_Output(Q_w)
);

Adder
#(
	.WORD_LENGTH(WORD_LENGTH)
)
Adder_Mult
(
	.selector(Qsum_bit/*((Q_w[0]) ^ (Q_w[1])) & Q_w[0]*/),
	.Data1(A_w),
	.Data2(M_w),
	.result(Sum_w)
);

Multiplexer2to1
#(
	.NBits(WORD_LENGTH+1)
)
Mux_Sum
(
	.Selector(Qsel_bit),
	.MUX_Data0(Sum_w),
	.MUX_Data1(A_w),
	.MUX_Output(Asum_w)
);

Register
#(
	.Word_Length(WORD_LENGTH+1)
)
A_reg
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.Data_Input(Asum_w),
	.Data_Output(Areg_w)
);

Register
#(
	.Word_Length(WORD_LENGTH)
)
M_reg
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.Data_Input(M_w),
	.Data_Output(Mreg_w)
);

Register
#(
	.Word_Length(WORD_LENGTH)
)
Q_reg
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.Data_Input(Q_w),
	.Data_Output(Qreg_w)
);

CounterWithFunction counter
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.flagStart(flag0_bit),
	.flagReady(enable_bit) 
);


Register
#(
	.Word_Length(WORD_LENGTH+1)
)
Result_reg
(
	.clk(clk),
	.reset(reset),
	.enable(enable_bit),
	.Data_Input(Qreg_w),
	.Data_Output(Result_w)
);

assign Result = Result_w;
assign Sign_bit = Result_w[WORD_LENGTH];
assign Sign = Sign_bit;

endmodule


