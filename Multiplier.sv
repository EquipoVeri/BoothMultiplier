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
	//output sign,
	output [(WORD_LENGTH*2)-1 : 0] Result
);

bit flag0_bit;
bit enable_bit;
bit Qm1_bit;
bit Qm1shift_bit;
bit Qm1reg_bit;

wire [WORD_LENGTH-1:0] A_w;
wire [WORD_LENGTH-1:0] Q_w;
wire [WORD_LENGTH-1:0] M_w;
wire [WORD_LENGTH-1:0] Ashift1_w;
wire [WORD_LENGTH-1:0] Ashift2_w;
wire [WORD_LENGTH-1:0] Qshift1_w;
wire [WORD_LENGTH-1:0] Qshift2_w;
wire [WORD_LENGTH-1:0] Asum_w;
wire [WORD_LENGTH-1:0] Areg_w;
wire [WORD_LENGTH-1:0] Qreg_w;
wire [(WORD_LENGTH*2)-1:0] Result_w;

assign Qm1shift_bit = Q_w[0];


assign Qshift1_w = Q_w >> 1;
assign Qshift2_w = {Asum_w[0], Qshift1_w[WORD_LENGTH-2:0]};


assign Ashift1_w = Asum_w >> 1;
assign Ashift2_w = {Asum_w[WORD_LENGTH-1], Ashift1_w[WORD_LENGTH-2:0]};


Multiplexer2to1
#(
	.NBits(WORD_LENGTH)
)
Mux_A
(
	.Selector(flag0_bit),
	.MUX_Data0({WORD_LENGTH{1'b0}}),
	.MUX_Data1(Areg_w),
	.MUX_Output(A_w)
);

Multiplexer2to1
#(
	.NBits(WORD_LENGTH)
)
Mux_Q
(
	.Selector(flag0_bit),
	.MUX_Data0(Multiplier),
	.MUX_Data1(Qreg_w),
	.MUX_Output(Q_w)
);

Multiplexer2to1
#(
	.NBits(2)
)
Mux_Qm1
(
	.Selector(flag0_bit),
	.MUX_Data0(1'b0),
	.MUX_Data1(Qm1reg_bit),
	.MUX_Output(Qm1_bit)
);

Register
#(
	.Word_Length(WORD_LENGTH)
)
Qm1_reg
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.Data_Input(Qm1shift_bit),
	.Data_Output(Qm1reg_bit)
);

Multiplexer4to1 
#(
	.NBits(WORD_LENGTH)
)
Mux_Sum
(
	.Selector({Q_w[0],Qm1_bit}),
	.MUX_Data0({WORD_LENGTH{1'b0}}),
	.MUX_Data1(Multiplicand),
	.MUX_Data2(~Multiplicand + 1),
	.MUX_Data3({WORD_LENGTH{1'b0}}),
	.MUX_Output(M_w)
);

Adder
#(
	.WORD_LENGTH(WORD_LENGTH)
)
Adder_Mult
(
	.selector(1'b1),
	.Data1(A_w),
	.Data2(M_w),
	.result(Asum_w)
);

Register
#(
	.Word_Length(WORD_LENGTH)
)

A_reg
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.Data_Input(Ashift2_w),
	.Data_Output(Areg_w)
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
	.Data_Input(Qshift2_w/*{Asum_w[0],{Q_w >> 1}}*/),
	.Data_Output(Qreg_w)
);

Register
#(
	.Word_Length(WORD_LENGTH*2)
)
Result_reg
(
	.clk(clk),
	.reset(reset),
	.enable(enable_bit),
	.Data_Input({Ashift2_w,Qshift2_w}),
	.Data_Output(Result_w)
);


CounterWithFunction Counter
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.flagStart(flag0_bit),
	.flagReady(enable_bit) 
);

assign Result = Result_w;

endmodule
