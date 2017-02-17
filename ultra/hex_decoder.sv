module hex_decoder (hex_code, value);

input [6:0] hex_code;
output [4:0] value;

always_comb begin
    case (hex_code)
        7'b1000000: value = 4'b0000;
        7'b1111001: value = 4'b0001;
        7'b0100100: value = 4'b0010;
        7'b0110000: value = 4'b0011;
        7'b0011001: value = 4'b0100;
        7'b0010010: value = 4'b0101;
        7'b0000010: value = 4'b0110;
        7'b1111000: value = 4'b0111;
        7'b0000000: value = 4'b1000;
        7'b0011000: value = 4'b1001;
        7'b1000000: value = 4'b1010;
        7'b1111001: value = 4'b1011;
        7'b0100100: value = 4'b1100;
        7'b0110000: value = 4'b1101;
        7'b0011001: value = 4'b1110;
        7'b0010010: value = 4'b1111;

        default: value = 4'b1111;
    endcase
end

endmodule // hex_decoder
