library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity processador_tb is
end entity processador_tb;

architecture a_processador_tb of processador_tb is
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
    --Declarando sinais
    signal wr_en_sig: unsigned(7 downto 1);
    signal out_sig: unsigned(127 downto 0);
    
    signal reg1_data    : unsigned(15 downto 0);
    signal reg2_data    : unsigned(15 downto 0);
    signal regnum1      : unsigned(2  downto 0);
    signal regnum2      :  unsigned(2  downto 0);
    signal word         :  unsigned(15 downto 0);
    signal reg_to_write :  unsigned(2 downto 0);
    signal write_enable :  std_logic;
    signal clkBD        :  std_logic;
    signal reset        :  std_logic;


    component ula
    port(
        entrada1 : in unsigned(15 downto 0);
        entrada2 : in unsigned(15 downto 0);
        seletor  : in unsigned(1 downto 0);
        saida    : out unsigned(15 downto 0)
    );
end component;
signal entrada1, entrada2: unsigned(15 downto 0);
signal saida: unsigned(15 downto 0);
signal seletor: unsigned(1 downto 0);

begin
    utt: ula port map(
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
        clkBD        => clkBD,
        reset        => reset
    );
    
    process
    begin
        
        word <= "000000000101";
        reg_to_write <= "001";
        write_enable <= '1';
        
        write_enable <= '0';
        word <= "000000000011";
        reg_to_write <= "010";
        write_enable <='1';
        
        entrada1 <= reg1_data;
        entrada2 <= reg2_data;
        
        word <= saida;
        
        reg_to_write <= "011";
        write_enable <= '1';
        
        
        
        
        
    end process;
    
    
    

end architecture;