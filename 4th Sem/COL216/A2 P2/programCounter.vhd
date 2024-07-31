library IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is 
    port(
        clock : in std_logic;
        data_in : in STD_LOGIC_VECTOR(31 downto 0);
        P : in std_logic;
        PC_out : out STD_LOGIC_VECTOR(5 downto 0)
    );
end entity ProgramCounter;

architecture BEV of ProgramCounter is 
signal PC_in : STD_LOGIC_VECTOR(5 downto 0) := "000000";
begin 
	PC_out <=PC_in;
	process(clock,P,data_in)
    begin
        if(rising_edge(clock)) then
            if(P = '1' and (data_in(27 downto 26) = "10")) then
                if(data_in(23) = '1') then
                    PC_in <= PC_in + data_in(5 downto 0) + 2;
                else 
                    PC_in <= PC_in - data_in(5 downto 0) + 2;
                end if;
            else
                PC_in <= PC_in + 1;
            end if;
        end if;
    end process;
end BEV;