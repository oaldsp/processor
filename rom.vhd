library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
	port( 
		clk      : in  std_logic;
	      	address : in  unsigned(6 downto 0);
		data 	 : out unsigned(15 downto 0)
	);
end entity;

architecture a_romof of rom is 
	type mem is array (0 to 127) of unsigned(15 downto 0);
	--  00000000|0000000            |0
	--  conteudo|endereco para pular|pula ou não
	constant content_rom : mem := (
		0 => "0000000000000000",
        	1 => "0000000100001011",
        	2 => "0000001000000000",
        	3 => "0000001100000000",
        	4 => "0000010000000000",
     	   	5 => "0000010100000000",
       		6 => "0000011000000000",
    	    	7 => "0000011100000001",
        	8 => "0000100000000000",
        	9 => "0000100100000000",
		others => (others=>'0')
	);
begin
	process(clk)
	begin                              --Aqui é "falling" e nao "rising" para sincronizar
		if(falling_edge(clk)) then --com a o flipflop da UC que esta em "rising"
			data <= content_rom(to_integer(address));
		end if;
	end process;
end architecture;	

