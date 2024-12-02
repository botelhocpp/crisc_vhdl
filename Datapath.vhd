LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ProcessorPkg.ALL;

ENTITY Datapath IS
PORT ( 
    i_Data_In               : IN t_Reg8;
    i_Instruction           : IN t_Reg8;

    i_Clk                   : IN STD_LOGIC;
    i_Rst                   : IN STD_LOGIC;
    
    i_Branch                : IN STD_LOGIC;
    i_Branch_Equal          : IN STD_LOGIC;
    i_Branch_Not_Equal      : IN STD_LOGIC;
    i_Operation             : IN t_Operation;
    i_Load_Flags            : IN STD_LOGIC;
    i_Input_Select          : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    i_Write_Enable          : IN STD_LOGIC;

    o_Data_Address          : OUT t_Reg8;
    o_Instruction_Address   : OUT t_Reg8;
    o_Data_Out              : OUT t_Reg8
);
END ENTITY;

ARCHITECTURE RTL OF Datapath IS
    CONSTANT c_ZERO_FLAG_INDEX : INTEGER := 0;

    SIGNAL w_Alu_Flag_Zero : STD_LOGIC := '0';
    SIGNAL w_Perform_Branch : STD_LOGIC := '0';
    
    SIGNAL w_Flags_Input : t_Reg8 := (OTHERS => '0');
    SIGNAL w_Flags_Output : t_Reg8 := (OTHERS => '0');
    SIGNAL w_Input_Mux : t_Reg8 := (OTHERS => '0');
    SIGNAL w_Pc_Input_Mux : t_Reg8 := (OTHERS => '0');
    SIGNAL w_Pc_Output : t_Reg8 := (OTHERS => '0');
    SIGNAL w_Alu_Result : t_Reg8 := (OTHERS => '0');
    SIGNAL w_Read_Source : t_Reg8 := (OTHERS => '0');
    SIGNAL w_Read_Destiny : t_Reg8 := (OTHERS => '0');

    ALIAS a_Zero_Flag IS w_Flags_Output(c_ZERO_FLAG_INDEX);
    ALIAS a_Source_Select IS i_Instruction(3 DOWNTO 2);
    ALIAS a_Destiny_Select IS i_Instruction(1 DOWNTO 0);
    ALIAS a_Immediate IS i_Instruction(5 DOWNTO 2);
BEGIN
    e_PC_REGISTER: ENTITY WORK.GenericRegister
    PORT MAP (
        i_D => w_Pc_Input_Mux,
        i_Load => '1',
        i_Clk => i_Clk,
        i_Rst => i_Rst,
        o_Q => w_Pc_Output
    );
    e_FLAGS_REGISTER: ENTITY WORK.GenericRegister
    PORT MAP (
        i_D => w_Flags_Input,
        i_Load => i_Load_Flags,
        i_Clk => i_Clk,
        i_Rst => i_Rst,
        o_Q => w_Flags_Output
    );
    e_REGISTER_FILE: ENTITY WORK.RegisterFile
    PORT MAP(
        i_Write_Data => w_Input_Mux,
        i_Source_Select => a_Source_Select,
        i_Destiny_Select => a_Destiny_Select,
        i_Write_Enable => i_Write_Enable,
        i_Clk => i_Clk,
        i_Rst => i_Rst,
        o_Read_Source => w_Read_Source,
        o_Read_Destiny => w_Read_Destiny
    );
    e_ALU: ENTITY WORK.ArithmeticLogicUnit
    PORT MAP(
        i_Op_1 => w_Read_Destiny,
        i_Op_2 => w_Read_Source,
        i_Sel => i_Operation,
        o_Flag_Zero => w_Alu_Flag_Zero,
        o_Result => w_Alu_Result
    );
    
    o_Data_Address <= w_Alu_Result;
    o_Instruction_Address <= w_Pc_Output;
    o_Data_Out <= w_Read_Destiny;

    w_Pc_Input_Mux <= w_Read_Destiny WHEN (w_Perform_Branch = '1') ELSE t_Reg8(t_Ureg8(w_Pc_Output) + 1);

    w_Input_Mux <=  ("0000" & a_Immediate)  WHEN (i_Input_Select = "00") ELSE
                    w_Alu_Result            WHEN (i_Input_Select = "01") ELSE
                    i_Data_In;

    w_Flags_Input <= (
        c_ZERO_FLAG_INDEX => w_Alu_Flag_Zero, 
        OTHERS => '0'
    );

    w_Perform_Branch <= (i_Branch) OR 
                        (a_Zero_Flag AND i_Branch_Equal) OR 
                        (NOT a_Zero_Flag AND i_Branch_Not_Equal);
END ARCHITECTURE;
