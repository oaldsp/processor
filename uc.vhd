library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
	port(
		updatePC    : in std_logic;
		instruction : in unsigned (15 downto 0);
		address     : in unsigned(6 downto 0);
	      	dataO       : out unsigned(6 downto 0)
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
	

	dataO<= instruction(7 downto  1)  when instruction(0)='1' else
	       	address		          when dataFFT='0'        else
       		address+"0000001"         when dataFFT='1'        else
		"0000000";

end architecture a_uc;
