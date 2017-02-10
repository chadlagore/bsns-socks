`default_nettype none
module ultra_top(
		GPIO_0, KEY, CLOCK_50, LEDR, HEX0
	);

	input logic CLOCK_50;
	input logic [3:0] KEY;
	inout logic [35:0] GPIO_0;
	output logic [9:0] LEDR;
	output logic [8:0] HEX0;

	logic trigger, echo;
	logic [31:0] read_data;

	ultra_sonic ultra(
			.clk(CLOCK_50),
			.reset_l(KEY[0]),
			.read_data(read_data),
			.read_data_valid(HEX0[0]),
			.echo(echo),
			.trigger(trigger)
		);
	
	assign echo = GPIO_0[34];
	assign GPIO_0[35] = trigger;
	
	assign LEDR = read_data >> 10;
	
	

endmodule
