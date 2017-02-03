`define idle        0
`define trigger     1
`define wait_burst  2
`define echo_pulse  3

`default_nettype none
module ultra_sonic(
    // INPUTS //
    clk, // 50MHz
    reset_all,
    echo_high, // Recieving data from sensor.

    // OUTPUTS //
    count_out, // Number of clock cycles trigger held high.
    pulse_out, // Output pulse to initialize state machine.
    count_ready_out, // Distance is ready

    // MEMORY_MAP ////
    addr

  );
  parameter COUNT_WIDTH = 32;
  parameter DELAY_WIDTH = 8;

  //// INPUTS ////
  input logic clk, reset_all;

  input logic echo_high;

  //// OUTPUTS ////
  output logic [COUNT_WIDTH-1:0] count_out;

  output logic count_ready_out;

  output logic pulse_out;

  // MEMORY_MAP ////
  input logic addr;

  // State
  logic [9:0] state;
  // logic [9:0] nextState;
                                //  9876_543210
  parameter idle              = 10'b0000_000000;
  parameter init_pulse        = 10'b0001_100011;
  parameter wait_for_echo     = 10'b0011_110001;
  parameter on_echo           = 10'b0100_101001;
  parameter head_to_echo      = 10'b0101_000101;

  // Logic.
  logic trigger_in;
  logic [DELAY_WIDTH-1:0] delay_pulse_count;
  logic counting_echo;
  logic waiting_for_echo;
  logic reset_echo_count;

  // Outputs.
  assign pulse_out = state[1];
  assign reset_echo_count = state[2];
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
                state <= init_pulse;
              end
        /////// INIT_PULSE STATE ////////
        init_pulse:  begin
                        if (delay_pulse_count == 9'b0) state <= wait_for_echo;
                        else state <= init_pulse;
                     end
        /////// WAIT_FOR_ECHO STATE ////////
        wait_for_echo:  begin
                          if (echo_high == 1'b1) state <= head_to_echo;
                          else state <= wait_for_echo;
                        end
        /////// WAIT_FOR_ECHO STATE ////////
        head_to_echo:  begin
                          state <= on_echo;
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
    else if (reset_echo_count) count_out <= 0;
    else if (echo_high) count_out <= count_out + 1'b1;
    else count_out <= count_out;
  end

endmodule
