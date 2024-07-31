library IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PMConnects is
    port(
        Rout,Mout : in std_logic_vector(31 downto 0);
        inst : in std_logic_vector(2 downto 0);
        cs : in std_logic;
        adr : in std_logic_vector(1 downto 0);
        Rin, Min : out std_logic_vector(31 downto 0);
        MW : out std_logic_vector(3 downto 0) := "0000"
    );
end entity PMConnects;

architecture BEV of PMConnects is
    signal temp : std_logic_vector(31 downto 0);
begin
    process(cs,inst,Rout,Mout,adr) 
    begin
        if(cs='1')then
            MW <= "0000";
            case( inst ) is
                when "000" =>
                    Min <= Rout;
                    MW <= "1111";
                when "001" =>
                    Min(15 downto 0) <= Rout(15 downto 0);
                    Min(31 downto 16) <= Rout(15 downto 0);
                    if(adr="00") then
                        MW <= "0011";
                    else
                        MW <= "1100";
                    end if;
                when "010" =>
                    Min(7 downto 0) <= Rout(7 downto 0);
                    Min(15 downto 8) <= Rout(7 downto 0);
                    Min(23 downto 16) <= Rout(7 downto 0);
                    Min(31 downto 24) <= Rout(7 downto 0);
                    case(adr) is
                        when "00" =>
                            MW <= "0001";
                        when "01" =>
                            MW <= "0010";
                        when "10" =>
                            MW <= "0100";
                        when "11" =>
                            MW <= "1000";
                        when others => null;
                    end case;
                when "011" =>
                    Rin <= Mout;
                when "100" =>
                    Rin(31 downto 16) <= x"0000";
                    case(adr) is
                        when "00" =>
                            Rin(15 downto 0) <= Mout(15 downto 0);
                        when "10" =>
                            Rin(15 downto 0) <= Mout(31 downto 16);
                        when others => null;
                    end case;
                when "101" =>
                    case(adr) is
                        when "00" =>
                            for i in 16 to 31 loop
                                Rin(i) <= Mout(15);
                            end loop;
                            Rin(15 downto 0) <= Mout(15 downto 0);
                        when "10" =>
                            for i in 16 to 31 loop
                                Rin(i) <= Mout(31);
                            end loop;
                            Rin(15 downto 0) <= Mout(31 downto 16);
                        when others => null;
                    end case;
                when "110" =>
                    Rin(31 downto 8) <= x"000000";
                    case(adr) is
                        when "00" =>
                            Rin(7 downto 0) <= Mout(7 downto 0);
                        when "01" =>
                            Rin(7 downto 0) <= Mout(15 downto 8);
                        when "10" =>
                            Rin(7 downto 0) <= Mout(23 downto 16);
                        when "11" =>
                            Rin(7 downto 0) <= Mout(31 downto 24);
                        when others => null;
                    end case;
                when "111" =>
                    case(adr) is
                        when "00" =>
                            for i in 8 to 31 loop
                                Rin(i) <= Mout(7);
                            end loop;
                            Rin(7 downto 0) <= Mout(7 downto 0);
                        when "01" =>
                            for i in 8 to 31 loop
                                Rin(i) <= Mout(15);
                            end loop;
                            Rin(7 downto 0) <= Mout(15 downto 8);
                        when "10" =>
                            for i in 8 to 31 loop
                                Rin(i) <= Mout(23);
                            end loop;
                            Rin(7 downto 0) <= Mout(23 downto 16);
                        when "11" =>
                            for i in 8 to 31 loop
                                Rin(i) <= Mout(31);
                            end loop;
                            Rin(7 downto 0) <= Mout(31 downto 24);
                        when others => null;
                    end case;
                when others => null;
            end case ;
        else
            Rin <= Mout;
            Min <= Rout;
        end if;
    end process;
end BEV;


