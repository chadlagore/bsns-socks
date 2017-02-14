`default_nettype none

/* Module interfaces with an avalon bridge to provide
 * status and data readings from the ultrasonic distance sensor
 * fsm module which is instantiated herein. Module cannot be
 * written to --only read from. Current status and data output
 * are always maintained internally and written to data_out for. */
module avalon_distance_module_interface (
    	// avalon interface inputs
    	clk, reset_l, address, io_select,

    	// ultrasonic distance sensor inputs
    	echo,

    	// avalon interface outputs
    	read_data, data_out,

    	// ultrasonic distance sensor outputs
    	trigger, flash
    );

	// status and data memory locations
	parameter STATUS = 16'h0904;
	parameter DATA_OUT = 16'h0900;

	//// INPUTS ////
	input logic clk, reset_l, io_select;
	input logic [15:0] address;

	//// OUTPUTS ////
	// avalon interface outputs
	output logic [15:0] read_data;
	output logic [15:0] data_out;

	// ultrasonic distance sensor outputs
	output logic trigger;
	input logic echo;
	output logic flash;

	// internal wires
	logic status_out;
	logic dist_mod_status;
	logic read_data_valid;
	logic [31:0] dist_mod_data;

    // instantiation of dist sensor fsm
	ultra_sonic us(
		.clk(clk),
		.reset_l(reset_l),
		.read_data(dist_mod_data),
		.read_data_valid(dist_mod_status),
		.echo(echo),
		.trigger(trigger)
	);

	// Respond to incoming request for data.
    always_ff @(posedge clk or negedge reset_l) begin
        if(~reset_l) read_data <= 16'bz;
        else if(io_select) begin
			if(address == STATUS)
				read_data <= {15'b0, dist_mod_status};
			else if(address == DATA_OUT)
				read_data <= (dist_mod_data[15:0] >> 4);
			end
        else read_data <= 16'bz;
    end

	 // Store dist module data in hexes.
	always_ff @(posedge clk or negedge reset_l) begin
		if(~reset_l) data_out <= 16'bz;
		else if(io_select) begin
			if(address == STATUS)
				data_out <= {15'b0, dist_mod_status};
			else if(address == DATA_OUT)
				data_out <= dist_mod_data[15:0];
			end
		else data_out <= 16'bz;
    end

endmodule
