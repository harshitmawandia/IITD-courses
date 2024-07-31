library IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FSM is
    port(
        clock : in std_logic;
        inst : in std_logic_vector(31 downto 0);
        P : in std_logic;
        PW, lorD, Rsrc, M2R, RW, Asrc1, Fset, IW, DW, AW, BW, ReW : out std_logic;
        Asrc2 : out std_logic_vector(1 downto 0);
        op, mW : out std_logic_vector(3 downto 0);
        State_out : out integer
    );
end entity FSM;

architecture BEV of FSM is
    signal State_in : integer := 0;
begin 
    State_out <= State_in;
    process(clock)
    begin
    if(rising_edge(clock)) then
    PW <= '0';
    MW <= "0000";
    M2R <= '0';
    RW <= '0';
    IW <= '0';
    DW <= '0';
    AW <= '0';
    BW <= '0';
    ReW <= '0';
    Fset <= '0';
            case(State_in) is
                when 0 =>
                    lorD <= '0';
                    PW <= '1';
                    IW <= '1';
                    Asrc1 <= '0';
                    Asrc2 <= "01";
                    op <= "0100";
                    State_in <= 1;
                when 1 =>
                    Rsrc <= '0';
                    AW <= '1';
                    BW <= '1';
                    case(inst(27 downto 26)) is
                    	when "00" => 
                        State_in <= 2;
                        when "01" => 
                        State_in <= 3;
                        when "10" => 
                        State_in <= 4;
                        when "11" => 
                        null;
                        when others => null;
                    end case;
                    
                when 2 => 
                    Asrc1 <= '1';
                    if(inst(25)='0') then
                        Asrc2 <= "00";
                    else
                        Asrc2 <= "10";
                    end if;
                    Fset <= inst(20); -- to check
                    ReW <= '1';
                    State_in <= 5;
                    op <= inst(24 downto 21);
                when 5 =>
                	if(not((op="1000") or (op="1001") or (op="1010") or (op="1011"))) then
                    	RW <= '1';
                    end if;
                    M2R <= '0';
                    State_in <= 0;
                when 3 =>
                    ReW <= '1';
                    BW <= '1';
                    Rsrc <= '1';
                    Asrc1 <= '1';
                    Asrc2 <= "10";

                    if(inst(23)='1') then -- up-1 down-0
                        op <= "0100";
                    else
                        op <= "0010";
                    end if;

                    if(inst(20)='0') then -- str =0; ldr = 1;
                        State_in <= 6;
                    else
                        State_in <= 7;
                    end if;
                when 6 =>
                    MW <= "1111";
                    lorD <= '1';
                    State_in <= 0;
                when 7 =>
                    DW <= '1';
                    lorD <= '1';
                    State_in <= 8;
                when 8 =>
                    RW <= '1';
                    M2R <= '1';
                    State_in <= 0;
                when 4 =>
                    Asrc1 <= '0';
                    if(P='1') then
                    	Asrc2 <= "11";
                        op <= "0101";
                    	PW <= '1';
                    end if;                  	
                    State_in <= 0;
                when others => null;
            end case;
        end if;
    end process;
end BEV;