library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Distance_Calcualtion is

	port
	(
		clk		  : in std_logic;
		calculation_reset	  		: in std_logic;
		pulse	  : in std_logic;
		distance		  : out std_logic_vector (8 downto 0)
	);

end entity;

architecture behavioral of Distance_Calcualtion is
component binary_counter is
generic
	(
		MAX_COUNT : positive := 10
	);

	port
	(
		clk		  : in std_logic;
		reset	  : in std_logic;
		enable	  : in std_logic;
		q		  : out std_logic_vector (MAX_COUNT -1 downto 0)
	);
end component;

signal pulse_width : std_logic_vector (21 downto 0);

begin
	CounterPulse : binary_counter generic map (22) port map (clk, pulse, not calculation_reset,pulse_width);  
	
	Distance_Calculation: process(pulse)
		variable result: integer;
		variable multiplier: std_logic_vector (23 downto 0);
		begin
			if pulse = '0' then
				multiplier := pulse_width * "11";
			--measure the width in micrsecond and devide it by 58 to calculate distance in centimeter. 
			-- FPGA clock = 50Hz -> 20ns. expression * 20/1000 microseconds. in fpga decvision need to be done by shift and subtract method.
			--	multiply by 3 and shift the expression 13 position to the right this will give result of 11 bit signal.
				result := to_integer (unsigned (multiplier (23 downto 13)));
				if (result = 458) then
					distance <="111111111";
				else
					distance <= std_logic_vector (to_unsigned (result,9));
				end if ;	
			end if ;
			
	end process Distance_Calculation;

end behavioral;
