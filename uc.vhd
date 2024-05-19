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
		reg_to_ld   : out unsigned(2 downto 0);
		Is_to_ld    : out std_logic
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
	reg_to_ld  <= instruction(5 downto 3) when instruction(2 downto 0) = "011" else
        	      "000";
	Is_to_ld   <= '1' when instruction(2 downto 0) = "011" else
		      '0';
	--Mover PC
	dataO <= address	   when dataFFT='0' else
        	 address+"0000001" when dataFFT='1' else
		"0000000";

end architecture a_uc;
