library IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity REG is 
	port(
    	read1, read2, write : in STD_LOGIC_VECTOR(3 downto 0);
        dataIn	: in STD_LOGIC_VECTOR(31 downto 0);
        writeEnable, clock : in STD_LOGIC;
        dataOut1, dataOut2 : out STD_LOGIC_VECTOR(31 downto 0)
        );
end entity REG;

architecture BEV of REG is

Type Regs is array (15 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
Signal Registers : Regs;
Signal address1, address2, writeAddress: integer range 0 to 15;

begin 
	
--     address1<=
--     address2<=CONV_INTEGER(read2);
--     writeAddress<=CONV_INTEGER(write);
    dataOut1 <= Registers(CONV_INTEGER(read1));
	dataOut2 <= Registers(CONV_INTEGER(read2));

	process (clock, write, writeEnable, dataIn)
	begin
        
    if(rising_edge(clock)) then
        IF(writeEnable='1')THEN
            Registers(CONV_INTEGER(write))<=dataIn;
        END IF;
    end if;
    
	end process;

end BEV;