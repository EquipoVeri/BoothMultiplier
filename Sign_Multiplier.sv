module Sign_Multiplier
#(
	parameter WORD_LENGTH = 16
)
(
	input [WORD_LENGTH-1:0]result,
	output [WORD_LENGTH-1:0]nosigned_result,
	output sign
);

bit sign_bit;
logic [WORD_LENGTH-1:0]result_log;

always_comb begin
	if(result[WORD_LENGTH-1] == 1'b1)begin
		result_log <= ~result + 1'b1;
		sign_bit <= 1'b1;
	end
	else begin
		result_log <= result;
		sign_bit <= 1'b0;
	end
end

assign nosigned_result = result_log;
assign sign = sign_bit;

endmodule
