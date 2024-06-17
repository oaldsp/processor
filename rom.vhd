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
	constant content_rom : mem := (
		0  => B"000000000101_0011",	-- li r3, 5
		--Caregando acumulador com 30 para escrever na RAM
		1  => B"000000011110_0011",     -- li a, 30
		--Passa o valor do acumulador para RAM no endereço 20
                2  => B"00000_0010100_1001",   -- sw 20, a
		--Caregando acumulador com 23 para escrever na RAM
                3  => B"000000010111_0011",     -- li a, 23
                --Passa o valor do acumulador para RAM no endereço 55
		4  => B"00000_0110111_1001",   -- sw 55, a
		--Passa o valor da RAM no endereço 20 para o r3
                5  => B"00_0010100_011_1000",   -- lw 20, a
		--Carregando r2 com 30 para ser usado no CMP
		--4  => B"000000011110_0011",     -- li a, 30
                --5  => B"00000000_1_010_0101",   -- mov r2, a
		--A. Carrega R3 (o registrador 3) com o valor 0
		--6  => B"000000000000_0011",    	-- li a, 0
                --14  => B"00000000_1_011_0101",   -- mov r3, a
		--B. Carrega R4 com 0
		--15  => B"000000000000_0011",    	-- li a, 0
                --16  => B"00000000_1_100_0101",   -- mov r4, a
		--C. Soma R3 com R4 e guarda em R4
		--17  => B"00000000_0_011_0101",   -- mov a, r3
                --18  => B"000000000_100_0001",    -- add a, r4
                --19  => B"00000000_1_100_0101",   -- mov r4, a
		--D. Soma 1 em R3
		--20 => B"000000000001_0011",    	-- li a, 1
		--21 => B"000000000_011_0001",    -- add a, r3
		--22 => B"00000000_1_011_0101",   -- mov r3, a
		--Se R3<30 salta para a instrução do passo C
		--23 => B"000000000_010_0111",    -- cmp r2, a
                --24 => B"0_11_11111001_1_0100",  -- jr z, -7
		--F. Copia valor de R4 para R5
		--25 => B"00000000_0_100_0101",   -- mov a, r4
		--26 => B"00000000_1_101_0101",   -- mov r5, a
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

