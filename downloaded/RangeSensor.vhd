library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.numeric_std.all;

entity RangeSensor is
	port
	(
		fpgaclk		  	: 	in std_logic;
		pulse	  			: 	in std_logic;
		triggerOut	  	:	out std_logic;
		meters	  		: 	out std_logic_vector(3 downto 0);
		decimeter 		: 	out std_logic_vector(3 downto 0);
		centimeter 		: 	out std_logic_vector(3 downto 0)
	);
end entity;

architecture behavioral of RangeSensor is

component Distance_Calcualtion is
	port
	(
		clk		  					: in std_logic;
		calculation_reset	  		: in std_logic;
		pulse	  						: in std_logic;
		distance		  				: out std_logic_vector (8 downto 0)
	);
end component;

component TriggerGenerator is
	port
	(
		clk		  			: in std_logic;
		trigger	  			: out std_logic
	);

end component;


component BCDconverter is

	port
	(
		DistanceInput		  	: in std_logic_vector(8 downto 0);
		hundreds	  				: out std_logic_vector(3 downto 0);
		tens	  					: out std_logic_vector(3 downto 0);
		unit	  					: out std_logic_vector(3 downto 0)
	);

end component;


signal distanceout: std_logic_vector (8 downto 0);
signal triggout : std_logic;

begin 

trigger_gen : TriggerGenerator port map (
clk =>fpgaclk,
trigger=>triggout
);

pulsewidth : Distance_Calcualtion port map (
clk =>fpgaclk,
calculation_reset => triggout,
pulse=>pulse,
distance=>distanceout
);

BCDCov : BCDconverter port map (
DistanceInput=>distanceout,
hundreds=>meters,
tens=>decimeter,
unit=>centimeter);

triggerOut<= triggout;
	
end behavioral;
