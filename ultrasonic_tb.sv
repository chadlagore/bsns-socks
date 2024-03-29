`default_nettype none
module ultra_sonic_tb();
  // Inputs from nios.
  logic clk, reset, addr;

  // Outputs to nios
  logic [31:0] read;
  logic echo, trigger, read_data_valid;

  ultra_sonic DUT(
      // inputs
      .clk(clk),
      .reset_l(~reset),

      // outputs
      .read_data(read),
      .read_data_valid(read_data_valid),

      .echo(echo),
      .trigger(trigger)
    );

  initial begin
    addr = 1;
    reset = 1;
    #1 clk = 0;
    #1 clk = 1;
    reset = 0;
    #1 clk = 0;
    #1 clk = 1;

    for(int j=0; j < 5; j++) begin
      // Trigger high, low and wait.
      for (int i = 0; i < 1500; i++) begin
        #1 clk = ~clk;
      end

      echo = 1;

      // Echo high
      for (int i = 0; i < j * 5000; i++) begin
        #1 clk = ~clk;
      end

      echo = 0;

      // Wait out stall.
      for (int i = 0; i < 2*(2**16); i++) begin
        #1 clk = ~clk;
      end

    end
  end
endmodule
