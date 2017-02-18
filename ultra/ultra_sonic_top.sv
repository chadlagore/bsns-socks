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
	logic read_data_valid;
	logic [15:0] dist_mod_data; // downto 16 bit.
    logic [7:0] hex0, hex1, hex2, hex3;
    logic [3:0] data0, data1, data2, data3;
    output logic [6:0] HEX0, HEX1, HEX2, HEX3;

    // // instantiation of dist sensor fsm, puts out 16
	// ultra_sonic us(
	// 	.clk(clk),
	// 	.reset_l(1'b1), // hard reset on boot up.
	// 	.read_data(dist_mod_data),
	// 	.read_data_valid(dist_mod_status),
	// 	.echo(echo),
	// 	.trigger(trigger)
	// );

    UltraSonic us(
            .clk(clk),
            .gpio({trigger, echo}),
            .hex0(hex0),
            .hex1(hex1),
            .hex2(hex2),
            .hex3(hex3)
        );

    assign HEX0 = hex0;
    assign HEX1 = hex1;
    assign HEX2 = hex2;
    assign HEX3 = hex3;

    hex_decoder h0(hex0, data0);
    hex_decoder h1(hex1, data1);
    hex_decoder h2(hex2, data2);
    hex_decoder h3(hex3, data3);

    //////assign dist_mod_data = data0 + (data >> 1) + (data2 >> 2);

	// Respond to incoming request for data.
    always_comb begin
        if(io_select) begin
            case(address)
                DISTANCE: read_data = data0;
                BROKEN:   read_data = data1;
			    STATUS:   read_data = data2;
                CAR:      read_data = data3;
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
