library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port(
        updatePC    : in std_logic;
    	regInfo     : in unsigned(15 downto 0);
        instruction : in unsigned(15 downto 0);
        address     : in unsigned(6 downto 0);
        C: in std_logic; --Carry
        N: in std_logic; --Negative
        O: in std_logic; --Overflow
        Z: in std_logic; --Zero
        cte         : out unsigned(15 downto 0); 
        isCte       : out std_logic;
        dataO       : out unsigned(6 downto 0);
        regRead     : out unsigned(2 downto 0);
        word_to_ld  : out unsigned(15 downto 0);
        reg_to_w    : out unsigned(2 downto 0);
        Is_to_w     : out std_logic;
        Is_to_ld    : out std_logic;
    	w_acc       : out std_logic;
    	ram_or_ula  : out std_logic;
        excep  	    : out std_logic;
	addressRam  : out unsigned(6 downto 0);
	ram_w 	    : out std_logic;
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

    signal dataFFT, cmp_flag, excepS: std_logic;
    signal relative_address: unsigned(7 downto 0);
begin
    F_F_T: flipflopT port map(
        clk      => updatePC,
        rst      =>'0',
        data_out => dataFFT
    );

    word_to_ld <= ("00000" & instruction(14 downto 4)) when instruction(3 downto 0) = "0011" else
                      "0000000000000000";

    Is_to_ld   <= '1' when instruction(3 downto 0) = "0011" else
                      '0';

    --Mover PC----
    relative_address <= (('0'&address) + instruction(12 downto 5));
    
    cmp_flag <= C when (instruction(14 downto 13) = "00")and(instruction(4 downto 0) = "10100") else 
		N when (instruction(14 downto 13) = "01")and(instruction(4 downto 0) = "10100") else
		O when (instruction(14 downto 13) = "10")and(instruction(4 downto 0) = "10100") else
		Z when (instruction(14 downto 13) = "11")and(instruction(4 downto 0) = "10100") else
		'1';

    dataO <= address when dataFFT='0' else
	     instruction(11 downto 5) when instruction(4 downto 0) = "00100" else 
	     relative_address(6 downto 0) when (instruction(4 downto 0) = "10100")and(cmp_flag='0')else
	     address+"0000001" when excepS = '0' else
	     address;
    --------------	
    
    isCte <= '1' when (instruction(3 downto 0) = "0010")and(instruction(4)='1') else
	     '0';

    cte <= ("000000" & instruction(14 downto 5)) when (instruction(3 downto 0) = "0010")and(instruction(4)='1') else
	   "0000000000000000";
	
    ula_sel <= "00" when (((instruction(3 downto 0) = "0101")and(instruction(7) = '1'))or
	       		(instruction(3 downto 0) = "1000")or(instruction(3 downto 0) = "1001"))else
	       "01" when (instruction(3 downto 0) = "0011")or
			(instruction(3 downto 0) = "1000")or
			(instruction(3 downto 0) = "1001")or
	       		((instruction(3 downto 0) = "0101")and(instruction(7) = '0')) else
		"10" when instruction(3 downto 0) = "0001" else
		"11" when (instruction(3 downto 0) = "0010")or(instruction(3 downto 0) = "0111")else
		"00";

    reg_to_w <= instruction(6 downto 4) when (instruction(3 downto 0) = "1000")or --(instruction(3 downto 0) = "0011")or--LINHA NAO FAZ SENTIDO
		((instruction(3 downto 0) = "0101")and(instruction(7) = '1')) else
		"000";

    Is_to_w <= '1' when (dataFFT='1')and((instruction(3 downto 0) = "0011")or((instruction(3 downto 0) = "1000"))or
	       ((instruction(3 downto 0) = "0101")and(instruction(7) = '1'))) else
	       '0';

    regRead <= instruction(9 downto 7) when (instruction(3 downto 0) = "1000")else
 	       instruction(7 downto 5) when (instruction(3 downto 0) = "0010")and(instruction(4)='0') else
	       instruction(6 downto 4) when (instruction(3 downto 0) = "0001")or
	       				    (instruction(3 downto 0) = "0101")or
					    (instruction(3 downto 0) = "1001")or 
                                            (instruction(3 downto 0) = "0100")or
				    	    (instruction(3 downto 0) = "0111")else
	       "000";
	
    w_acc <= '1' when (dataFFT='1')and((instruction(3 downto 0) = "0101")or 
	     				(instruction(3 downto 0) = "0001")or
					(instruction(3 downto 0) = "0010")or
					(instruction(3 downto 0) = "0011"))else
		'0';

    ram_or_ula <= '0' when instruction(3 downto 0) = "1000" else
		   '1';
    
    addressRam <= regInfo(6 downto 0);

    ram_w <= '1' when instruction(3 downto 0) = "1001" else
             '0';

    excepS <= '1' when instruction(3 downto 0) = "1111"or
	      		instruction(3 downto 0) = "1110"or
	      		instruction(3 downto 0) = "1101"or
	      		instruction(3 downto 0) = "1100"or
	      		instruction(3 downto 0) = "1011"or
			instruction(3 downto 0) = "1010"else
		'0';

    excep <= excepS;  

end architecture a_uc;
