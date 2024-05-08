library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
	port(
		regnum1P               : in unsigned(2  downto 0);     --Registrador 1 que sera lido
        	regnum2P               : in unsigned(2  downto 0);     --Registrador 2 que sera lido
        	wordP                  : in unsigned(15 downto 0);     --O que sera escrito
        	reg_to_writeP          : in unsigned(2 downto 0);      --Qual reg eh para escrver
        	write_enableP 	       : in std_logic;             --Habilitar para escrever
        	clkP, resetP, updatePC : in std_logic;
		seletorP      	       : in unsigned(1 downto 0);
		saidaULA, romOut       : out unsigned(15 downto 0)
	);
end;

architecture a_processor of processor is
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
   
	component uc is
        port
        (
		updatePC    : in std_logic;
		instruction : in unsigned(15 downto 0);
            	address     : in unsigned(6 downto 0);
	      	dataO       : out unsigned(6 downto 0)
        );
    	end component;

	component pc is
	port (
        	clk      : in std_logic;
            	rst      : in std_logic;
            	wr_en    : in std_logic;
            	data_in  : in unsigned(6 downto 0);
            	data_out : out unsigned(6 downto 0)
        );
	end component;

	component rom is
		port(
                clk      : in  std_logic;
                address : in  unsigned(6 downto 0);
                data     : out unsigned(15 downto 0)
        );
	end component;

   	signal reg_to_entrada1, reg_to_entrada2, romOutS: unsigned(15 downto 0);  
	signal uc_to_pc, pc_to_ucROM: unsigned(6 downto 0);
begin
    	U_L_A: ula port map(
        	entrada1 => reg_to_entrada1,
        	entrada2 => reg_to_entrada2,
       		seletor => seletorP,
       		saida => saidaULA
    	);

   	B_D_R: bdr port map( 
		reg1_data => reg_to_entrada1,
        	reg2_data => reg_to_entrada2,
        	regnum1   => regnum1P,
       	 	regnum2   => regnum2P,
        	word      => wordP,
        	reg_to_write => reg_to_writeP,
        	write_enable => write_enableP,
        	clkBD        => clkP,
        	reset        => resetP
	);

	U_C: uc port map(
		updatePC    => updatePC,
		instruction => romOutS,
		address     => pc_to_ucROM,
		dataO       => uc_to_pc	
	); 

	P_C: pc port map(
		clk      => clkP,
 		rst      => resetP,
		wr_en    => '1',
		data_in  => uc_to_pc,
		data_out => pc_to_ucROM
	);

	R_O_M: rom port map(
		clk     => clkP,
		address => pc_to_ucRom,
		data	=> romOutS
	);

	romOut<=romOutS;
end architecture a_processor;
