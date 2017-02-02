
/// TESTBENCH ///
module GraphicsController_tb();

	logic clk, Reset_L;
	logic AS_L, UDS_L, LDS_L, RW;
	logic [15:0] AddressIn, DataInFromCPU;

	logic GraphicsCS_L, VSync_L;
  	logic [15:0] SRam_DataIn;

	logic [9:0] VScrollValue, HScrollValue;

	logic [15:0] DataOutToCPU;

	logic [17:0] Sram_AddressOut;
	logic [15:0] Sram_DataOut;

	logic Sram_UDS_Out_L, Sram_LDS_Out_L, Sram_RW_Out;

	logic [7:0] ColourPalletteAddr;
	logic [31:0] ColourPalletteData;
	logic ColourPallette_WE_H;

	GraphicsController graphics(

			// Signals from CPU.
			.AddressIn(AddressIn),
			.DataInFromCPU(DataInFromCPU),

			.Clk(clk),
			.Reset_L(Reset_L),

			.AS_L(AS_L),
			.UDS_L(UDS_L),
			.LDS_L(LDS_L),
			.RW(RW),

			// VGA display driver signals.
			.GraphicsCS_L(GraphicsCS_L),
			.VSync_L(VSync_L),
			.SRam_DataIn(SRam_DataIn),

			// Scroll offset signal -- disabled.
			.VScrollValue(VScrollValue),
			.HScrollValue(HScrollValue),
			.DataOutToCPU(DataOutToCPU),

			// Memory output signals.
			.Sram_AddressOut(Sram_AddressOut),
			.Sram_DataOut(Sram_DataOut),

			.Sram_UDS_Out_L(Sram_UDS_Out_L),
			.Sram_LDS_Out_L(Sram_LDS_Out_L),
			.Sram_RW_Out(Sram_RW_Out),

			.ColourPalletteAddr(ColourPalletteAddr),
			.ColourPalletteData(ColourPalletteData),
			.ColourPallette_WE_H(ColourPallette_WE_H)
		);

		initial begin
    	Reset_L = 0;
			AS_L = 0;
			GraphicsCS_L = 0;
			RW = 0;
			DataInFromCPU = 16'b0000000000000001; // Process command.
			UDS_L = 0;
			LDS_L = 0;
			clk = 0;
			#10 clk = 1;
      Reset_L = 1;
			#10 clk = 0;
      LDS_L = 1;
      AS_L = 1;
			#10 clk = 1;
			#10 clk = 0;
      #10 clk = 1;
      #10 clk = 0;
      #10 clk = 1;
      #10 clk = 0;

			// Load X1 //
			AS_L = 0;
			AddressIn = 8'b00000010; // Specify X1_Select
			#10 clk = 1;
			#10 clk = 0;
			LDS_L = 0;
			// Load Y1.
			AS_L = 1;
			AddressIn = 8'b00000100; // Specify Y1_Select
			#10 clk = 1;
			#10 clk = 0;
			AS_L = 0;
			#10 clk = 1;
			#10 clk = 0;

			// Load X2. //
			AS_L = 1;
			AddressIn = 8'b00000110; // Specify X2_Select
			#10 clk = 1;
			#10 clk = 0;
      // This is X2 data (8)
			DataInFromCPU = 800;
			AS_L = 0;
			#10 clk = 1;
			#10 clk = 0;
      AS_L = 1;
      #10 clk = 1;
			#10 clk = 0;

			// Load Y2 //
			AS_L = 1;
			AddressIn = 8'b00001000; // Specify Y2_Select
			#10 clk = 1;
			#10 clk = 0;
      // This is Y2 data (6)
			DataInFromCPU = 500;
			AS_L = 0;
			#10 clk = 1;
			#10 clk = 0;
      AS_L = 1;
      #10 clk = 1;
			#10 clk = 0;

			// Send Line command //
      AS_L = 0;
			AddressIn = 8'b00000000; // Specify command select.
      DataInFromCPU = 16'b0000000000000011; // Draw LINE
      // Should push to state three.
			#10 clk = 1;
			#10 clk = 0;
      AS_L = 1; // Load command
      #10 clk = 1;
			#10 clk = 0;
      #10 clk = 1;
      AS_L = 0;

		end

		always begin
			#10
			clk = ~clk;
		end
endmodule
