library IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Flags is  
    Port (
   	    S : in std_logic;
        OPCode  : in STD_LOGIC_VECTOR(3 downto 0);
        ALU_Out, A, B   : in  STD_LOGIC_VECTOR(31 downto 0);
        C_in    : in std_logic ;
        C,Z,N,V : out std_logic := '0'
    );
end entity Flags; 

architecture Behavioral of Flags is
    begin
        process(S, OPCode, ALU_Out, C_in, A, B)
        begin
            if(S='1') then
                case(OPCode) is
                    -- when "0000" => -- And
                    
                    -- when "0001" => -- EOR
                    
                    -- when "0010" => -- Sub
                    
                    -- when "0011" => -- RSB
                    
                    -- when "0100" => -- Add
                    
                    -- when "0101" => -- ADC
                    
                    -- when "0110" => -- SBC
                    
                    -- when "0111" => -- RSC
                    
                    -- when "1000" => -- TST
                    
                    -- when "1001" => -- TEQ
                    
                    when "1010" => -- CMP 
                    if (ALU_Out = x"00000000") then Z <= '1'; else Z<='0'; end if;
                    if (C_in = '1') then C <= '1'; else C<='0'; end if;
                    if (ALU_Out(31) = '1') then N <= '1'; else N<='0'; end if;
                    if ((A(31)=B(31)) and not(A(31) = ALU_Out(31)))then V <= '1'; else V<='0'; end if;
                    -- when "1011" => -- CMN
                    
                    -- when "1100" => -- ORR
                    
                    -- when "1101" => -- MOV
                    
                    -- when "1110" => -- BIC
                    
                    -- when "1111" => -- MVN   
                    
                    when others => null ; 
                    
                end case;
            end if;
        end process;
    end Behavioral;
