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
begin 
	process(cond, Z, N, C, V)
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
                P <= not (N=V);
            when "1100" => -- GT
                P <= ((Z='0') and (N=V));
            when "1101" => -- LE
                P <= ((Z='1') or not(N=V));
            when "1110" => -- AL
                P <= true ;
            when others => null ; 
        end case;
        if (P) then PP <= '1'; else PP<='0'; end if;
    end process;
end BEV;