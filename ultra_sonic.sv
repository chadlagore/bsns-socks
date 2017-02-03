`define idle        0
`define trigger     1
`define wait_burst  2
`define echo_pulse  3

`default_nettype none
module ultra_sonic(
    // INPUTS //
    clk, // 50MHz
    reset_all,
    start, // Input to initialize send pulse.
    echo_high, // Recieving data from sensor.

    // OUTPUTS //
    count_out, // Number of clock cycles trigger held high.
    pulse_out, // Output pulse to initialize state machine.
    count_ready_out, // Distance is ready.
    active_out // Device is not idle.
  );
  parameter COUNT_WIDTH = 23;
  parameter DELAY_WIDTH = 8;

  //// INPUTS ////
  input clk, reset_all;
  logic clk, reset_all;

  input start;
  logic start;

  input echo_high;
  logic echo_high;

  //// OUTPUTS ////
  output [COUNT_WIDTH-1:0] count_out;
  logic [COUNT_WIDTH-1:0] count_out;

  output count_ready_out;
  logic count_ready_out;

  output pulse_out;
  logic pulse_out;

  output active_out;
  logic active_out;

  // State
  logic [9:0] state;
  // logic [9:0] nextState;
                                //  9876_543210
  parameter idle              = 10'b0000_000000;
  parameter init_pulse        = 10'b0001_100011;
  parameter wait_for_echo     = 10'b0011_110001;
  parameter on_echo           = 10'b0100_101001;

  // Logic.
  logic trigger_in;
  logic [DELAY_WIDTH-1:0] delay_pulse_count;
  logic counting_echo;
  logic waiting_for_echo;

  // Outputs.
  assign active_out = state[0];
  assign pulse_out = state[1];
  // Reserved for state[2]
  assign counting_echo = state[3];
  assign waiting_for_echo = state[4];
  assign count_ready_out = ~echo_high; // cout available when echo low.

  // State logic.
  always_ff @(posedge clk or negedge reset_all)
  begin
    if(~reset_all)
      state <= idle;
    else
      case(state)
        /////// IDLE STATE ////////
        idle: begin
                if (start) state <= init_pulse;
                else state <= idle;
              end
        /////// INIT_PULSE STATE ////////
        init_pulse:  begin
                        if (delay_pulse_count == 9'b0) state <= wait_for_echo;
                        else state <= init_pulse;
                     end
        /////// WAIT_FOR_ECHO STATE ////////
        wait_for_echo:  begin
                          if (echo_high == 1'b1) state <= on_echo;
                          else state <= wait_for_echo;
                        end
        /////// ON_ECHO STATE ////////
        on_echo:  begin
                      if (echo_high == 1'b0) state <= init_pulse;
                      else state <= on_echo;
                  end
        endcase
  end

  // Wait counter
  always_ff @(posedge clk or negedge reset_all)
  begin
    if (~reset_all) delay_pulse_count <= {{DELAY_WIDTH{0}}, 1'b1};
    else if (pulse_out) delay_pulse_count <= delay_pulse_count + 1'b1;
    else count_out <= count_out;
  end

  // Trigger counter.
  always_ff @(posedge clk or negedge reset_all)
  begin
    if (~reset_all) count_out <= {COUNT_WIDTH{0}};
    else if (posedge echo_high) count_out <= count_out + 1'b1;
    else count_out <= count_out;
  end

endmodule
