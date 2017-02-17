`default_nettype none
module ultra_top(
		GPIO_0, reset_l, CLOCK_50, LEDR,
		address, io_select, read_data
	);

	// status and data memory locations
    parameter DISTANCE = 16'h0900;
	parameter BROKEN = 16'h0904;
    parameter STATUS = 16'h0908;
    parameter CAR = 16'h090C;

	input logic CLOCK_50;
	input logic reset_l;
	inout logic [35:0] GPIO_0;
	input logic [9:0] LEDR;

	output logic [15:0] read_data;
	input logic [15:0] address;
	input logic io_select;

	logic [15:0] dist_mod_data;
	logic read_data_valid;

	ultra_sonic ultra(
			.clk(CLOCK_50),
			.reset_l(reset_l),
			.read_data(dist_mod_data),
			.read_data_valid(read_data_valid),
			.echo(GPIO_0[34]),
			.trigger(GPIO_0[35])
		);

	// Respond to incoming request for data.
    always@(*) begin
        if(io_select) begin
            case(address)
                DISTANCE: read_data = dist_mod_data;
                BROKEN:   read_data = {15'b0, dist_mod_data};
				STATUS:   read_data = {15'b0, dist_mod_data};
                CAR:      read_data = 16'b100;
                default:  read_data = 16'bz;
			endcase
        end
        else read_data = 16'bz;
    end

	// assign LEDR[9:0] = read_data;

endmodule
