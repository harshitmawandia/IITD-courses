library IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MultiCycleProcessor is
    port(
        clock : in std_logic
    );
end entity MultiCycleProcessor;

architecture BEV of MultiCycleProcessor is

COMPONENT ALU
PORT(
        A : IN  std_logic_vector(31 downto 0);
        B : IN  std_logic_vector(31 downto 0);
        c : IN std_logic;
        ALU_Sel : IN  std_logic_vector(3 downto 0);
        ALU_Out : OUT  std_logic_vector(31 downto 0);
        Carryout : OUT  std_logic
    );
END COMPONENT ALU;

COMPONENT REG IS
PORT(
    read1, read2, write : in STD_LOGIC_VECTOR(3 downto 0);
    dataIn	: in STD_LOGIC_VECTOR(31 downto 0);
    RW, clock : in STD_LOGIC;
    dataOut1, dataOut2 : out STD_LOGIC_VECTOR(31 downto 0)
        );
END COMPONENT REG; 

COMPONENT MEMORY IS
PORT(
    addr : in STD_LOGIC_VECTOR(5 downto 0);
    dataIn	: in STD_LOGIC_VECTOR(31 downto 0);        
    dataOut : out STD_LOGIC_VECTOR(31 downto 0);
    MW: in STD_LOGIC_VECTOR(3 downto 0);
    lorD: in std_logic;
    clock : in STD_LOGIC
        );
END COMPONENT MEMORY;

component Flags is  
Port (
    S : in std_logic;
    OPCode  : in STD_LOGIC_VECTOR(3 downto 0);
    ALU_Out, A, B   : in  STD_LOGIC_VECTOR(31 downto 0);
    C_in    : in std_logic;
    C,Z,N,V : out std_logic
);
end component Flags;

component CondChecker is
    port(
        Z,N,C,V : in std_logic;
        cond : in STD_LOGIC_VECTOR(3 downto 0);
        PP : out std_logic
    );
end component CondChecker;

component ProgramCounterNew is 
    port(
        clock : in std_logic;
        PC_in : in STD_LOGIC_VECTOR(5 downto 0);
        -- data_in : in STD_LOGIC_VECTOR(31 downto 0);
        PW : in std_logic;
        PC_out : out STD_LOGIC_VECTOR(5 downto 0)
    );
end component ProgramCounterNew;

component FSM is
    port(
        clock : in std_logic;
        inst : in std_logic_vector(31 downto 0);
        P : in std_logic;
        PW, lorD, Rsrc, M2R, RW, Asrc1, Fset, IW, DW, AW, BW, ReW : out std_logic;
        Asrc2 : out std_logic_vector(1 downto 0);
        op, MW : out std_logic_vector(3 downto 0);
        State_out : out integer
    );
end component FSM;

signal inst : std_logic_vector(31 downto 0):= x"00000000";
signal PW : std_logic:= '0';
signal lorD : std_logic:= '0';
signal MW : std_logic_vector:= "0000";
signal Rsrc : std_logic:= '0';
signal M2R : std_logic:= '0';
signal Asrc1 : std_logic:= '0';
signal RW : std_logic:= '0';
signal Fset : std_logic:= '0';
signal IW : std_logic:= '0';
signal DW : std_logic:= '0';
signal AW : std_logic:= '0';
signal BW : std_logic:= '0';
signal ReW : std_logic:= '0';
signal Asrc2 : std_logic_vector(1 downto 0);
signal op : std_logic_vector(3 downto 0);
signal State_out : integer := 0;
signal PC_in : std_logic_vector(5 downto 0) := "000000";
signal PC_out : std_logic_vector(5 downto 0) := "000000";
signal Z : std_logic:= '0';
signal C : std_logic:= '0';
signal V : std_logic:= '0';
signal N : std_logic:= '0';
signal cond : std_logic_vector(3 downto 0);
signal P : std_logic:= '0';
signal ALU_out : std_logic_vector(31 downto 0):= x"00000000";
signal A : std_logic_vector(31 downto 0):= x"00000000";
signal B : std_logic_vector(31 downto 0):= x"00000000";
signal ALU_cout : std_logic;
signal regDataOut1 : std_logic_vector(31 downto 0);
signal regDataOut2 : std_logic_vector(31 downto 0);
signal reg_addr1 : std_logic_vector(3 downto 0);
signal reg_addr2 : std_logic_vector(3 downto 0);
signal reg_addr_write : std_logic_vector(3 downto 0);
signal regDataIn : std_logic_vector(31 downto 0);
signal MemAddress : std_logic_vector(5 downto 0);
signal MemDataIn : std_logic_vector(31 downto 0);
signal MemDataOut : std_logic_vector(31 downto 0);
signal IR : std_logic_vector(31 downto 0) := x"00000000";
signal DR : std_logic_vector(31 downto 0);
signal AR : std_logic_vector(31 downto 0);
signal BR : std_logic_vector(31 downto 0);
signal Res : std_logic_vector(31 downto 0);

begin 

    UUT_FSM : FSM port map(clock, inst, P, PW, lorD, Rsrc, M2R, RW, Asrc1, Fset, IW, DW, AW, BW, ReW, Asrc2, op, MW, State_out);

    UUT_PC : ProgramCounterNew port map(clock, PC_in, PW, PC_out);

    UUT_Conditions : CondChecker port map(Z, N, C, V, Cond, P);

    UUT_Flags : Flags port map(Fset, op, ALU_out, A, B, ALU_cout, C, Z, N ,V);

    UUT_Mem : MEMORY port map(MemAddress, MemDataIn, MemDataOut, MW, lorD, clock);

    UUT_Reg : REG port map(reg_addr1, reg_addr2, reg_addr_write, regDataIn, RW, clock, regDataOut1, regDataOut2);

    UUT_ALU : ALU port map(A, B, C, op, ALU_out, ALU_cout);

    inst <= IR;

    cond <= IR(31 downto 28);

    Res <= ALU_out when ReW = '1' else Res;

    MemAddress <= PC_out when (lorD = '0') else Res(5 downto 0);

    IR <= MemDataOut when (IW = '1') else IR;

    reg_addr1 <= IR(19 downto 16);

    reg_addr2 <= IR(3 downto 0) when (Rsrc = '0') else IR(15 downto 12);

    reg_addr_write <= IR(15 downto 12);

    DR <= MemDataOut when (DW = '1') else DR;

    regDataIn <= Res when (M2R = '0') else DR;

    AR <= regDataOut1 when (AW = '1') else AR;

    A <= std_logic_vector(resize(signed(PC_out),32)) when (Asrc1 = '0') else AR;

    BR <= regDataOut2 when (BW = '1') else BR;
    
        B <= BR when (Asrc2="00") else
         x"00000001" when (Asrc2="01") else
         std_logic_vector(resize(unsigned(IR(11 downto 0)),32)) when (Asrc2="10") else
         std_logic_vector(resize(signed(IR(23 downto 0)),32));

    PC_in <= ALU_out(5 downto 0);

    C <= '1' when (Asrc2 ="11") else C;
    
    MemDataIn <= BR;

end BEV;  