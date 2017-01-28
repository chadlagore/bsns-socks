module GraphicsController_tb();

	logic clk, reset_l;
	logic AS_L, UDS_L, LDS_L, RW;
	logic [15:0] AddressIn, DataInFromCPU;

	logic GraphicsCS_L, VSync_L, SRam_DataIn;

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
			.GraphicsCS_L(GraphicsCS_L)
			.VSync(VSync_L),
			.SRam_DataIn(SRam_DataIn),

			// Scroll offset signal -- disabled.
			.VScrollValue(VScrollValue),
			.HScrollValue(HScrollValue),
			.DataOutToCPU(DataOutToCPU),

			// Memory output signals.
			.Sram_AddressOut(Sram_AddressOut),
			.Sram_DataOut(Sram_DataOut)

			.Sram_UDS_Out_L(Sram_UDS_Out_L),
			.Sram_UDS_Out_L(Sram_LDS_Out_L),
			.Sram_RW_Out(Sram_RW_Out),

			.ColourPalletteAddr(ColourPalletteAddr),
			.ColourPalletteData(ColourPalletteData),
			.ColourPallette_WE_H(ColourPallette_WE_H)
		);

		initial begin
			clk = 0;
			reset = 1;
			#1 clk = 1;
			#0 clk = 0;
			#1 clk = 1;
			reset = 0;
		end

		always begin
			clk = ~clk;
		end
endmodule
