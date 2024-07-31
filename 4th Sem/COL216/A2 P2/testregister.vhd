-- Testbench for Register

LIBRARY IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY REGISTER_TB IS 
-- empty
END ENTITY;

ARCHITECTURE BEV OF REGISTER_TB IS


-- DUT component
COMPONENT REG IS
    PORT(
    	read1, read2, write : in STD_LOGIC_VECTOR(3 downto 0);
        dataIn	: in STD_LOGIC_VECTOR(31 downto 0);
        writeEnable, clock : in STD_LOGIC;
        dataOut1, dataOut2 : out STD_LOGIC_VECTOR(31 downto 0);
         );
END COMPONENT;


SIGNAL dataIn : STD_LOGIC_VECTOR(31 DOWNTO 0):= X"00000000";
SIGNAL read1 : STD_LOGIC_VECTOR(3 DOWNTO 0):="0000";
SIGNAL read2 : STD_LOGIC_VECTOR(3 DOWNTO 0):="0000";
SIGNAL write : STD_LOGIC_VECTOR(3 DOWNTO 0):="0000";
SIGNAL writeEnable : STD_LOGIC:='0';
SIGNAL clock : STD_LOGIC:='0';
SIGNAL dataOut1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL dataOut2 : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

  -- Connect DUT
  UUT: REG PORT MAP(read1 => read1, 
  					read2 => read2, 
                    write => write, 
                    dataIn => dataIn, 
                    writeEnable => writeEnable, 
                    clock => clock,
                    dataOut1 => dataOut1,
                    dataOut2 => dataOut2
                    );

  stim_proc: PROCESS
  BEGIN
    -- Write data into registers
    write<="1000";
    dataIn<=x"01111111";
    writeEnable<='1';
    clock<='0';
    WAIT FOR 100 ns;
    clock<='1';
    WAIT FOR 100 ns;
    write<="0100";
    dataIn<=x"10111111";
    writeEnable<='1';
    clock<='0';
    WAIT FOR 100 ns;
    clock<='1';
    WAIT FOR 100 ns;
    write<="0010";
    dataIn<=x"11011111";
    writeEnable<='1';
    clock<='0';
    WAIT FOR 100 ns;
    clock<='1';
    WAIT FOR 100 ns;
    writeEnable<='1';
    dataIn<=x"11101111";
    clock<='0';
    write<="0001";
    WAIT FOR 100 ns;
    clock<='1';
    writeEnable<='1';
    WAIT FOR 100 ns;
    

    -- Read data from registers
    writeEnable<='0';
    clock<='0';
    read1<="0000";
    read2<="1000";
    WAIT FOR 100 ns;
    clock<='1';
    read1<="0100";
    read2<="0010";
    WAIT FOR 100 ns;
    clock<='0';
    read1<="0001";
    read2<="1000";
    WAIT FOR 100 ns;
    WAIT FOR 100 ns;
    
    ASSERT FALSE REPORT "Test done. Open EPWave to see signals." SEVERITY NOTE;
    WAIT;
  END PROCESS;

END BEV;
