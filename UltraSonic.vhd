-- Quartus II VHDL Template
-- Binary Counter

library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity UltraSonic is

	port
	(
		CLOCK_50		  				: in std_logic;
		GPIO_0	  				: inout std_logic_vector(35 downto 34);
		HEX0,HEX1,HEX2,HEX3		: out std_logic_vector(6 downto 0)
	);

end entity;

architecture rtl of UltraSonic is

component RangeSensor is
	port
	(
		fpgaclk		  : in std_logic;
		pulse	  		: in std_logic;
		triggerOut	  :out std_logic;
		meters	  		: out std_logic_vector(3 downto 0);
		decimeter : out std_logic_vector(3 downto 0);
		centimeter : out std_logic_vector(3 downto 0)
		);
end component;
component seg7    -- integer to seven seg
		port(
		        m: in std_logic_vector (3 downto 0);
				  num: out std_logic_vector(6 downto 0)
			  );
      end component;



Signal Ai: std_logic_vector (3 downto 0);
Signal Bi: std_logic_vector (3 downto 0);
Signal Ci: std_logic_vector (3 downto 0);
Signal Di: std_logic_vector (3 downto 0);

Signal sensor_meter: std_logic_vector (3 downto 0);
Signal sensor_centimeter: std_logic_vector (3 downto 0);
Signal sensor_decimeter: std_logic_vector (3 downto 0);

begin
	
uu3: RangeSensor port map
	(
		fpgaclk		  => CLOCK_50,
		pulse	  		=> GPIO_0(35),
		triggerOut	  => GPIO_0(34),
		meters	  		=> sensor_meter,
		decimeter => sensor_decimeter,
		centimeter => sensor_centimeter
	);
		
		Ai <= sensor_centimeter;
		Bi <= sensor_decimeter;
		Ci <= sensor_meter;
		Di <= "0000";
		
		z0: seg7 port map(Ai,HEX0);
		z1: seg7 port map(Bi,HEX1);
		z2: seg7 port map(Ci,HEX2);
		z3: seg7 port map(Di,HEX3);
		

end rtl;
