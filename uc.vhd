library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
	port(
		dataI : in unsigned(6 downto 0);
	      	dataO : out unsigned(6 downto 0)
	);
end entity;

architecture a_uc of uc is
begin
	dataO<=dataI+"0000001";
end architecture a_uc;
