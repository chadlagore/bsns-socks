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
    	trigger, flash,

        // Hexes.
        HEX0, HEX1, HEX2, HEX3
    );

	// status and data memory locations
    parameter DISTANCE = 16'h0900;
	parameter BROKEN = 16'h0904;
    parameter CARCOUNT = 16'h0908;
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
	logic read_data_valid;
	logic [15:0] dist_mod_data; // downto 16 bit.
    logic [7:0] hex0, hex1, hex2, hex3;

    /// Car counter ///
    logic [15:0] car_count;
    logic car;

    output logic [6:0] HEX0, HEX1, HEX2, HEX3;
    logic [3:0] num0, num1, num2, num3;

    UltraSonic us(
            .clk(clk),
            .gpio({trigger, echo}),
            .hex0(HEX0),
            .hex1(HEX1),
            .hex2(HEX2),
            .hex3(HEX3)
        );

    hex_decoder num1decode(HEX0, num0);
    hex_decoder num1decode(HEX1, num1);
    hex_decoder num1decode(HEX2, num2);
    hex_decoder num1decode(HEX3, num3);

    assign dist_mod_data = num0 + 10 * num1 + 100 * num2;

    // A car counter module.
    car_counter cc(
            .clk(clk),
            .reset_l(reset_l),
            .calibrate(1'b1),
            .distance(dist_mod_data),
            .car_count(car_count),
            .address(address),
            .car(car)
        );

	// Respond to incoming request for data.
    always_comb begin
        if(io_select) begin
            case(address)
                DISTANCE: read_data = dist_mod_data;
                BROKEN:   read_data = {15'b0, dist_mod_status};
			    CARCOUNT: read_data = car_count;
                CAR:      read_data = car;
                default:  read_data = 16'bz;
			endcase
        end
        else read_data = 16'bz;
    end

   // Store dist module data in hexes.
   always_ff @(posedge clk or negedge reset_l) begin
       if(~reset_l) flash <= 1'b0;
       else if (echo) flash <= 1'b1;
   end

endmodule
