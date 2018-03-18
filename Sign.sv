/******************************************************************* 
* Name:
*	Sign.sv
* Description:
* 	This module calculate the sign ot the result
* Inputs:
*	enable, multiplicand, multiplier,
* Outputs:
* 	sign
* Versión:  
*	1.0
* Author: 
*	Felipe Garcia & Diego Reyna
* Fecha: 
*	27/02/2018 
*********************************************************************/
module Sign
(
	input enable,
	input multiplicand,
	input multiplier,
	output sign
);

bit sign_bit;

always begin
	
		case ({multiplicand, multiplier})
			2'b00:
				if(enable==1'b1)
					sign_bit <= 1'b0;
			2'b01:
				if(enable==1'b1)
					sign_bit <= 1'b1;
			2'b10:
				if(enable==1'b1)
					sign_bit <= 1'b1;
			2'b11:
				if(enable==1'b1)
					sign_bit <= 1'b0;
			default:
				sign_bit <= 1'b0;
		endcase
end

assign sign = sign_bit;

endmodule
