library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
	port( 
		entrada1  : in unsigned(15 downto 0);
		entrada2  : in unsigned(15 downto 0);
		seletor   : in unsigned(1 downto 0); 
		saida     : out unsigned(15 downto 0)	    
	);
end entity;

architecture a_ula of ula is
begin
	saida <= entrada1                when seletor="00" else --MOV acc
		 entrada2   		 when seletor="01" else --MOV bdr
		 (entrada1 + entrada2)   when seletor="10" else --ADD
		 (entrada1 - entrada2)   when seletor="11";     --SUB
end architecture;

