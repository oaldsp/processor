library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pc_tb is
end;

architecture a_pc_tb of pc_tb is
    COMPONENT reg16bits IS
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in std_logic_vector(15 downto 0);
            data_out : out std_logic_vector(15 downto 0)
        );
    end component reg16bits;
    
    COMPONENT rom IS
        port (
            clk     : in std_logic;
            address : in unsigned(6 downto 0);
            data    : out unsigned(15 downto 0)
        );
    end component rom;

-- Clock related
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0' ;
    signal clk : std_logic;

-- Auxiliary Signals
    signal pc_wr : std_logic := '1';
    signal pc_rst : std_logic := '1';
    signal pc_data_wr : std_logic_vector(15 downto 0) := "0000000000000000";
    signal pc_data : std_logic_vector(15 downto 0) := "0000000000000000";
    signal rom_out : unsigned(15 downto 0);

begin
    pc: reg16bits
    port map
    (
        clk => clk,
        rst => pc_rst,
        wr_en => pc_wr,
        data_in => pc_data_wr,
        data_out => pc_data
    );
    
    m_rom: rom
    port map
    (
        clk => clk,
        address => unsigned(pc_data),
        data => rom_out
    );
    
    --Sum +1 address
    pc_data_wr <= std_logic_vector(unsigned(pc_data)+1);
    
    --Total simulation time
    sim_time_proc: process
    begin
        wait for 1.4 us;
        finished <= '1';
        wait;
    end process sim_time_proc;
    
    --Clock generation
    clk_proc: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;
    
    --Signals test
    
    process
    begin
        --Resets pc
        pc_rst <= '1';
        wait for 200 ns;
        pc_rst <= '0';
        wait;
    end process;

end architecture;