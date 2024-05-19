library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
	port(
		resetP, clkP       : in std_logic;
		stateP             : out unsigned(1 downto 0);    
		pcP                : out unsigned(6 downto 0);
		instructionP       : out unsigned(15 downto 0);    
		reg1OutP, reg2OutP : out unsigned(15 downto 0);    
		--ARRUMAR ACUMULADOR
		saidaULA           : out unsigned(15 downto 0)
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

	component reg16bits is
		port(
		clk      : in std_logic;
		rst      : in std_logic;
		wr_en    : in std_logic;
		data_in  : in unsigned(15 downto 0);
		data_out : out unsigned(15 downto 0)	    
	);
	end component;

	component sm is
		port(
		clk, rst: in std_logic;
		state: out unsigned(1 downto 0);
		FDE: out unsigned(2 downto 0)
	);
	end component;

   	signal reg_to_entrada1, reg_to_entrada2, romOutS, romOutI: unsigned(15 downto 0);  
	signal uc_to_pc, pc_to_ucROM: unsigned(6 downto 0);
	signal FDEs: unsigned(2 downto 0);
begin
    	U_L_A: ula port map(
        	entrada1 => reg_to_entrada1,
        	entrada2 => reg_to_entrada2,
       		seletor => "01",
       		saida => saidaULA
    	);

   	B_D_R: bdr port map( 
		reg1_data    => reg_to_entrada1,
        	reg2_data    => reg_to_entrada2,
        	regnum1      => "001",
       	 	regnum2      => "010",
        	word         => "0000000000000111",
        	reg_to_write => "001",
        	write_enable => '1',
        	clkBD        => clkP,
        	reset        => resetP
	);

	U_C: uc port map(
		updatePC    => '1',
		instruction => romOutI,
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

	--Intruction register
	I_R: reg16bits port map(
                clk      => clkP,
                rst      => resetP,
                wr_en    => FDEs(2),
                data_in  => romOutS,
                data_out => romOutI
        );
	
	S_M: sm port map(
		clk   => clkP,
                rst   => resetP,
		state => stateP,
		FDE   => FDEs
	);

	pcP           <= pc_to_ucROM;
	instructionP  <= romOutI;
	reg1OutP      <= reg_to_entrada1;
       	reg2OutP      <= reg_to_entrada2;
end architecture a_processor;
