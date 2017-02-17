module car_counter_tb();
    logic clk, reset_l, calibrate;
    logic [15:0] distance;
    logic distance_ready;
    logic car;
    logic [15:0] car_count;
    logic [15:0] address;
    logic io_select;

    parameter DISTANCE = 16'h0900;
	parameter BROKEN = 16'h0904;
    parameter CARCOUNT = 16'h0908;
    parameter CAR = 16'h090C;

    car_counter cc(
            .clk(clk),
            .reset_l(reset_l),
            .distance(distance),
            .distance_ready(distance_ready),
            .car_count(car_count),
            .calibrate(1'b1),
            .car(car),
            .address(address),
            .io_select(io_select)
        );

    initial begin
        clk = 0;
        reset_l = 0;
        #1 clk = 1;
        reset_l = 1;

        for(int j=0; j<2; j++) begin

            distance = 10;
            distance_ready = 1;

            #1 clk = 0;
            #1 clk = 1;

            for (int i=0; i<10; i++) begin
                #1 clk = ~clk;
                distance_ready = ~distance_ready;
            end

            distance = 8;

            for (int i=0; i<10; i++) begin
                #1 clk = ~clk;
                distance_ready = ~distance_ready;
            end

            distance = 7;

            for (int i=0; i<10; i++) begin
                #1 clk = ~clk;
                distance_ready = ~distance_ready;
            end

            distance = 11;

            for (int i=0; i<10; i++) begin
                #1 clk = ~clk;
                distance_ready = ~distance_ready;
            end

            distance = 4;

            for (int i=0; i<10; i++) begin
                #1 clk = ~clk;
                distance_ready = ~distance_ready;
            end

            distance = 7;
        end


        #1 clk = ~clk;
        #1 clk = ~clk;
        #1 clk = ~clk;

        address = CARCOUNT;
        io_select = 1'b1;

        #1 clk = ~clk;
        #1 clk = ~clk;

        address = 0;
        io_select = 0;

        for(int j=0; j<2; j++) begin

            distance = 10;
            distance_ready = 1;

            #1 clk = 0;
            #1 clk = 1;

            for (int i=0; i<10; i++) begin
                #1 clk = ~clk;
                distance_ready = ~distance_ready;
            end

            distance = 8;

            for (int i=0; i<10; i++) begin
                #1 clk = ~clk;
                distance_ready = ~distance_ready;
            end

            distance = 7;

            for (int i=0; i<10; i++) begin
                #1 clk = ~clk;
                distance_ready = ~distance_ready;
            end

            distance = 11;

            for (int i=0; i<10; i++) begin
                #1 clk = ~clk;
                distance_ready = ~distance_ready;
            end

            distance = 4;

            for (int i=0; i<10; i++) begin
                #1 clk = ~clk;
                distance_ready = ~distance_ready;
            end

            distance = 7;
        end

    end
endmodule
