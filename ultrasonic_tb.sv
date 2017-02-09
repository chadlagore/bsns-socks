`default_nettype none
module ultra_sonic_tb();
  // Inputs from nios.
  logic clk, reset, addr;

  // Outputs to nios
  logic [31:0] read;
  logic read_data_valid;

  logic echo, trigger;
  logic on_stall;

  ultra_sonic DUT(
      // inputs
      .clk(clk),
      .reset_l(~reset),

      // outputs
      .read_data(read),
      .read_data_valid(read_data_valid),

      // GPIO
      .echo(echo),
      .trigger(trigger)
    );

  initial begin
    reset = 1;
    #1 clk = 0;
    #1 clk = 1;
    reset = 0;
    #1 clk = 0;
    #1 clk = 1;
    for(int j=0; j<15; j++) begin

      // Should send trigger.
      for (int i = 0; i < 3000; i++) begin
        #1 clk = ~clk;
      end

      // Simulate echo goes high.
      echo = 1;

      // Wait for 50 cycles with echo high.
      for (int i = 0; i < j * 300; i++) begin
        #1 clk = ~clk;
      end

      // Echo drops, we go to stall.
      echo = 0;

      // Should stall, then head to trigger init.
      for (int i = 0; i < 2000; i++) begin
        #1 clk = ~clk;
      end
    end
  end
endmodule
