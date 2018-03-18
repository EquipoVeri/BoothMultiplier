timeunit 10ps; //It specifies the time unit that all the delay will take in the simulation.
timeprecision 1ps;// It specifies the resolution in the simulation.

module Multiplier_TB;

parameter WORD_LENGTH = 16;

bit clk = 0;
bit reset;
//bit sign; 

logic [WORD_LENGTH-1:0] Multiplicand = 0;
logic [WORD_LENGTH-1:0] Multiplier = 0;
logic [WORD_LENGTH-1:0] Result = 0;

Multiplier
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
DUV
(	// Input ports
	.clk(clk),
	.reset(reset),
	//input start,
	.Multiplicand(Multiplicand),
	.Multiplier(Multiplier),

	
	// Output ports
	//output ready,
	//.Sign(Sign),
	.Result(Result)
);


/*********************************************************/
initial // Clock generator
  begin
    forever #1 clk = !clk;
  end
/*********************************************************/
initial begin // reset generator
	#0 reset = 1;
	/*#30 reset = 0;
	#5 reset = 1;*/
end

/*********************************************************/

initial begin 
	#0 Multiplicand = -32760;
	#0 Multiplier = 2;
	
end

/*********************************************************/
endmodule
