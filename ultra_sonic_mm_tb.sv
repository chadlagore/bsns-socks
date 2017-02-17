// `default_nettype none
module ultra_sonic_tb();
  // Inputs from nios.
  logic clk, reset, addr;

  // Outputs to nios
  logic [31:0] read;
  logic echo, trigger, read_data_valid, ioselect;
  logic [15:0] address;
  //logic [9:0] leds;

  avalon_distance_module_interface DUT(
      // inputs
      .clk(clk),
      .reset_l(~reset),
      .io_select(ioselect),
      .address(address),

      // outputs
      .read_data(read),

      .echo(echo),
      .trigger(trigger)
      //.LEDR(leds)
    );

  initial begin
    addr = 1;
    reset = 1;
    #1 clk = 0;
    #1 clk = 1;
    reset = 0;
    #1 clk = 0;
    #1 clk = 1;
    echo = 0;

    for (int j = 0; j < 5; j++) begin
        for (int i = 0; i < 1500; i++) begin
            #1 clk = ~clk;
        end

        echo = 1;

        // Echo high
        for (int i = 0; i < j*500000; i++) begin
        #1 clk = ~clk;
        end

        echo = 0;

        // Wait out stall.
        for (int i = 0; i < 2*(2**21); i++) begin
        #1 clk = ~clk;
        end

        ioselect = 1;
        address = 16'h0900;

        // Trigger high, low and wait.
        for (int i = 0; i < 50; i++) begin
        #1 clk = ~clk;
        end

        ioselect = 0;
    end
  end
endmodule
