library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port(
        updatePC    : in std_logic;
        instruction : in unsigned(15 downto 0);
        address     : in unsigned(6 downto 0);
        cte         : out unsigned(15 downto 0); 
        isCte        : out std_logic;
        dataO       : out unsigned(6 downto 0);
        regRead        : out unsigned(2 downto 0);
        word_to_ld  : out unsigned(15 downto 0);
        reg_to_w    : out unsigned(2 downto 0);
        Is_to_w     : out std_logic;
        Is_to_ld    : out std_logic;
    	w_acc       : out std_logic;
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
    signal relative_address: unsigned(7 downto 0);
begin
    F_F_T: flipflopT port map(
        clk      => updatePC,
        rst      =>'0',
        data_out => dataFFT
    );

    word_to_ld <= ("0000" & instruction(14 downto 3)) when instruction(2 downto 0) = "011" else
                      "0000000000000000";

    Is_to_ld   <= '1' when instruction(2 downto 0) = "011" else
                      '0';

    --Mover PC
    relative_address <= (('0'&address) + instruction(11 downto 4));
    dataO <= address            when dataFFT='0' else
	     instruction(10 downto 4) when instruction(3 downto 0) = "0100" else
	     relative_address(6 downto 0) when instruction(3 downto 0) = "1100" else
	     address+"0000001";
	
    isCte <= '1' when (instruction(2 downto 0) = "010")and(instruction(3)='1') else
	     '0';

    cte <= ("00000" & instruction(14 downto 4)) when (instruction(2 downto 0) = "010")and(instruction(4)='1') else
	   "0000000000000000";
	
    ula_sel <= "00" when (instruction(2 downto 0) = "101")and(instruction(6) = '1') else
	       "01" when ((instruction(2 downto 0) = "101")or
	       		(instruction(2 downto 0) = "011"))and(instruction(6) = '0') else
		"10" when instruction(2 downto 0) = "001" else
		"11" when (instruction(2 downto 0) = "010")or(instruction(2 downto 0) = "111");

    reg_to_w <= instruction(5 downto 3) when (instruction(2 downto 0) = "011")or
		((instruction(2 downto 0) = "101")and(instruction(6) = '1')) else
		"000";

    Is_to_w <= '1' when (dataFFT='1')and((instruction(2 downto 0) = "011")or
	       ((instruction(2 downto 0) = "101")and(instruction(6) = '1'))) else
	       '0';

    regRead <= instruction(6 downto 4) when (instruction(2 downto 0) = "010")and(instruction(3)='0') else
	       instruction(5 downto 3) when (instruction(2 downto 0) = "001")or
	       				    (instruction(2 downto 0) = "101")or 
				    	    (instruction(2 downto 0) = "111")else
	       "000";
	
    w_acc <= '1' when (dataFFT='1')and((instruction(2 downto 0) = "101")or 
	     				(instruction(2 downto 0) = "001")or
					(instruction(2 downto 0) = "010")or
					(instruction(2 downto 0) = "011"))else
		'0';

end architecture a_uc;
