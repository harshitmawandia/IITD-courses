-- Testbench for Processor

LIBRARY IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity TB_Processor is
--Empty
end entity;


ARCHITECTURE BEV OF TB_Processor IS


-- DUT component
COMPONENT Processor IS
    PORT(
        clock : in STD_LOGIC;
         );
END COMPONENT;

Signal clock : std_logic := '0';

begin
	 UUT: Processor PORT MAP( 
                    clock 
                    );
     process begin
     	clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
        clock <= '1';
        WAIT FOR 100 ns;
        clock<='0';
   		WAIT FOR 100 ns;
       Wait;
    end process;
end BEV;
        