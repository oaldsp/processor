all:
	ghdl -a reg16bits.vhd 
	ghdl -e reg16bits 
	
	ghdl -a rom.vhd
	ghdl -e rom
	
	ghdl -a  ula.vhd 
	ghdl -e  ula
	
	ghdl -a bdr.vhd 
	ghdl -e bdr	
	
	ghdl -a teste_tb.vhd
	ghdl -e teste_tb
	ghdl -r teste_tb --wave=teste_tb.ghw
