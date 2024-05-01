library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bdr is
	port(
		regnum1      : in unsigned(2  downto 0); 	--Registrador 1 que sera lido
		regnum2      : in unsigned(2  downto 0); 	--Registrador 2 que sera lido
		word         : in unsigned(15 downto 0); 	--O que sera escrito
		reg_to_write : in unsigned(2 downto 0);  	--Qual reg eh para escrver
		write_enable : in std_logic; 			--Habilitar para escrever
		clkBD        : in std_logic;		
		reset        : in std_logic;
		reg1_data    : out unsigned(15 downto 0);	 --Informacao que esta no reg 
		reg2_data    : out unsigned(15 downto 0)	 --Informacao que esta no reg
	);
end entity;

architecture a_bdr of bdr is
	component reg16bits is
      		port( 	clk      : in std_logic;
                	rst      : in std_logic;
                	wr_en    : in std_logic;
                	data_in  : in unsigned(15 downto 0);
                	data_out : out unsigned(15 downto 0)
	 	 );	
	end component;	
	--Declarando sinais
	signal wr_en_sig: unsigned(7 downto 1);
	signal out_sig0, out_sig1, out_sig2, out_sig3, out_sig4, out_sig5, out_sig6, out_sig7: unsigned(15 downto 0);
begin
	--Declarando registradores
	reg7: reg16bits port map(clk=>clkBD,rst=>reset,wr_en=>wr_en_sig(7),data_in=>word,data_out=>out_sig7);
	reg6: reg16bits port map(clk=>clkBD,rst=>reset,wr_en=>wr_en_sig(6),data_in=>word,data_out=>out_sig6);
	reg5: reg16bits port map(clk=>clkBD,rst=>reset,wr_en=>wr_en_sig(5),data_in=>word,data_out=>out_sig5);
	reg4: reg16bits port map(clk=>clkBD,rst=>reset,wr_en=>wr_en_sig(4),data_in=>word,data_out=>out_sig4);
	reg3: reg16bits port map(clk=>clkBD,rst=>reset,wr_en=>wr_en_sig(3),data_in=>word,data_out=>out_sig3);
	reg2: reg16bits port map(clk=>clkBD,rst=>reset,wr_en=>wr_en_sig(2),data_in=>word,data_out=>out_sig2);
        reg1: reg16bits port map(clk=>clkBD,rst=>reset,wr_en=>wr_en_sig(1),data_in=>word,data_out=>out_sig1);
        --Pelas especificacoes no pdf esse cara deve ser sempre 0
	reg0: reg16bits port map(clk=>clkBD,rst=>reset,wr_en=>'0',data_in=>"0000000000000000",data_out=>out_sig0);

	process(clkBD,write_enable,regnum1,regnum2)
	begin	
		--LOGICA  PARA ESCRITA
		if write_enable='1' then 
			--Logica burra porque não sei a sintaxe em vhdl(ESSA PARTE DO COGIDO EH UM CRIME)
			--PRECISARIA FAZER ALGO ASSIM(MAS NAO CONSEGUI FAZER EM VHDL)
			-- 	wr_en_sig(reg_to_write) <= "1";
			if reg_to_write = "001" then
				wr_en_sig(1) <= '1';
			elsif reg_to_write = "010" then
                                wr_en_sig(2) <= '1';
			elsif reg_to_write = "011" then
                                wr_en_sig(3) <= '1';
			elsif reg_to_write = "100" then
                                wr_en_sig(4) <= '1';
			elsif reg_to_write = "101" then
                                wr_en_sig(5) <= '1';
			elsif reg_to_write = "110" then
                                wr_en_sig(6) <= '1';
			elsif reg_to_write = "111" then
                                wr_en_sig(7) <= '1';
			end if;
		else 
			 wr_en_sig <= "0000000";
		end if;

		--LOGICA PARA SAIDA 1
		--Logica burra porque não sei a sintaxe em vhdl(ESSA PARTE DO COGIDO EH UM CRIME)
                if regnum1 = "000" then
                	reg1_data <= out_sig0;
                elsif regnum1 = "001" then
                	reg1_data <= out_sig1;
                elsif regnum1 = "010" then
                        reg1_data <= out_sig2;
                elsif regnum1 = "011" then
                        reg1_data <= out_sig3;
                elsif regnum1 = "100" then
                        reg1_data <= out_sig4;
                elsif regnum1 = "101" then
                        reg1_data <= out_sig5;
                elsif regnum1 = "110" then
                        reg1_data <= out_sig6;
                elsif regnum1 = "111" then
                        reg1_data <= out_sig7;
  		end if;

		--LOGICA PARA SAIDA 2
                --Logica burra porque não sei a sintaxe em vhdl(ESSA PARTE DO COGIDO EH UM CRIME)
                if    regnum2 = "000" then
                        reg2_data <= out_sig0;
                elsif regnum2 = "001" then
                        reg2_data <= out_sig1;
                elsif regnum2 = "010" then
                        reg2_data <= out_sig2;
                elsif regnum2 = "011" then
                        reg2_data <= out_sig3;
                elsif regnum2 = "100" then
                        reg2_data <= out_sig4;
                elsif regnum2 = "101" then
                        reg2_data <= out_sig5;
                elsif regnum2 = "110" then
                        reg2_data <= out_sig6;
                elsif regnum2 = "111" then
                        reg2_data <= out_sig7;
                end if;

	end process;

end architecture;
