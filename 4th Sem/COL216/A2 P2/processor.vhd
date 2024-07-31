library IEEE;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is
    port(
        clock : in std_logic
    );
end entity Processor;

architecture BEV of Processor is

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
    writeEnable, clock : in STD_LOGIC;
    dataOut1, dataOut2 : out STD_LOGIC_VECTOR(31 downto 0)
        );
END COMPONENT REG; 

COMPONENT DATA_MEMORY IS
PORT(
    addr : in STD_LOGIC_VECTOR(5 downto 0);
    dataIn	: in STD_LOGIC_VECTOR(31 downto 0);        
    dataOut : out STD_LOGIC_VECTOR(31 downto 0);
    WriteEnable: in STD_LOGIC_VECTOR(3 downto 0);
    clock : in STD_LOGIC
        );
END COMPONENT DATA_MEMORY;

COMPONENT PROGRAM_MEMORY IS
PORT(read : in STD_LOGIC_VECTOR(5 downto 0);
    dataOut : out STD_LOGIC_VECTOR(31 downto 0)
        );
END COMPONENT PROGRAM_MEMORY;

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

component ProgramCounter is 
    port(
        clock : in std_logic;
        data_in : in STD_LOGIC_VECTOR(31 downto 0);
        P : in std_logic;
        PC_out : out STD_LOGIC_VECTOR(5 downto 0)
    );
end component ProgramCounter;

signal PC : std_logic_vector(5 downto 0);
signal P : std_logic := '0';
signal inst : std_logic_vector(31 downto 0) := x"00000000";
signal Z : std_logic := '0';
signal C : std_logic := '0';
signal V : std_logic := '0';
signal N : std_logic := '0';
signal cond : std_logic_vector(3 downto 0);
signal S : std_logic;
signal OPcode : std_logic_vector(3 downto 0);
signal A : std_logic_vector(31 downto 0);
signal B : std_logic_vector(31 downto 0);
signal regDataOut1 : std_logic_vector(31 downto 0);
signal regDataOut2 : std_logic_vector(31 downto 0);
signal ALU_out : std_logic_vector(31 downto 0);
signal reg_addr1 : std_logic_vector(3 downto 0);
signal reg_addr2 : std_logic_vector(3 downto 0);
signal reg_addr_write : std_logic_vector(3 downto 0);
signal registerWriteEnable : std_logic;
signal regDataIn : std_logic_vector(31 downto 0);
signal dataMemAddress : std_logic_vector(5 downto 0);
signal dataMemDataIn : std_logic_vector(31 downto 0);
signal dataMemDataOut : std_logic_vector(31 downto 0);
signal dataMemWriteEnable : std_logic_vector(3 downto 0);
signal ALU_cout : std_logic;
signal F : std_logic_vector(1 downto 0);
signal I : std_logic;
signal OPcodeDT : std_logic_vector(5 downto 0);

begin
    UUT1 : ProgramCounter port map(clock, inst, P, PC);

    UUT2 : CondChecker port map(Z, N, C, V, cond, P);

    UUT3 : Flags port map(S, OPcode, ALU_out, A, B, ALU_cout, C, Z, N ,V);

    UUT4 : PROGRAM_MEMORY port map(PC, inst);

    UUT5 : DATA_MEMORY port map(dataMemAddress, dataMemDataIn, dataMemDataOut, dataMemWriteEnable,clock);

    UUT6 : REG port map(reg_addr1, reg_addr2, reg_addr_write, regDataIn, registerWriteEnable, clock, regDataOut1, regDataOut2);

    UUT7 : ALU port map(A, B, C, OPcode, ALU_out, ALU_cout);

    cond <= inst(31 downto 28); 
	F <= inst(27 downto 26);
    process(clock,PC,registerWriteEnable,dataMemWriteEnable,inst,ALU_out,regDataOut1,regDataOut2,dataMemDataOut)
    begin

        registerWriteEnable <= '0';
        dataMemWriteEnable <= "0000";

        case(F) is
            when "00" =>
                I <= inst(25);
                OPcode <= inst(24 downto 21);
                reg_addr1 <= inst(19 downto 16);
                A <= regDataOut1;
                reg_addr_write <= inst(15 downto 12);
                if(inst(25) = '0') then
                    reg_addr2 <= inst(3 downto 0);
                    B <= regDataOut2;
                else
                    B <= std_logic_vector(resize(unsigned(inst(7 downto 0)),32));
                end if;
                regDataIn <= ALU_out;
                registerWriteEnable <= '1';              
            when "01" =>
                S <= '0';
                OPcodeDT <= inst(25 downto 20);

                if(OPcodeDT(0)='1') then --str -0 ldr -1
                    reg_addr1 <= inst(19 downto 16);
                    reg_addr2 <= inst(15 downto 12);
                else 
                    reg_addr2 <= inst(15 downto 12);
                    reg_addr1 <= inst(19 downto 16);
                    dataMemDataIn <= regDataOut2;
                end if;
                    A <= regDataOut1;

                if(OPcodeDT(3)='1') then -- up-1 down-0
                    OPcode <= "0100";
                else
                    OPcode <= "0010";
                end if;

                if(OPcodeDT(5)='0') then --constant or register
                    B <= std_logic_vector(resize(unsigned(inst(11 downto 0)),32));
                end if;

                if(OPcodeDT(4)='1') then -- pre or post indexing
                    dataMemAddress <= ALU_out(5 downto 0);
                else
                    dataMemAddress <= A(5 downto 0);
                end if;
                
                if(OPcodeDT(1)='1') then -- writeback in register
                    regDataIn <= ALU_out;
                    reg_addr_write <= inst(19 downto 16);
                    registerWriteEnable <= '1';
                end if;                                       
                    
                if(OPcodeDT(0)='1') then --str -0 ldr -1
                    reg_addr_write <= inst(15 downto 12);
                    regDataIn <= dataMemDataOut;
                    registerWriteEnable <= '1';
                else 
                    dataMemWriteEnable <= "1111";
                end if;
                
            when "10" =>
                S <= '0';
            when "11" =>
                null;
            when others => null;
        end case;
    end process;
end BEV;