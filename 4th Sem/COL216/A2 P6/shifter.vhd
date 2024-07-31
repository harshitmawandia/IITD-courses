-- Code your design here
library IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Shifter is
    port(
        input : in std_logic_vector(31 downto 0) := x"00000000";
        shift : in std_logic_vector(1 downto 0);
        amount : in std_logic_vector(4 downto 0);
        carry : out std_logic;
        output : out std_logic_vector(31 downto 0)
    );
end Shifter;

architecture bev of shifter is
    signal temp : std_logic_vector(31 downto 0) := x"00000000";
    signal tempCarry : std_logic := '0';
begin
    output <= temp;
    carry <= tempCarry;
    process(input,shift,amount)
    begin
    	temp <= input;
        tempCarry <= '0';
        if(not(shift="00")) then
            if(amount(0)='1') then
                for i in 0 to 31 loop
                    if(i>=31) then
                        case(shift) is
                            when "01" => 
                                temp(i) <= '0';
                            when "10" =>
                                temp(i) <= input(31);
                            when "11" =>
                                temp(i) <= input(i-31+0);
                            when others => null;
                        end case;
                    else
                        temp(i) <= input(i+1);
                    end if;
                end loop;
                tempCarry <= input(0);
            end if;
            if(amount(1)='1') then
                for i in 0 to 31 loop
                    if(i>=30) then
                        case(shift) is
                            when "01" => 
                                temp(i) <= '0';
                            when "10" =>
                                temp(i) <= input(31);
                            when "11" =>
                                temp(i) <= input(i-31+1);
                            when others => null;
                        end case;
                    else
                        temp(i) <= input(i+2);
                    end if;
                end loop;
                tempCarry <= input(1);
            end if;
            if(amount(2)='1') then
                for i in 0 to 31 loop
                    if(i>=28) then
                        case(shift) is
                            when "01" => 
                                temp(i) <= '0';
                            when "10" =>
                                temp(i) <= input(31);
                            when "11" =>
                                temp(i) <= input(i-31+3);
                            when others => null;
                        end case;
                    else
                        temp(i) <= input(i+4);
                    end if;
                end loop;
                tempCarry <= input(3);
            end if;
            if(amount(3)='1') then
                for i in 0 to 31 loop
                    if(i>=24) then
                        case(shift) is
                            when "01" => 
                                temp(i) <= '0';
                            when "10" =>
                                temp(i) <= input(31);
                            when "11" =>
                                temp(i) <= input(i-31+7);
                            when others => null;
                        end case;
                    else
                        temp(i) <= input(i+8);
                    end if;
                end loop;
                tempCarry <= input(7);
            end if;
            if(amount(4)='1') then
                for i in 0 to 31 loop
                    if(i>=16) then
                        case(shift) is
                            when "01" => 
                                temp(i) <= '0';
                            when "10" =>
                                temp(i) <= input(31);
                            when "11" =>
                                temp(i) <= input(i-31+15);
                            when others => null;
                        end case;
                    else
                        temp(i) <= input(i+16);
                    end if;
                end loop;
                tempCarry <= input(15);
            end if;
        else
            if(amount(0)='1') then
                for i in 0 to 31 loop
                    if(i<=0) then
                        temp(i) <= '0';
                    else
                        temp(i) <= input(i-1);
                    end if;
                end loop;
                tempCarry <= input(31);
            end if;
            if(amount(1)='1') then
                for i in 0 to 31 loop
                    if(i<=1) then
                        temp(i) <= '0';
                    else
                        temp(i) <= input(i-2);
                    end if;
                end loop;
                tempCarry <= input(30);
            end if;
            if(amount(2)='1') then
                for i in 0 to 31 loop
                    if(i<=3) then
                        temp(i) <= '0';
                    else
                        temp(i) <= input(i-4);
                    end if;
                end loop;
                tempCarry <= input(28);
            end if;
            if(amount(3)='1') then
                for i in 0 to 31 loop
                    if(i<=7) then
                        temp(i) <= '0';
                    else
                        temp(i) <= input(i-8);
                    end if;
                end loop;
                tempCarry <= input(24);
            end if;
            if(amount(4)='1') then
                for i in 0 to 31 loop
                    if(i<=15) then
                        temp(i) <= '0';
                    else
                        temp(i) <= input(i-16);
                    end if;
                end loop;
                tempCarry <= input(16);
            end if;
        end if;
    end process;
end bev;