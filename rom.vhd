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
		0  => B"0000000000101_011",	-- li r3, 5(NAO FUNCIONA)
		--A. Carrega R3 (o registrador 3) com o valor 0
		1  => B"0000000000000_011",    	-- li a, 0
                2  => B"000000000_1_011_101",   -- mov r3, a
		--B. Carrega R4 com 0
		3  => B"0000000000000_011",    	-- li a, 0
                4  => B"000000000_1_100_101",   -- mov r4, a
		--C. Soma R3 com R4 e guarda em R4
		5  => B"000000000_0_011_101",   -- mov a, r3
                6  => B"0000000000_100_001",    -- add a, r4
                7  => B"000000000_1_100_101",   -- mov r4, a
		--D. Soma 1 em R3
		8  => B"0000000000001_011",    	-- li a, 1
		9  => B"0000000000_011_001",    -- add a, r3
		10 => B"000000000_1_011_101",   -- mov r3, a
		--Se R3<30 salta para a instrução do passo C
	       	11 => B"0000000000001_011",    -- li a, 30
		12 => B"000000000_1_001_101",   -- mov r1, a
		13 => B"0000000000_001_111",    -- cmp r1, a
                14 => B"111111110111_1_100",    -- jr z, -9
		--A. Carrega R3 (o registrador 3) com o valor 5
        	--1  => B"0000000000101_011",    -- li a, 5
		--2  => B"000000000_1_011_101",   -- mov r3, a
        	--B. Carrega R4 com 8
		--3  => B"0000000001000_011",    -- li a, 8
		--4  => B"000000000_1_100_101",   -- mov r4, a
        	--C. Soma R3 com R4 e guarda em R5
		--5  => B"000000000_0_011_101",   -- mov a, r3
		--6  => B"0000000000_100_001",    -- add a, r4
		--7  => B"000000000_1_101_101",   -- mov r5, a
  		--D. Subtrai 1 de R5
        	--8  => B"00000000000_1_1_010",  -- subi a, 1
		--9  => B"000000000_1_101_101",  -- mov r5, a
		--E. Salta para o endereço 20   
     	   	--10  => B"0000000010100_100",	-- jmp 20
		--F. Zera R5 (nunca será executada)
       		--11  => B"000000000_101_0_010", -- sub a, r5
		--12  => B"000000000_1_101_101", -- mov r5, a
		--G. No endereço 20, copia R5 para R3
		--20  => B"000000000_0_101_101",   -- mov a, r5
		--21  => B"000000000_1_011_101",   -- mov r4, a
		--H. Salta para o passo C desta lista (R5 <= R3+R4)
        	--22 => B"0000000000011_100",     -- jmp 3
		--I. Zera R3 (nunca será executada)
		--23  => B"0000000000000_011",    -- li a, 0
		--24  => B"000000000_1_011_101",   -- mov r5, a
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

