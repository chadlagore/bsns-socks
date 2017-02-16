`default_nettype none
module car_counter(
        clk, reset_l, calibrate,

        /// Inputs from nios ///
        read_signal,

        /// INPUTS FROM SENSOR ///
        distance, distance_ready,

        /// OUTPUTS ///
        car_count, car
    );

    input logic clk, reset_l, distance_ready, calibrate, read_signal;
    input logic [31:0] distance;

    /* Can count up to 64000 cars */
    output logic [15:0] car_count;
    output logic car;

    // Internal wires. //
    logic [31:0] base_distance;
    logic [1:0] state;

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
                if (distance_ready) state <= RUN;
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

    // Base distance register: calibrate counter.
    always_ff @(posedge clk or negedge reset_l) begin
        if (~reset_l) base_distance <= 31'b0;
        else if (state == CALIBRATE) base_distance <= distance;
    end

    // Car bit.
    always_ff @(posedge clk or negedge reset_l) begin
        if (~reset_l) car <= 1'b0;
        else if (state == RUN) begin
            // We should change this.
            if (distance < (base_distance >> 2))
                car <= 1'b1;
            else
                car <= 1'b0;
        end
    end

    // Car count.
    always_ff @(posedge clk or negedge reset_l) begin
        if (~reset_l) car_count <= 16'b0;
        else if (state == RUN) begin
            if (read_signal)
                car_count <= 16'b0;
            else if (car)
                car_count <= car_count + 16'b1;
            else
                car_count <= car_count;
        end
    end

endmodule
