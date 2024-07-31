-- Code your design here
library IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is  
    Port (
    A, B     : in  STD_LOGIC_VECTOR(31 downto 0);  -- 2 inputs 32-bit
    ALU_Sel  : in  STD_LOGIC_VECTOR(3 downto 0);  -- 1 input 4-bit for selecting
    c	 : in  std_logic;
    ALU_Out   : out  STD_LOGIC_VECTOR(31 downto 0); -- 1 output 32-bit 
    Carryout : out std_logic       -- Carryout flag
    );
end ALU; 
architecture Behavioral of ALU is

signal ALU_Result : STD_LOGIC_VECTOR (32 downto 0);

begin
	ALU_Out <= ALU_Result(31 downto 0); -- ALU out
 Carryout <= ALU_Result(32); -- Carryout flag
   process(A,B,c,ALU_Sel)
 begin
  case(ALU_Sel) is
  when "0000" => -- And
   ALU_Result <= STD_LOGIC_VECTOR(resize(unsigned(A and B),33)) ; 
  when "0001" => -- EOR
   ALU_Result <= STD_LOGIC_VECTOR(resize(unsigned(A xor B),33)) ;
  when "0010" => -- Sub
   ALU_Result <= STD_LOGIC_VECTOR(resize(signed(not B),33)+ resize(signed(A),33)+1) ;
  when "0011" => -- RSB
   ALU_Result <= STD_LOGIC_VECTOR(resize(signed(B),33)+ resize(signed(not A),33)+1) ;
  when "0100" => -- Add
    ALU_Result <= STD_LOGIC_VECTOR(resize(signed(B),33)+ resize(signed(A),33)) ;
  when "0101" => -- ADC
   ALU_Result <= STD_LOGIC_VECTOR(resize(signed(B),33)+ resize(signed(A),33)+c) ;
  when "0110" => --  SBC
   ALU_Result <= STD_LOGIC_VECTOR(resize(signed(not B),33)+ resize(signed(A),33)+c) ;
  when "0111" => -- RSC
   ALU_Result <= STD_LOGIC_VECTOR(resize(signed(B),33)+ resize(signed(not A),33)+c) ;
  when "1000" => -- TST
   ALU_Result <= STD_LOGIC_VECTOR(resize(unsigned(A and B),33)) ; 
  when "1001" => -- TEQ
   ALU_Result <= STD_LOGIC_VECTOR(resize(unsigned(A xor B),33)) ;
  when "1010" => -- CMP 
   ALU_Result <= STD_LOGIC_VECTOR(resize(signed(not B),33)+ resize(signed(A),33)+1) ;
  when "1011" => -- CMN
   ALU_Result <= STD_LOGIC_VECTOR(resize(signed(B),33)+ resize(signed(A),33)) ;
  when "1100" => -- ORR
   ALU_Result <= STD_LOGIC_VECTOR(resize(unsigned(A or B),33)) ;
  when "1101" => -- MOV
   ALU_Result <= STD_LOGIC_VECTOR(resize(unsigned(B),33));
  when "1110" => -- BIC
   ALU_Result <= STD_LOGIC_VECTOR(resize(unsigned(A and not(B)),33)) ;  
  when "1111" => -- MVN   
   ALU_Result <= STD_LOGIC_VECTOR(resize(signed(not (B)),33));
  when others => null ; 
  end case;
 end process;
end Behavioral;