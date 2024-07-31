library IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FSM is
    port(
        clock : in std_logic;
        inst : in std_logic_vector(31 downto 0);
        P : in std_logic;
        PW, M2R, RW, Asrc1, Fset, IW, DW, AW, BW, ReW, Ssrc1, XW, DDW, BorR, cs_PMconnects : out std_logic;
        Asrc2, Rsrc, Ssrc2, Stype, lorD : out std_logic_vector(1 downto 0);
        op : out std_logic_vector(3 downto 0);
        inst_PMconnects : out std_logic_vector(2 downto 0);
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
    M2R <= '0';
    RW <= '0';
    IW <= '0';
    DW <= '0';
    AW <= '0';
    BW <= '0';
    ReW <= '0';
    XW <= '0';
    DDW <= '0';
    Fset <= '0';
    cs_PMconnects <= '0';
            case(State_in) is
                when 0 =>
                    lorD <= "00";
                    PW <= '1';
                    IW <= '1';
                    Asrc1 <= '0';
                    Asrc2 <= "01";
                    op <= "0100";
                    State_in <= 1;
                when 1 =>
                    Rsrc <= "00";
                    AW <= '1';
                    BW <= '1';
                    BorR <= '0';
                    case(inst(27 downto 26)) is
                    	when "00" =>
                        if(inst(25)='0') then
                            if(inst(4)='1' and inst(7)='1') then
                                if(inst(22)='0') then
                                    State_in <= 13;
                                else
                                    State_in <= 3;
                                end if;
                            else 
                              if (inst(4)='0') then
                                  State_in <= 2;
                              else
                                  State_in <= 10;
                              end if;
                            end if;
                        else
                            state_in <= 12;
                        end if;
                        when "01" => 
                        if (inst(25)='0') then
                            State_in <= 3; --no shift
                        else
                            State_in <= 13; --with shift
                        end if;
                        when "10" => 
                        State_in <= 4;
                        when "11" => 
                        null;
                        when others => null;
                    end case;

                when 2 =>
                    Ssrc1 <= '1';
                    Ssrc2 <= "10";
                    DDW <= '1';
                    Stype <= inst(6 downto 5);
                    State_in <= 5;
                
                when 10 =>
                    Rsrc <= "10";
                    XW <= '1';
                    BorR <= '1';
                    State_in <= 11;
                
                when 11 =>
                    Ssrc1 <= '1';
                    Ssrc2 <= "00";
                    DDW <= '1';
                    Stype <= inst(6 downto 5);
                    State_in <= 5;
                
                when 12 =>
                    Ssrc1 <= '0';
                    Ssrc2 <= "01";
                    DDW <= '1';
                    Stype <= "11";
                    State_in <= 5;
                    
                when 5 => 
                    Asrc1 <= '1';
                    Asrc2 <= "00";
                    Fset <= inst(20); -- to check
                    ReW <= '1';
                    State_in <= 9;
                    op <= inst(24 downto 21);

                when 9 =>
                	if(not((op="1000") or (op="1001") or (op="1010") or (op="1011"))) then
                    	RW <= '1';
                    end if;
                    M2R <= '0';
                    State_in <= 0;

                when 13 =>
                    Ssrc1 <= '1';
                    Ssrc2 <= "10";
                    DDW <= '1';
                    Stype <= inst(6 downto 5);
                    State_in <= 14;
                
                when 14 =>
                    ReW <= '1';
                    BW <= '1';
                    Rsrc <= "01";
                    Asrc1 <= '1';
                    Asrc2 <= "00";

                    if(inst(23)='1') then -- up-1 down-0
                        op <= "0100";
                    else
                        op <= "0010";
                    end if;

                    if(inst(20)='0') then -- str =0; ldr = 1;
                        State_in <= 6;
                        if (inst(27 downto 26)="01") then
                            inst_PMconnects <= "000";
                        else 
                        	if(inst(6 downto 5) = "01") then
                            	inst_PMconnects <= "001";
                            end if;
                        end if;
                    else
                        State_in <= 7;
                        if (inst(27 downto 26)="01") then
                            inst_PMconnects <= "011";
                        else 
                          if(inst(6 downto 5) = "01") then
                              inst_PMconnects <= "100";
                          else 
                            if(inst(6 downto 5) = "10") then
                                inst_PMconnects <= "111";
                            else 
                            	if(inst(6 downto 5) = "11") then
                                	inst_PMconnects <= "101";
                                end if;
                            end if;
                          end if;
                        end if;
                    end if;

                when 3 =>
                    ReW <= '1';
                    BW <= '1';
                    Rsrc <= "01";
                    Asrc1 <= '1';
                    Asrc2 <= "10";

                    if(inst(23)='1') then -- up-1 down-0
                        op <= "0100";
                    else
                        op <= "0010";
                    end if;

                    if(inst(20)='0') then -- str =0; ldr = 1;
                        State_in <= 6;
                        if (inst(27 downto 26)="01") then
                            inst_PMconnects <= "000";
                        else 
                        	if(inst(6 downto 5) = "01") then
                            	inst_PMconnects <= "001";
                            end if;
                        end if;
                    else
                        State_in <= 7;
                        if (inst(27 downto 26)="01") then
                            inst_PMconnects <= "011";
                        else if(inst(6 downto 5) = "01") then
                            inst_PMconnects <= "100";
                        else if(inst(6 downto 5) = "10") then
                            inst_PMconnects <= "111";
                        else if(inst(6 downto 5) = "11") then
                            inst_PMconnects <= "101";
                        end if;
                        end if;
                        end if;
                        end if;
                    end if;
                when 6 =>
                    if(inst(21)='1') then
                    	M2R <= '0';
                        RW <= '1';
                    end if;
                    if(inst(24)='1') then
                    	lorD <= "01";
                    else
                    	lorD <= "10";
                    end if;
                    cs_PMconnects <= '1';
                    State_in <= 0;
                when 7 =>
                    DW <= '1';
                    if(inst(21)='1') then
                    	M2R <= '0';
                        RW <= '1';
                    end if;
                    if(inst(24)='1') then
                    	lorD <= "01";
                    else
                    	lorD <= "10";
                    end if;
                    cs_PMconnects <= '1';
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