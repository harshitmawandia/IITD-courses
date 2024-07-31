-- Testbench for Program Memory

LIBRARY IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY PM_TB IS 
-- empty
END ENTITY;

ARCHITECTURE BEV OF PM_TB IS

SIGNAL read : STD_LOGIC_VECTOR(5 DOWNTO 0):="000000";
SIGNAL dataOut : STD_LOGIC_VECTOR(31 DOWNTO 0):=X"00000000";

-- DUT component
COMPONENT PROGRAM_MEMORY IS
    PORT(read : in STD_LOGIC_VECTOR(5 downto 0);
        dataOut : out STD_LOGIC_VECTOR(31 downto 0);
         );
END COMPONENT;

BEGIN

  -- Connect DUT
  UUT: PROGRAM_MEMORY PORT MAP(read,dataOut);

  PROCESS
  BEGIN
    -- Read data from Memory
    WAIT FOR 100 ns;
    read <= "000000";
    WAIT FOR 100 ns;
    read <= "000010";
    WAIT FOR 100 ns;
    read <= "000100";
    WAIT FOR 100 ns;
    read <= "001000";
    WAIT FOR 110 ns;
    
    ASSERT FALSE REPORT "Test done. Open EPWave to see signals." SEVERITY NOTE;
    WAIT;
  END PROCESS;

END BEV;
