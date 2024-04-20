library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end;

architecture a_ula_tb of ula_tb is
	component ula
		port(
			entrada1 : in unsigned(15 downto 0); 
			entrada2 : in unsigned(15 downto 0);
			seletor  : in unsigned(1 downto 0);
			saida    : out unsigned(15 downto 0)
		); 
	end component;
	signal entrada1, entrada2, saida: unsigned(15 downto 0);
	signal seletor: unsigned(1 downto 0);
	begin
	       utt: ula port map(
			entrada1 => entrada1,
			entrada2 => entrada2,
			seletor  => seletor,
			saida    => saida
			);
	process
	begin
		--Entradas
		entrada1 <= "0000000000000101";
		entrada2 <= "0000000000000110";
		
		--Soma
		seletor <= "00";
		wait for 50 ns;
		--Subtracao
		seletor <= "01";
                wait for 50 ns;
		--OR
		seletor <= "10";
                wait for 50 ns;
		--AND
		seletor <= "11";
                wait for 50 ns;
		wait;
	end process;	
end architecture;

