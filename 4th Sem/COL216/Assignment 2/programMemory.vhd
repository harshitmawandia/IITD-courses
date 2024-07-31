library IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PROGRAM_MEMORY is 
	port(
    	read : in STD_LOGIC_VECTOR(5 downto 0);
        dataOut : out STD_LOGIC_VECTOR(31 downto 0)
        );
end entity PROGRAM_MEMORY;

architecture BEV of PROGRAM_MEMORY is

Type MEM is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
Signal Memory : MEM := (0 => X"E3A00000",
1 => X"E3A01000",
2 => X"E0800001",
3 => X"E2811001",
4 => X"E3510005",
5 => X"1AFFFFFB",
others => X"00000000"
						);
Signal address: integer range 0 to 63;

begin process (read)

	BEGIN
    dataOut <= Memory(CONV_INTEGER(read));
    
	end process;

end BEV;