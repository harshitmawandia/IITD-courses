library IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DATA_MEMORY is 
	port(
    	addr : in STD_LOGIC_VECTOR(5 downto 0);
        dataIn: in STD_LOGIC_VECTOR(31 downto 0);
        dataOut : out STD_LOGIC_VECTOR(31 downto 0);
        WriteEnable: in STD_LOGIC_VECTOR(3 downto 0);
        clock : in STD_LOGIC
        );
end entity DATA_MEMORY;

architecture BEV of DATA_MEMORY is

Type MEM is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
Signal address: integer range 0 to 63;
Signal Memory : MEM := (others => X"00000000");

begin process (address,dataIn,WriteEnable,clock)
	begin

	address<=CONV_INTEGER(addr);
    dataOut <= Memory(address);
    
    if (rising_edge(clock)) then
    
    	IF(WriteEnable(0) ='1')THEN
            Memory(address)(7 downto 0)<=dataIn(7 downto 0);
        END IF;
        
        IF(WriteEnable(1) ='1')THEN
            Memory(address)(15 downto 8)<=dataIn(15 downto 08);
        END IF;
        
        IF(WriteEnable(2) ='1')THEN
            Memory(address)(23 downto 16)<=dataIn(23 downto 16);
        END IF;
        
        IF(WriteEnable(3) ='1')THEN
            Memory(address)(31 downto 24)<=dataIn(31 downto 24);
        END IF;
        
    end if;
    
	end process;

end BEV;