all:
	ghdl -a reg16bits.vhd 
	ghdl -e reg16bits 

	ghdl -a mux32x16.vhd
	ghdl -e mux32x16

	ghdl -a acc.vhd
	ghdl -e acc

	ghdl -a rom.vhd
	ghdl -e rom
	
	ghdl -a  ula.vhd 
	ghdl -e  ula
	
	ghdl -a bdr.vhd 
	ghdl -e bdr	
	
	ghdl -a processor.vhd
	ghdl -e processor

	ghdl -a processor_tb.vhd
	ghdl -e processor_tb
	ghdl -r processor_tb  --wave=processor_tb.ghw

