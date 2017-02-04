`default_nettype none
module ultra_sonic_tb();
  // Inputs from nios.
  logic clk, reset, addr;

  // Outputs to nios
  logic [31:0] read;
  logic echo, pulse;

  ultra_sonic DUT(
      // inputs
      .clk(clk),
      .reset_all(~reset),

      // outputs
      .addr(addr),
      .read_data(read),
      .echo(echo),
      .pulse(pulse)
    );

  initial begin
    addr = 0;
    reset = 1;
    #1 clk = 0;
    #1 clk = 1;
    reset = 0;
    #1 clk = 0;
    #1 clk = 1;

    for (int i = 0; i < 750; i++) begin
      #1 clk = ~clk;
    end

    echo = 1;

    for (int i = 0; i < 50; i++) begin
      #1 clk = ~clk;
    end

    echo = 0;

    for (int i = 0; i < 750; i++) begin
      #1 clk = ~clk;
    end

    echo = 1;

    for (int i = 0; i < 750; i++) begin
      #1 clk = ~clk;
    end

    echo = 0;

    for (int i = 0; i < 750; i++) begin
      #1 clk = ~clk;
    end

  end
endmodule
