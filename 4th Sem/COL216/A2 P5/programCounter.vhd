library IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounterNew is 
    port(
        clock : in std_logic;
        PC_in : in STD_LOGIC_VECTOR(5 downto 0):= "000000";
        -- data_in : in STD_LOGIC_VECTOR(31 downto 0);
        PW : in std_logic;
        PC_out : out STD_LOGIC_VECTOR(5 downto 0):= "000000"
    );
end entity ProgramCounterNew;

architecture BEV of ProgramCounterNew is 
begin 
	process(clock, PW) 
    begin
        if(rising_edge(clock) and PW='1') then
            PC_out <= PC_in;
        end if;
    end process;
end BEV;