-- Quartus II VHDL Template
-- Binary Counter

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity segmentdecoder is

	port
	(
		digit		  : in std_logic_vector (3 downto 0);
		segmentA	  : out std_logic;
		segmentB	  : out std_logic;
		segmentC	  : out std_logic;
		segmentD	  : out std_logic;
		segmentE	  : out std_logic;
		segmentF	  : out std_logic;
		segmentG	  : out std_logic
		
	);

end entity;

architecture rtl of segmentdecoder is
begin 
process(digit)
variable decode_data : std_logic_vector (6 downto 0);

begin
	case digit is 
		when "0000" => decode_data := "1111110";
		when "0001" => decode_data := "0110000";
		when "0100" => decode_data := "1101101";
		when "0101" => decode_data := "1011011";
		when "0110" => decode_data := "1011111";
		when "0111" => decode_data := "1110000";
		when "1000" => decode_data := "1111111";
		when "1001" => decode_data := "1111011";
		when "1010" => decode_data := "1110111";
			when "1011" => decode_data := "0011111";
		when "1100" => decode_data := "1001110";
		when "1101" => decode_data := "0011111";
		when "1110" => decode_data := "1001111";
		when "1111" => decode_data := "1000111";
		when others => decode_data := "0111110";
	end case;
		
segmentA <= not decode_data(6);
segmentB <= not decode_data(5);
segmentC <= not decode_data(4);
segmentD <= not decode_data(3);
segmentE <= not decode_data(2);
segmentF <= not decode_data(1);
segmentG <= not decode_data(0);

end process;
end rtl;
