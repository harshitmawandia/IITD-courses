library IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CondChecker is
    port(
        Z,N,C,V : in std_logic;
        cond : in STD_LOGIC_VECTOR(3 downto 0);
        PP : out std_logic
    );
end entity CondChecker;

architecture BEV of CondChecker is
    signal P : boolean;
begin process(Z,N,C,V, cond)
    begin
        case(cond) is
            when "0000" => -- EQ
                P <= (Z='1');
            when "0001" => -- NE
                P <= (Z='0');
            when "0010" => -- HS
                P <= (C='1');
            when "0011" => -- LO
                P <= (C='0');
            when "0100" => -- MI
                P <= (N='1');
            when "0101" => -- PL
                P <= (N='0');           
            when "0110" => -- VS
                P <= (V='1');
            when "0111" => -- VC
                P <= (V='0');
            when "1000" => -- HI
                P <= ((C='1') and (Z='0'));
            when "1001" => -- LS
                P <= ((C='0') or (Z='1'));
            when "1010" => -- GE
                P <= (N=V);
            when "1011" => -- LT
                P <= (N!=V);
            when "1100" => -- GT
                P <= ((Z='0') and (N=V));
            when "1101" => -- LE
                P <= ((Z='1') or (N!=V));
            when "1110" => -- AL
                P <= 1 ;
            when others => null ; 
        end case;
        PP <= '1' when (P) else '0';
    end process;
end BEV;