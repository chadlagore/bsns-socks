`default_nettype none
module car_counter(
        clk, reset_l, calibrate,

        /// INPUTS FROM SENSOR ///
        distance, distance_ready,

        /// OUTPUTS ///
        car_count, car,

        /// INPUTS FROM NIOS ///
        address, io_select
    );

    // status and data memory locations
    parameter DISTANCE = 16'h0900;
	parameter BROKEN = 16'h0904;
    parameter CARCOUNT = 16'h0908;
    parameter CAR = 16'h090C;

    input logic clk, reset_l, distance_ready, calibrate;
    input logic [31:0] distance;
    input logic [15:0] address;
    input logic io_select;

    /* Can count up to 64000 cars */
    output logic [15:0] car_count;
    output logic car;

    // Internal wires. //
    logic [15:0] base_distance;
    logic [1:0] state;
    logic [15:0] threshold;
	 logic car_read;

    // States.
    parameter IDLE        = 2'b00;
    parameter CALIBRATE   = 2'b01;
    parameter RUN         = 2'b10;

    /* State register */
    always_ff @(posedge clk or negedge reset_l) begin
    if (~reset_l) state <= IDLE;
    else begin
        case (state)
            /* Wait for calibrate signal. */
            IDLE: begin
                if (calibrate) state <= CALIBRATE;
                else state <= IDLE;
            end
            CALIBRATE: begin
                if (distance > 0) state <= RUN;
                else state <= CALIBRATE;
            end
            RUN: begin
            /* If we enable NIOS writing, this would allow
             * us to re-calibrate the sensor. TODO.
                if (calibrate) state <= CALIBRATE;
                else state <= RUN;
             */
                state <= RUN;
            end
        endcase
    end
    end

    assign threshold = base_distance >> 1;

    // Base distance register: calibrate counter.
    always_ff @(posedge clk or negedge reset_l) begin
        if (~reset_l) base_distance <= 31'b0;
        else if (state == CALIBRATE) begin
            base_distance <= distance;
        end
    end

    // Car bit.
    always_ff @(posedge clk or negedge reset_l) begin
        if (~reset_l) car <= 1'b0;
        else if (state == RUN) begin
            // We should change this.
            if (distance < threshold)
                car <= 1'b1;
            else
                car <= 1'b0;
        end
    end

	assign car_read = (address == CARCOUNT) && io_select;

    // Car count.
    always @(posedge clk or negedge reset_l) begin
        if (~reset_l) car_count <= 16'b0;
        else if (car_read) car_count <= 16'b0;
        else if (state == RUN) car_count <= car_count + 16'b1;
    end

endmodule
