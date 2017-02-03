
module ultra_sonic_tb();
  // Inputs from nios.
  logic clk, reset, start;

  // Inputs from sensor.
  logic echo_high;

  // Outputs to nios
  logic count_ready, active;
  logic [22:0] count_out;

  // Outputs to sensor
  logic pulse_out;

  ultra_sonic DUT(
    // inputs
    .clk(clk),
    .reset_all(~reset),

    // input from sensor.
    .echo_high(echo_high),

    // outputs
    .count_ready_out(count_ready),
    .count_out(count_out),
    .pulse_out(pulse_out)
    );

  initial begin
    reset = 1;
    #1 clk = 0;
    #1 clk = 1;
    reset = 0;
    #1 clk = 0;
    #1 clk = 1;
    #1 start = 1;

    for (int i = 0; i < 750; i++) begin
      #1 clk = ~clk;
    end

    echo_high = 1;

    for (int i = 0; i < 50; i++) begin
      #1 clk = ~clk;
    end

    echo_high = 0;

    for (int i = 0; i < 750; i++) begin
      #1 clk = ~clk;
    end

    echo_high = 1;

    for (int i = 0; i < 750; i++) begin
      #1 clk = ~clk;
    end

    echo_high = 0;

  end
endmodule
