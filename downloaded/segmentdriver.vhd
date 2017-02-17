-- Quartus II VHDL Template
-- Binary Counter

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity segmentdriver is

	port
	(
		clk		  : in std_logic;
		segA	  : out std_logic;
		segB	  : out std_logic;
		segC	  : out std_logic;
		segD	  : out std_logic;
		segE	  : out std_logic;
		segF	  : out std_logic;
		segG	  : out std_logic;
	
		Select_DisplayA	  : out std_logic;
		Select_DisplayB	  : out std_logic;
		Select_DisplayC	  : out std_logic;
		Select_DisplayD	  : out std_logic;
	
		displayA	  : in std_logic_vector (3 downto 0);
		displayB	  : in std_logic_vector (3 downto 0);
		displayC	  : in std_logic_vector (3 downto 0);
		displayD	  : in std_logic_vector (3 downto 0)
		
	);

end entity;

architecture rtl of segmentdriver is

component segmentdecoder is

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

end component;
component clockdivider is

	port
	(
		clk		  : in std_logic;
		enable	  : in std_logic;
		reset	  : in std_logic;
		dataclk	  : out std_logic_vector (15 downto 0)
	);

end component;
Signal temperary_data : std_logic_vector(3 downto 0);
signal clock_word : std_logic_vector (15 downto 0);
signal slow_clock : std_logic;

begin 

uut: segmentdecoder port map
	(
		digit		  => temperary_data,
		segmentA	  => segA,
		segmentB	  => segB,
		segmentC	  => segC,
		segmentD	  => segD,
		segmentE	  => segE,
		segmentF	  => segF,
		segmentG	  => segG	
	);

uu1: clockdivider  port map
	(
		clk => clk,
		enable	  => '1',
		reset	  => '0',
		dataclk	  => clock_word
		
	);

slow_clock <= clock_word(15);
process (slow_clock)
	variable display_selection: std_logic_vector (1 downto 0);
begin
	if slow_clock = '1' and slow_clock'event then 
	
		case display_selection is 
			when "00" => temperary_data <= displayA;
			
				Select_DisplayA <= '0';
				Select_DisplayB <= '1';
				Select_DisplayC <= '1';
				Select_DisplayD <= '1';
				display_selection := display_selection +'1' ;
			when "01" => temperary_data <= displayB;
			
				Select_DisplayA <= '1';
				Select_DisplayB <= '0';
				Select_DisplayC <= '1';
				Select_DisplayD <= '1';
				display_selection := display_selection +'1' ;
			when "10" => temperary_data <= displayC;
			
				Select_DisplayA <= '1';
				Select_DisplayB <= '1';
				Select_DisplayC <= '0';
				Select_DisplayD <= '1';
				display_selection := display_selection +'1' ;
			when others => temperary_data <= displayD;
			
				Select_DisplayA <= '1';
				Select_DisplayB <= '1';
				Select_DisplayC <= '1';
				Select_DisplayD <= '0';
				display_selection := display_selection +'1' ;
			end case;
			
end if ;
end process ;
end rtl;
