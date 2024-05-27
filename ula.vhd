library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    port(
        entrada1  : in unsigned(15 downto 0);
        entrada2  : in unsigned(15 downto 0);
        seletor   : in unsigned(1 downto 0);
        saida     : out unsigned(15 downto 0);
        C: out std_logic; --Carry
        N: out std_logic;--Negative
        O: out std_logic --Overflow
    );
end entity;

architecture a_ula of ula is
begin
    saida <= (entrada1 + entrada2)   when seletor="00" else --ADD
    (entrada1 - entrada2)   when seletor="01" else --SUB
         "00000000000000000";
    --CARRY FLAG
    C <= '1' when (entrada1(15) AND saida(15)) OR (entrada1(15) AND NOT saida(15)) OR (entrada2(15) AND NOT saida(15)) else '0';
    --NEGATIVE FLAG
    N <= '1' when entrada2 <= entrada1 else '0';
    --OVERFLOW FLAG
    O <= '1' when (entrada1(15) AND entrada2(15)) else '0';
end architecture;

