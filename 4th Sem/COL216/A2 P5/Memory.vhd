library IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEMORY is 
	port(
    	addr : in STD_LOGIC_VECTOR(5 downto 0);
        dataIn: in STD_LOGIC_VECTOR(31 downto 0);
        dataOut : out STD_LOGIC_VECTOR(31 downto 0);
        MW: in STD_LOGIC_VECTOR(3 downto 0);
        lorD: in std_logic;
        clock : in STD_LOGIC
        );
end entity MEMORY;

architecture BEV of MEMORY is

Type MEM is array (64 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
Signal address: integer range 0 to 63;
Signal DataMemory : MEM := (others => X"00000000");
Signal ProgramMemory : MEM := (0 => x"E3A00004",
1 => x"E3A01004",
2 => x"E0802141",
others => X"00000000");

begin process (addr,address,dataIn,MW,clock,lorD)
	begin

	address<=CONV_INTEGER(addr);
    if (lorD='0') then
        dataOut <= ProgramMemory(address);
    else
        dataOut <= DataMemory(address);
    end if;
    
    if (rising_edge(clock)) then
    
    	IF(MW(0) ='1')THEN
            DataMemory(address)(7 downto 0)<=dataIn(7 downto 0);
        END IF;
        
        IF(MW(1) ='1')THEN
            DataMemory(address)(15 downto 8)<=dataIn(15 downto 08);
        END IF;
        
        IF(MW(2) ='1')THEN
            DataMemory(address)(23 downto 16)<=dataIn(23 downto 16);
        END IF;
        
        IF(MW(3) ='1')THEN
        	DataMemory(address)(31 downto 24)<=dataIn(31 downto 24);
        END IF;
        
    end if;
    
	end process;

end BEV;