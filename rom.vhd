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
		0  => B"0000000000000_000",
		--A. Carrega R3 (o registrador 3) com o valor 5
        	1  => B"0000000101_011_011",    -- li r3, 5
        	--B. Carrega R4 com 8
		2  => B"0000001000_100_011",    -- li r4, 8
        	--C. Soma R3 com R4 e guarda em R5
		3  => B"0000_101_100_011_001",  -- add r5, r4, r3
		--D. Subtrai 1 de R5
        	4  => B"000001_101_1_101_010",  -- subi r5, r5, 1
		--E. Salta para o endereço 20   
     	   	5  => B"0000000010100_100",	-- jal r0, 20
		--F. Zera R5 (nunca será executada)
       		6  => B"000_101_101_0_101_010", -- sub r5, r5, r5
    	    	20 => B"0000_101_100_011_001",
        	21 => B"0000100000000_000",
        	22 => B"0000100100000_000",
		23 => B"0000100100000_000",
                24 => B"0000100100000_000",
                25 => B"0000100100000_000",
                26 => B"0000100100000_000",
                27 => B"0000100100000_000",
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

