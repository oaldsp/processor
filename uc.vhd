library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
	port(
		updatePC    : in std_logic;
		instruction : in unsigned(15 downto 0);
		address     : in unsigned(6 downto 0);
		cte         : out unsigned(15 downto 0); 
		isCte	    : out std_logic;
	      	dataO       : out unsigned(6 downto 0);
		regRead	    : out unsigned(2 downto 0);
		regB        : out unsigned(2 downto 0);
		word_to_ld  : out unsigned(15 downto 0);
		reg_to_w    : out unsigned(2 downto 0);
		Is_to_w     : out std_logic;
		Is_to_ld    : out std_logic;
		ula_sel     : out unsigned(1 downto 0)
	);
end entity;

architecture a_uc of uc is
	component flipflopT is
	port(
            clk      : in  std_logic;
            rst      : in  std_logic;
            data_out : out std_logic
        );
	end component;

	signal dataFFT: std_logic;
begin
	F_F_T: flipflopT port map(
		clk      => updatePC,
		rst      =>'0',
		data_out => dataFFT
	);
	
	--LD
	word_to_ld <= ("000000" & instruction(15 downto 6)) when instruction(2 downto 0) = "011" else
		      "0000000000000000";

	Is_to_ld   <= '1' when instruction(2 downto 0) = "011" else  
		      '0';

	--Mover PC
	dataO <= address	   when dataFFT='0' else
        	 address+"0000001" when dataFFT='1' else
		"0000000";

	--ADD
	regRead <= instruction(5 downto 3) when instruction(2 downto 0) = "001" else
		   "000";
       	
	regB    <= instruction(8 downto 6) when instruction(2 downto 0) = "001" else
                   "000";

	--SUB
	isCte <= '1' when (instruction(2 downto 0) = "010")and(instruction(6) = '1') else
       		 '0';

	--Misturando operacoes
	ula_sel <= "00" when instruction(2 downto 0) = "001" else
		   "01";

	reg_to_w <= instruction(5 downto 3) when instruction(2 downto 0) = "011" else
		    instruction(11 downto 9) when instruction(2 downto 0) = "001" else
                    "000";

	Is_to_w   <= '1' when (instruction(2 downto 0) = "011")or(instruction(2 downto 0) = "001") else
                      '0';

end architecture a_uc;
