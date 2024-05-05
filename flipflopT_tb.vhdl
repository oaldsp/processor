library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity flipflopT_tb is
end entity flipflopT_tb;

architecture a_flipflopT_tb of flipflopT_tb is
    
    component flipflopT is
        port
        (
            clk : in std_logic;
            rst : in std_logic;
            data_out : out unsigned(0 downto 0)
        );
    end component;
    
    -- Clock Period
    
    constant clk_period: time := 100 ns;
    signal finished : std_logic := '0';
    signal clk : std_logic;
    signal ff_rst : std_logic := '0';
    signal ff_out: unsigned(0 downto 0);
    
begin
    fft: flipflopT
    port map
    (
        clk => clk,
        rst => ff_rst,
        data_out => ff_out
    );
    

    --Total simulation time
    sim_time_process: process
    begin  
        wait for 1.4 us;
        finished <= '1';
        wait;
    end process;
    
    -- Clock generation
    clk_process: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for clk_period/2;
            clk <='1';
            wait for clk_period/2;
        end loop;
        wait;
    end process;
    
    --Testing signals
    process
    begin
        --Leitura sequencial da ROM
        ff_rst <= '1';
        wait for 200 ns;
        ff_rst <= '0';
        wait for 1000 ns;
        wait;
    end process;
    

end architecture a_flipflopT_tb;