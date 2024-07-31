-- Testbench for Register

LIBRARY IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY DM_TB IS 
-- empty
END ENTITY;

ARCHITECTURE BEV OF DM_TB IS


-- DUT component
COMPONENT DATA_MEMORY IS
    PORT(
    	addr : in STD_LOGIC_VECTOR(5 downto 0);
        dataIn	: in STD_LOGIC_VECTOR(31 downto 0);        
        dataOut : out STD_LOGIC_VECTOR(31 downto 0);
        WriteEnable: in STD_LOGIC_VECTOR(3 downto 0);
        clock : in STD_LOGIC;
         );
END COMPONENT;


SIGNAL dataIn : STD_LOGIC_VECTOR(31 DOWNTO 0):= X"00000000";
SIGNAL address : STD_LOGIC_VECTOR(5 DOWNTO 0):="000000";
SIGNAL WriteEnable : STD_LOGIC_VECTOR(3 DOWNTO 0):="0000";
SIGNAL clock : STD_LOGIC:='0';
SIGNAL dataOut : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

  -- Connect DUT
  UUT: DATA_MEMORY PORT MAP(address,
                    dataIn, 
                    dataOut ,
                    WriteEnable , 
                    clock 
                    );

  PROCESS
  BEGIN
    -- Write data into registers
    address<="001000";
    dataIn<=X"01111111";
    WriteEnable<="0001";
    clock<='0';
    WAIT FOR 100 ns;
    clock<='1';
    WAIT FOR 100 ns;
    address<="000100";
    dataIn<=X"10111111";
    WriteEnable<="0011";
    clock<='0';
    WAIT FOR 100 ns;
    clock<='1';
    WAIT FOR 100 ns;
    address<="000010";
    dataIn<=X"11011111";
    WriteEnable<="0111";
    clock<='0';
    WAIT FOR 100 ns;
    clock<='1';
    WAIT FOR 100 ns;
    WriteEnable<="1111";
    dataIn<=X"11101111";
    clock<='0';
    address<="000001";
    WAIT FOR 100 ns;
    clock<='1';
    WriteEnable<="0101";
    WAIT FOR 100 ns;
    

    -- Read data from registers
    WriteEnable<="0000";
    clock<='0';
    address<="000000";
    WAIT FOR 100 ns;
    clock<='1';
    address<="001000";
    WAIT FOR 100 ns;
    clock<='0';
    address<="000100";
    WAIT FOR 100 ns;
    clock<='1';
    address<="000010";
    WAIT FOR 100 ns;
    clock<='0';
    address<="000001";
    WAIT FOR 100 ns;
    clock<='1';
    address<="001000";
    WAIT FOR 100 ns;
    
    WAIT;
  END PROCESS;

END BEV;
