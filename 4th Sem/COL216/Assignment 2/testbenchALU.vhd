-- Code your testbench here
library IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY tb_ALU IS
END tb_ALU;
 
ARCHITECTURE behavior OF tb_ALU IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         c : IN std_logic;
         ALU_Sel : IN  std_logic_vector(3 downto 0);
         ALU_Out : OUT  std_logic_vector(31 downto 0);
         Carryout : OUT  std_logic
        );
    END COMPONENT;
       --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');
   signal c : std_logic := '0';
   signal ALU_Sel : std_logic_vector(3 downto 0) := (others => '0');

  --Outputs
   signal ALU_Out : std_logic_vector(31 downto 0);
   signal Carryout : std_logic;
 
 signal i:integer;
BEGIN
 
 -- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          A => A,
          B => B,
          c => c,
          ALU_Sel => ALU_Sel,
          ALU_Out => ALU_Out,
          Carryout => Carryout
        );

 

   -- Stimulus process
   stim_proc: process
   begin  
      -- hold reset state for 100 ns.
      A <= x"FFFFFFFF";
      B <= x"FFFFFFFF";
      ALU_Sel <= x"0";
      c <= '1';
      for i in 0 to 15 loop 
      	 wait for 100 ns;
         ALU_Sel <= ALU_Sel + x"1";
         
      end loop;
      	wait for 100 ns;
         A <= x"F6F6F6F6";
         B <= x"0A0A0A0A";
      wait;
   end process;

END;