`default_nettype none

/* Module interfaces with an avalon bridge to provide
 * status and data readings from the ultrasonic distance sensor
 * fsm module which is instantiated herein. Module cannot be
 * written to --only read from. Current status and data output
 * are always maintained internally and written to data_out for. */
module avalon_distance_module_interface
(
	// avalon interface inputs
	input logic clk,
	input logic reset_l,
	input logic [15:0] address,
	input logic io_select,

	// ultrasonic distance sensor inputs
	input logic echo,

	// avalon interface outputs
	output logic [15:0] read_data,

	// ultrasonic distance sensor outputs
	output logic trigger,
	output logic got_request,
	output logic [15:0] data_out
	
);

// status and data memory locations
parameter STATUS = 16'h0904;
parameter DATA_OUT = 16'h0900;

// internal wires
logic status_out;
//logic [15:0] data_out;
logic dist_mod_status;
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

always @(posedge clk, negedge reset_l) begin
	// reset
	if (~reset_l) status_out <= 1'b0;
	// if status becomes high
	else if (dist_mod_status) status_out <= 1'b1;
	// if data is read from the address or reset
	else if (address == DATA_OUT) status_out <= 1'b0;
	// otherwise output status
	else status_out <= status_out;
end

always @(posedge clk, negedge reset_l) begin
	// asynchronous reset from push button
	if (~reset_l) data_out = 16'b0;
	// if distance module status is high, we have a new reading
	else if (dist_mod_status == 1) data_out <= dist_mod_data[15:0];
	// otherwise simply output the same signal
	else data_out <= data_out;
end

always @(posedge clk, negedge reset_l) begin
	// reset
	if (~reset_l) read_data <= 16'b0;
	// if address == 900, output data register signal
	else if (address == DATA_OUT) read_data <= data_out;
	// else if address == 904, output status register
	else if (address == STATUS) read_data <= {15'b0, status_out};
	// else output 0
	else read_data <= 16'bZ;
end // end output conditional statements

always @(posedge clk, negedge reset_l) begin
	if (~reset_l) got_request <= 1'b0;
	else if (address == DATA_OUT) got_request <= 1'b1;
	else got_request <= got_request;
end
endmodule
