library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
--use ieee.numeric_std.all;
--use ieee.numeric_std.all;

entity TriggerGenerator is

	port
	(
		clk		  : in std_logic;
		trigger	  		: out std_logic
	);

end entity;

architecture behavioral of TriggerGenerator is
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

signal reset_counter : std_logic ;
signal outputcounter : std_logic_vector (23 downto 0);

begin 
	trigg : binary_counter generic map (24) port map (
	clk		  => clk, 
	enable => '1', 
	reset =>reset_counter,
	q=>outputcounter
	); 
	process (clk)
		constant ms250 :std_logic_vector (23 downto 0):= "101111101011110000100000";
		--constant ms250 :std_logic_vector (23 downto 0):= "001011011100011011000000";
		constant ms250add100us :std_logic_vector (23 downto 0):= "101111101100111110101000";
		--constant ms250add100us :std_logic_vector (23 downto 0):= "001011011100100010110100";
		begin 
			if (outputcounter > ms250 and outputcounter < ms250add100us) then
				trigger<= '1';
			else
				trigger<= '0';
			end if ;
			if (outputcounter =ms250add100us or outputcounter ="XXXXXXXXXXXXXXXXXXXXXXXX" ) then
				reset_counter <= '0';
			else
				reset_counter <='1';
			end if;
		end process;
		
end behavioral;
