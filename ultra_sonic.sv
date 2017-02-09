/// IMPORTANT ////
/// Formula to get the length of the echo from count data:
  /// t_pulse = 2 * count.

`default_nettype none
module ultra_sonic(
    // INPUTS //
    clk, // 50MHz
    reset_l,

    // DATA OUT ////
    read_data,
    read_data_valid,

    // INPUT FROM GPIO //
    echo,

    // OUPUT TO GPIO //
    trigger
  );

  parameter STATE_BITS = 7;
  parameter COUNT_WIDTH = 32;
  // Delay for 20us: 10bits = lg(1025 cycles).
  parameter DELAY_WIDTH = 10;
  // Delay for 60ms: 22bits = lg(2000000 cycles).
  parameter STALL_WIDTH = 10;

  //// INPUTS ////
  input logic clk, reset_l;

  // MEMORY_MAP ////
  output logic read_data_valid;
  output logic [31:0] read_data;

  // GPIO IN/OUT //
  input logic echo;
  output logic trigger;

  logic [3:0] state_bits;

  // State
  logic [STATE_BITS-1:0] state;
                                // 5432_10
  parameter idle              = 6'b0000_00;
  parameter init_trigger      = 6'b0001_01;
  parameter wait_for_echo     = 6'b0011_00;
  parameter on_echo           = 6'b0100_00;
  parameter head_to_echo      = 6'b0101_00;
  parameter data_ready        = 6'b0110_10;
  parameter stall             = 6'b0111_00;

  // Logic.
  logic [COUNT_WIDTH-1:0] count_out;
  logic [DELAY_WIDTH-1:0] delay_trigger_count;
  logic [STALL_WIDTH-1:0] stall_count;

  // Outputs.
  assign trigger = state[0];
  assign read_data_valid = state[1];
  assign state_bits = state[5:2];

  // State logic.
  always_ff @(posedge clk or negedge reset_l)
  begin
    if(~reset_l)
      state <= idle;
    else
      case(state)
        idle: begin
                state <= init_trigger;
              end
        // Count trigger high for 20us.
        init_trigger:  begin
                      if (delay_trigger_count == 0) state <= wait_for_echo;
                      else state <= init_trigger;
                     end
        // Wait for echo to go high.
        wait_for_echo:  begin
                          if (echo == 1'b1) state <= head_to_echo;
                          else state <= wait_for_echo;
                        end
        // Echo high start counting.
        head_to_echo: state <= on_echo;

        // Waiting for echo to go low.
        on_echo:  begin
                      if (echo == 1'b0) state <= data_ready;
                      else state <= on_echo;
                  end

        data_ready: state <= stall;
        // Waiting for 60ms to be safe.
        stall:  begin
                      if (stall_count == 1'b0) state <= init_trigger;
                      else state <= stall;
                  end
        endcase
  end

  // Trigger counter
  always_ff @(posedge clk or negedge reset_l)
  begin
    if (~reset_l)
      delay_trigger_count <= {{DELAY_WIDTH{0}}, 1'b1};
    else if (state == stall) // reset trigger counter on stall.
      delay_trigger_count <= {{(DELAY_WIDTH-1){0}}, 1'b1};
    else if (state == init_trigger) // increment trigger counter on trigger.
      delay_trigger_count <= delay_trigger_count + 1'b1;
    else
      delay_trigger_count <= delay_trigger_count;
  end

  // Echo counter!
  always_ff @(posedge clk or negedge reset_l)
  begin
    if (~reset_l) count_out <= {COUNT_WIDTH{0}};
    else if (state == init_trigger) count_out <= {{COUNT_WIDTH{0}}, 1'b1};
    else if (echo) count_out <= count_out + {{(COUNT_WIDTH-1){0}}, 1'b1};
    else count_out <= count_out;
  end

  // Stall counter.
  always_ff @(posedge clk or negedge reset_l)
  begin
    if (~reset_l) stall_count <= {STALL_WIDTH{0}};
    else if (state == init_trigger) stall_count <= {{STALL_WIDTH{0}}, 1'b1};
    else if (state == stall)
      stall_count <= stall_count + {{(STALL_WIDTH-1){0}}, 1'b1};
    else stall_count <= stall_count;
  end

  // Data out register.
  always_ff @(posedge clk or negedge reset_l)
  begin
    if(~reset_l) read_data <= 32'b0;
    else if(read_data_valid) read_data <= count_out;
    else read_data <= read_data;
  end

endmodule
