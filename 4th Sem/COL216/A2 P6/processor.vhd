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
    lorD: in STD_LOGIC_VECTOR(1 downto 0);
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
        PW, M2R, RW, Asrc1, Fset, IW, DW, AW, BW, ReW, Ssrc1, XW, DDW, BorR, cs_PMconnects : out std_logic;
        Asrc2, Rsrc, Ssrc2, Stype, lorD : out std_logic_vector(1 downto 0);
        op : out std_logic_vector(3 downto 0);
        inst_PMconnects : out std_logic_vector(2 downto 0);
        State_out : out integer
    );
end component FSM;

component Shifter is
    port(
        input : in std_logic_vector(31 downto 0);
        shift : in std_logic_vector(1 downto 0);
        amount : in std_logic_vector(4 downto 0);
        carry : out std_logic;
        output : out std_logic_vector(31 downto 0)
    );
end component Shifter;

component PMConnects is
    port(
        Rout,Mout : in std_logic_vector(31 downto 0);
        inst : in std_logic_vector(2 downto 0);
        cs : in std_logic;
        adr : in std_logic_vector(1 downto 0);
        Rin, Min : out std_logic_vector(31 downto 0);
        MW : out std_logic_vector(3 downto 0)
    );
end component PMConnects;

signal inst_PMconnects : std_logic_vector(2 downto 0);
signal cs_PMconnects : std_logic := '0';
signal adr : std_logic_vector(1 downto 0);
signal Rin : std_logic_vector(31 downto 0);
signal Min : std_logic_vector(31 downto 0);
signal input_shifter : std_logic_vector(31 downto 0):= x"00000000";
signal shift_amount : std_logic_vector(4 downto 0);
signal shifter_carryOut : std_logic;
signal shifter_output : std_logic_vector(31 downto 0);
signal inst : std_logic_vector(31 downto 0):= x"00000000";
signal PW : std_logic:= '0';
signal lorD : std_logic_vector(1 downto 0):= "00";
signal BorR : std_logic:= '0';
signal MW : std_logic_vector(3 downto 0);
signal Rsrc : std_logic_vector(1 downto 0):= "00";
signal Ssrc2: std_logic_vector(1 downto 0):= "00"; 
signal Stype: std_logic_vector(1 downto 0):= "00"; 
signal M2R : std_logic:= '0';
signal Asrc1 : std_logic:= '0';
signal Ssrc1 : std_logic:= '0';
signal RW : std_logic:= '0';
signal Fset : std_logic:= '0';
signal IW : std_logic:= '0';
signal DW : std_logic:= '0';
signal AW : std_logic:= '0';
signal BW : std_logic:= '0';
signal XW : std_logic:= '0';
signal DDW : std_logic:= '0';
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
signal XR : std_logic_vector(31 downto 0);
signal DDR : std_logic_vector(31 downto 0);
signal amountShiftVariable : std_logic_vector(4 downto 0);

begin 

    UUT_FSM : FSM port map(clock, inst, P, PW, M2R, RW, Asrc1, Fset, IW, DW, AW, BW, ReW,Ssrc1, XW, DDW,BorR, cs_PMconnects, Asrc2, Rsrc,Ssrc2,Stype, lorD, op, inst_PMconnects, State_out);

    UUT_PC : ProgramCounterNew port map(clock, PC_in, PW, PC_out);

    UUT_Conditions : CondChecker port map(Z, N, C, V, Cond, P);

    UUT_Flags : Flags port map(Fset, op, ALU_out, A, B, ALU_cout, C, Z, N ,V);

    UUT_Mem : MEMORY port map(MemAddress, MemDataIn, MemDataOut, MW, lorD, clock);

    UUT_Reg : REG port map(reg_addr1, reg_addr2, reg_addr_write, regDataIn, RW, clock, regDataOut1, regDataOut2);

    UUT_ALU : ALU port map(A, B, C, op, ALU_out, ALU_cout);

    UUT_Shifter : Shifter port map(input_shifter, Stype, shift_amount, shifter_carryOut,shifter_output); 

    UUT_PMConnects : PMConnects port map(BR, MemDataOut, inst_PMconnects, cs_PMconnects, adr, Rin, Min, MW);

    inst <= IR;

    cond <= IR(31 downto 28);

    Res <= ALU_out when ReW = '1' else Res;

    MemAddress <= PC_out when (lorD = "00") else 
    				Res(7 downto 2) when (lorD = "01") else
                    AR(7 downto 2);
    adr <= "00" when (lorD = "00") else 
            Res(1 downto 0) when (lorD = "01") else
            AR(1 downto 0);

    IR <= Rin when (IW = '1') else IR;

    reg_addr1 <= IR(19 downto 16);

    reg_addr2 <= IR(3 downto 0) when (Rsrc = "00") else 
                 IR(15 downto 12) when (Rsrc = "01") else
                 IR(11 downto 8);

    reg_addr_write <= IR(15 downto 12);

    DR <= Rin when (DW = '1') else DR;

    regDataIn <= Res when (M2R = '0') else DR;

    AR <= regDataOut1 when (AW = '1') else AR;

    A <= std_logic_vector(resize(signed(PC_out),32)) when (Asrc1 = '0') else AR;

    BR <= regDataOut2 when (BW = '1' and BorR = '0') else BR;

    XR <= regDataOut2 when (XW = '1' and BorR = '1') else XR;

    input_shifter <= std_logic_vector(resize(unsigned(IR(7 downto 0)),32)) when Ssrc1 = '0' else
                     BR;
    
    amountShiftVariable(4 downto 1) <= IR(11 downto 8);
    amountShiftVariable(0) <= '0';

    shift_amount <= XR(4 downto 0) when (Ssrc2 = "00") else
                    amountShiftVariable when (Ssrc2 = "01") else
                    IR(11 downto 7);
    
    DDR <= shifter_output when (DDW = '1') else DDR;

    B <= DDR when (Asrc2="00") else
        x"00000001" when (Asrc2="01") else
        std_logic_vector(resize(unsigned(IR(11 downto 0)),32)) when (Asrc2="10") else
        std_logic_vector(resize(signed(IR(23 downto 0)),32));

    PC_in <= ALU_out(5 downto 0);

    C <= '1' when (Asrc2 ="11") else C;
    
    MemDataIn <= Min;

end BEV;  