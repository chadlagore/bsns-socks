-- Quartus II VHDL Template
-- Binary Counter

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity binary_counter is

	generic
	(
		MAX_COUNT : Positive := 10
	);

	port
	(
		clk		  : in std_logic;
		enable	  : in std_logic;
		reset	  : in std_logic;
		q		  : out std_logic_vector (MAX_COUNT -1 downto 0)
	);

end entity;

architecture rtl of binary_counter is
signal   cnt		   : std_logic_vector (MAX_COUNT -1 downto 0);
begin

	process (clk,reset)
		
	begin
			if reset = '0' then
				-- Reset the counter to 0
				cnt <= (others=>'0');
			elsif clk'event and clk='1' then 
				if enable = '1' then
				-- Increment the counter if counting is enabled			   
					cnt <= cnt + 1;
				end if;
			end if;

		-- Output the current count
	end process;
	q <= cnt;
end rtl;
