library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seg7 is

port(m: in std_logic_vector (3 downto 0);
     num: out std_logic_vector(6 downto 0));
end seg7;

architecture s7 of seg7 is
begin
process(m)
begin
case m is
when "0000" => num<="1000000";
when "0001" => num<="1111001";
when "0010" => num<="0100100";
when "0011" => num<="0110000";
when "0100" => num<="0011001";
when "0101" => num<="0010010";
when "0110" => num<="0000010";
when "0111" => num<="1111000";
when "1000" => num<="0000000";
when "1001" => num<="0010000";
when others=> num<="1111111";
end case;
end process;
end s7;