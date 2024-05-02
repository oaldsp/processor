library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity teste_tb is
end;

architecture ateste_tb of teste_tb is
    component bdr is
    port(
        regnum1      : in unsigned(2  downto 0);     --Registrador 1 que sera lido
        regnum2      : in unsigned(2  downto 0);     --Registrador 2 que sera lido
        word         : in unsigned(15 downto 0);     --O que sera escrito
        reg_to_write : in unsigned(2 downto 0);      --Qual reg eh para escrver
        write_enable : in std_logic;             --Habilitar para escrever
        clkBD        : in std_logic;
        reset        : in std_logic;
        reg1_data    : out unsigned(15 downto 0);     --Informacao que esta no reg
        reg2_data    : out unsigned(15 downto 0)     --Informacao que esta no reg
    );
    end component;
       
    component ula
    port(
        entrada1 : in unsigned(15 downto 0);
        entrada2 : in unsigned(15 downto 0);
        seletor  : in unsigned(1 downto 0);
        saida    : out unsigned(15 downto 0)
    );
   end component;
   
   signal entrada1, entrada2, word, saida, reg1_data, reg2_data: unsigned(15 downto 0);
   signal seletor: unsigned(1 downto 0);  
   signal regnum1, regnum2, reg_to_write: unsigned(2 downto 0);  
   signal write_enable, clkBD, reset: std_logic;

    -- 100 ns é o período que escolhi para o clock
    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    signal   clk, resetC  : std_logic;
begin
    
    ul: ula port map(
        entrada1 => entrada1,
        entrada2 => entrada2,
        seletor => seletor,
        saida => saida
    );

    br: bdr port map
    (   reg1_data => reg1_data,
        reg2_data => reg2_data,
        regnum1   => regnum1,
        regnum2   => regnum2,
        word      => word,
        reg_to_write => reg_to_write,
        write_enable => write_enable,
        clkBD        => clk,
        reset        => reset
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
      word <= "0000000000000101";
      reg_to_write <= "001";
      write_enable <= '1';
      regnum1 <="001";
      wait for 50 ns;
      write_enable <= '0';
      wait for 50 ns;
      word <= "0000000000000011";
      reg_to_write <= "010";
      write_enable <='1';
      regnum2 <="010";
      wait for 50 ns;
      write_enable <= '0';
      wait for 200 ns;
      entrada1 <= reg1_data;
      entrada2 <= reg2_data;
      seletor <= "10";
      wait for 50 ns;
      word <= saida;
      reg_to_write <= "011";
      write_enable <= '1';
      wait for 200 ns;
      reset <= '1';
      wait;                     -- <== OBRIGATORIO TERMINAR COM WAIT; !!!
   end process;
end architecture ateste_tb;


