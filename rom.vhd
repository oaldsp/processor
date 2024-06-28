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
		--Testando flag de Carry
                --Carregando r1 com 5 para ser usado no CMP
                1  => B"000000000101_0011",     -- li a, 5
                2  => B"00000000_1_001_0101",   -- mov r1, a
                --Caregando acumulador com 8 
                3  => B"000000001000_0011",     -- li a, 8
                --Subtrai 1 no acumulador
                4  => B"00000000001_1_0010",  	-- sub 1, a
                --Se r1 - a tem carry
                5  => B"000000000_001_0111",    -- cmp r1, a
                6  => B"0_00_11111110_1_0100", 	-- jr c, -2
		7  => B"00000000_1_010_0101",   -- mov r2, a

		--Testando flag overflow
                8  => B"111111111111_0011",     -- li a, 2047
                9  => B"00000000_1_010_0101",   -- mov r2, a
                --Soma r2 + a
                10 => B"000000000_010_0001",    -- add a, r2
		-- Vai dobrando até dar Overflow 
                12 => B"000000000_010_0111",    -- cmp r2, a
                13 => B"0_10_11111101_1_0100",  -- jr o, -3
                14 => B"00000000_1_001_0101",  -- mov r1, a

		--Testando flag de Negative
                --Carregando r1 com 5 para ser usado no CMP
                15 => B"000000000101_0011",     -- li a, 5
                16 => B"00000000_1_001_0101",   -- mov r1, a
                --Caregando acumulador com 8
                17 => B"000000001000_0011",     -- li a, 8
                --Subtrai 1 no acumulador
                18 => B"00000000001_1_0010",    -- sub 1, a
                --Se r1 - a tem carry
                19 => B"000000000_001_0111",    -- cmp r1, a
                20 => B"0_01_11111110_1_0100",  -- jr n, -2
                21 => B"00000000_1_010_0101",   -- mov r2, a

		-- SUBB
		--  10|01 (5)
		-- -00|11 (3)
		-- ------
  		--  01|10 (2)
		--01 - 11
                --1 => B"000000000001_0011", -- li a, 1
		--2 => B"00000000011_1_0010", -- subb 3, a
		--4  => B"00000000_1_010_0101",   -- mov r2, a
		--
		--1 => B"000000000001_0011", -- li a, 1
                --2 => B"00000000011_1_0010", -- subb 3, a


		
		--1)Colocando os numeros de 1 a 32 na RAM
		--1.1)Carregando r1 com 33 para ser usado no CMP
                --1  => B"000000100001_0011",     -- li a, 33
                --2  => B"00000000_1_001_0101",   -- mov r1, a
		--1.2)Carregando r2 com 1 para ficar incrementando acumulador
		--3  => B"000000000001_0011",     -- li a, 1
                --4  => B"00000000_1_010_0101",   -- mov r2, a
		--1.3)Caregando acumulador com 1 para começar loop
                --5  => B"000000000001_0011",     -- li a, 1
		--1.4)Passa o valor do acumulador para o r3 para usar no RAM address
		--6  => B"00000000_1_011_0101",   -- mov r3, a
		--1.5)Passa o valor do acumulador para RAM no endereço r3
                --7  => B"000000000_011_1001",    -- sw r3, a
                --1.6)Soma 1 no acumulador
		--8  => B"000000000_010_0001",    -- add a, r1
		--1.7)Se a<33 salta para a 1.4 
		--9  => B"000000000_001_0111",    -- cmp r1, a
                --10 => B"0_11_11111100_1_0100",  -- jr z, -4
		
		--2)Eliminar multiplos de 2
		--2.1)Carregando r1 com 34 para ser usado no CMP
                --11  => B"000000100010_0011",    -- li a, 34
                --12  => B"00000000_1_001_0101",  -- mov r1, a
		--2.2)Carregando r2 com 4 para navegar na RAM
                --13 => B"000000000100_0011",     -- li a, 4
                --14 => B"00000000_1_010_0101",   -- mov r2, a
		--2.3)Zera acumulador
		--15 => B"000000000000_0011",     -- li a, 0
		--2.4)Passa o valor do a para RAM no endereço r2
                --16 => B"000000000_010_1001",    -- sw r2, a
		--2.5)Incremente r2 em 2
		--17 => B"000000000010_0011",     -- li a, 2
		--18 => B"000000000_010_0001",    -- add a, r2
		--19 => B"00000000_1_010_0101",   -- mov r2, a
		--2.6)Se a<34 salta para a 2.3
                --20 => B"000000000_001_0111",    -- cmp r1, a
                --21 => B"0_11_11111010_1_0100",  -- jr z, -6
		--NOP para provar que funciona
		--22 => B"0000000000000000",      -- nop
		
		--3)Eliminar multiplos de 3
                --3.1)Carregando r1 com 33 para ser usado no CMP
                --23  => B"000000100001_0011",    -- li a, 33
                --24  => B"00000000_1_001_0101",  -- mov r1, a
                --3.2)Carregando r2 com 6 para navegar na RAM
                --25 => B"000000000110_0011",     -- li a, 6
                --26 => B"00000000_1_010_0101",   -- mov r2, a
                --3.3)Zera acumulador
                --27 => B"000000000000_0011",     -- li a, 0
                --3.4)Passa o valor do a para RAM no endereço r2
                --28 => B"000000000_010_1001",    -- sw r2, a
                --3.5)Incremente r2 em 3
                --29 => B"000000000011_0011",     -- li a, 3
                --30 => B"000000000_010_0001",    -- add a, r2
                --31 => B"00000000_1_010_0101",   -- mov r2, a
                --3.6)Se a<33 salta para a 2.3
                --32 => B"000000000_001_0111",    -- cmp r1, a
                --33 => B"0_11_11111010_1_0100",  -- jr z, -6
                --NOP para provar que funciona
                --34 => B"0000000000000000",      -- nop
		
		--4)Eliminar multiplos de 5
                --4.1)Carregando r1 com 35 para ser usado no CMP
                --35  => B"000000100011_0011",    -- li a, 35
                --36  => B"00000000_1_001_0101",  -- mov r1, a
                --4.2)Carregando r2 com 10 para navegar na RAM
                --37 => B"000000001010_0011",     -- li a, 10
                --38 => B"00000000_1_010_0101",   -- mov r2, a
                --4.3)Zera acumulador
                --39 => B"000000000000_0011",     -- li a, 0
                --4.4)Passa o valor do a para RAM no endereço r2
                --40 => B"000000000_010_1001",    -- sw r2, a
                --4.5)Incremente r2 em 5
                --41 => B"000000000101_0011",     -- li a, 5
                --42 => B"000000000_010_0001",    -- add a, r2
                --43 => B"00000000_1_010_0101",   -- mov r2, a
                --4.6)Se a<35 salta para a 2.3
                --44 => B"000000000_001_0111",    -- cmp r1, a
                --45 => B"0_11_11111010_1_0100",  -- jr z, -6
                --NOP para provar que funciona
                --46 => B"0000000000000000",      -- nop

		--5)Ler RAM 
		--5.1)Carregando r1 com 33 para ser usado no CMP
                --47 => B"000000100001_0011",     -- li a, 33
                --48 => B"00000000_1_001_0101",   -- mov r1, a
                --5.2)Carregando r2 com 1 para ficar incrementando acumulador
                --49 => B"000000000001_0011",     -- li a, 1
                --50 => B"00000000_1_010_0101",   -- mov r2, a
                --5.3)Caregando acumulador com 1 para começar loop
                --51 => B"000000000001_0011",     -- li a, 1
                --5.4)Passa o valor do acumulador para o r3 para usar no RAM address
                --52 => B"00000000_1_011_0101",   -- mov r3, a
                --5.5)Passa o valor da RAM para r4 no endereço r3
                --53 => B"000000_011_100_1000",   -- lw r4, (r3)
                --5.6)Soma 1 no acumulador
                --54 => B"000000000_010_0001",    -- add a, r1
                --5.7)Se a<33 salta para a 1.4
                --55 => B"000000000_001_0111",    -- cmp r1, a
                --56 => B"0_11_11111100_1_0100",  -- jr z, -4
		
		--Testando operações que faltaram
		--Pula para 59
		--57 => B"000_00111011_0_0100",  -- jmp
		--Testando Exception
		--58 => B"0_11_11111100_1_1111",  -- não existe opcode 1111
		--Carregando r1 com 100 
                --59  => B"000001100100_0011",    -- li a, 100
	        --60  => B"00000000_1_001_0101",  -- mov r1, a
		--Subtrai 40 do valor do acumulador
                --61 => B"00000101000_1_0010",    -- sub 40, a
		--Subtrai r3 do acumulador
                --62 => B"00000000_011_0_0010",    -- sub r3, a
		--Move o valor do r1 para o acumulador
		--63 => B"00000000_0_001_0101",   -- mov a, r1
                --Testando Exception
		--64 => B"0_11_11111100_1_1111",  -- não existe opcode 1111
		--Para provar que não está executando
		--Carregando r1 com 116
                --65  => B"000001110100_0011",    -- li a, 116
                --66  => B"00000000_1_001_0101",  -- mov r1, a
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

