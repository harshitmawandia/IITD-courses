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
Signal Memory : MEM := (0 => X"E3A0000A",
						1 => X"E3A01005",
						2 => X"E5801000",
						3 => X"E2811002",
						4 => X"E5801004",
						5 => X"E5902000",
						6 => X"E5903004",
						7 => X"E0434002",
						others => X"00000000"
						);
Signal address: integer range 0 to 63;

begin process (read)

	BEGIN

	address<=CONV_INTEGER(read);
    dataOut <= Memory(address);
    
	end process;

end BEV;