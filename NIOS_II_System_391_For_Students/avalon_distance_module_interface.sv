`default_nettype none

/* Module interfaces with an avalon bridge to provide
 * status and data readings from the ultrasonic distance sensor
 * fsm module which is instantiated herein. Module cannot be
 * written to --only read from. Current status and data output
 * are always maintained internally and written to data_out for. */
module avalon_distance_module_interface
(
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
  parameter DISTANCE = 16'h0900;
  parameter BROKEN = 16'h0904;
  parameter STATUS = 16'h0908;
  parameter CAR = 16'h090C;

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
  logic make_data_invalid;
  logic reading_available;
	logic read_data_valid;
	logic [15:0] dist_mod_data;

  // instantiation of dist sensor fsm, puts out 16
	ultra_sonic us(
    .clk(clk),
    .reset_l(1'b1),
    .read_data(dist_mod_data),
    .read_data_valid(dist_mod_status),
    .echo(echo),
    .trigger(trigger)
	);

  // respond to incoming request for data.
  always_comb begin
    if(io_select) begin
      case(address)
        DISTANCE: read_data = dist_mod_data;
        BROKEN:   read_data = {15'b0, reading_available};
			  STATUS:   read_data = {15'b0, reading_available};
        CAR:      read_data = 16'b100;
        default:  read_data = 16'bz;
		  endcase
    end
    else read_data = 16'bz;
  end

  // when true, reading_available should be zeroed..
  assign make_data_invalid = (address == DISTANCE);

  // register with enable --store data ready..
  always_ff @(posedge clk or negedge reset_l) begin
    if (~reset_l) reading_available <= 0;
    else if (make_data_invalid) reading_available <= 1'b0;
    else if (dist_mod_status) reading_available <= 1'b1;
  end

endmodule
