library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor_tb is
end;

architecture a_processor_tb of processor_tb is
	component processor is
	port(
        	regnum1P               : in unsigned(2  downto 0);     --Registrador 1 que sera lido
                regnum2P               : in unsigned(2  downto 0);     --Registrador 2 que sera lido
                wordP                  : in unsigned(15 downto 0);     --O que sera escrito
                reg_to_writeP          : in unsigned(2 downto 0);      --Qual reg eh para escrver
                write_enableP          : in std_logic;                 --Habilitar para escrever
                clkP, resetP, updatePC : in std_logic;                 --updatePC faz leitura em O e atualiza pc em 1
                seletorP               : in unsigned(1 downto 0);
                saidaULA, romOut       : out unsigned(15 downto 0)
        );
	end component; 
   
   	signal wordS, saidaS: unsigned(15 downto 0);
   	signal seletorS: unsigned(1 downto 0);  
   	signal regnum1S, regnum2S, reg_to_writeS: unsigned(2 downto 0);  
   	signal write_enableS, resetS, updatePCS: std_logic;

    	-- 100 ns é o período que escolhi para o clock
    	constant period_time : time      := 100 ns;
    	signal   finished    : std_logic := '0';
    	signal   clk, resetC  : std_logic;
begin
	pro: processor port map(
        	regnum1P       => regnum1S,
        	regnum2P       => regnum2S,
        	wordP          => wordS,
		reg_to_writeP  => reg_to_writeS,
		write_enableP  => write_enableS,
		clkP           => clk,
		resetP         => resetS,
		seletorP       => seletorS,
        	saidaULA       => saidaS,
		updatePC       => updatePCS
    	);
 
	reset_global: process
	begin
        	resetC <= '1';
        	wait for period_time*2; -- espera 2 clocks, pra garantir
        	resetC <= '0';
       		wait;
    	end process;

    	sim_time_proc: process
   	begin
        	wait for 10 us;         -- <== TEMPO TOTAL DA SIMULACAO!!!
       		finished <= '1';
        	wait;
    	end process sim_time_proc;
    	clk_proc: process
    	begin                       -- gera clock até que sim_time_proc termine
       		while finished /= '1' loop
            	clk <= '0';
            	wait for period_time/2;
            	clk <= '1';
            	wait for period_time/2;
        	end loop;
        	wait;
    	end process clk_proc;
   	process                      -- sinais dos casos de teste (p.ex.)
   	begin
      		wordS <= "0000000000000111";
      		reg_to_writeS <= "001";
      		write_enableS <= '1';
     		regnum1S <="001";
      		wait for 50 ns;
      		write_enableS <= '0';
      		wait for 50 ns;
      		wordS <= "0000000000001101";
      		reg_to_writeS <= "010";
      		write_enableS <='1';
      		regnum2S <="010";
      		wait for 50 ns;
      		write_enableS <= '0';
      		wait for 200 ns;
      		seletorS <= "01";
		updatePCS <= '0';
      		wait for 50 ns;
		updatePCS <= '1';
      		wordS <= saidaS;
      		reg_to_writeS <= "011";
      		write_enableS <= '1';
		wait for 1500 ns;
		updatePCS <= '0';
                wait for 50 ns;
                updatePCS <= '1';
      		wait for 800 ns;
      		resetS <= '1';
      		wait;                     -- <== OBRIGATORIO TERMINAR COM WAIT; !!!
  	end process;
end architecture a_processor_tb;

