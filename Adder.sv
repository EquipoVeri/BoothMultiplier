/******************************************************************* 
* Name:
*	AdderRegister.sv
* Description:
* 	This module realize an add of two inputs
* Inputs:
*	selector, Data1, Data2
* Outputs:
* 	result
* Versión:  
*	1.0
* Author: 
*	Felipe Garcia & Diego Reyna
* Fecha: 
*	21/02/2018 
*********************************************************************/
module Adder
#(
	parameter WORD_LENGTH = 16
)
(
	// Inputs
	input selector,
	input [WORD_LENGTH-1:0] Data1,
	input [WORD_LENGTH-1:0] Data2,
	
	// Outputs
	output [WORD_LENGTH-1:0] result
);

logic [WORD_LENGTH-1:0] result_log;


always_ff @(Data1, Data2, selector) begin

	if(selector == 1'b1)
		result_log <= Data1 + Data2;
	else
		result_log <= Data1 - Data2;
	
end

assign result = result_log;

endmodule
