LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ProcessorPkg.ALL;

ENTITY ControlUnit IS
PORT (    
    i_Instruction : IN t_Reg8;
    
    o_Memory_Write_Enable : OUT STD_LOGIC;
    o_Memory_Enable : OUT STD_LOGIC;
    o_Branch : OUT STD_LOGIC;
    o_Branch_Equal : OUT STD_LOGIC;
    o_Branch_Not_Equal : OUT STD_LOGIC;
    o_Operation : OUT t_Operation;
    o_Load_Flags : OUT STD_LOGIC;
    o_Input_Select : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    o_Register_Write_Enable : OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE RTL OF ControlUnit IS
    SIGNAL w_Operation : t_Operation := op_INVALID;
    SIGNAL w_Is_Arithmetic_Logic : STD_LOGIC := '0';
BEGIN
    w_Operation <= f_DecodeInstruction(i_Instruction);
    
    w_Is_Arithmetic_Logic <= '1' WHEN (
        w_Operation = op_ADD OR
        w_Operation = op_SUB OR
        w_Operation = op_AND OR
        w_Operation = op_OR OR
        w_Operation = op_SHL OR
        w_Operation = op_SHR OR
        w_Operation = op_NOT OR
        w_Operation = op_CMP
    ) ELSE '0';

    o_Memory_Write_Enable <= '1' WHEN (w_Operation = op_STR) ELSE '0';

    o_Memory_Enable <= '1' WHEN (w_Operation = op_LDR OR w_Operation = op_STR) ELSE '0';

    o_Branch <= '1' WHEN (w_Operation = op_B) ELSE '0';

    o_Branch_Equal <= '1' WHEN (w_Operation = op_BEQ) ELSE '0';

    o_Branch_Not_Equal <= '1' WHEN (w_Operation = op_BNE) ELSE '0';

    o_Operation <= w_Operation;

    o_Load_Flags <= '1' WHEN (w_Is_Arithmetic_Logic = '1') ELSE '0';

    o_Input_Select <=   "00" WHEN (w_Operation = op_LI) ELSE
                        "10" WHEN (w_Operation = op_LDR) ELSE
                        "01";
    
    o_Register_Write_Enable <= '1' WHEN (
        (w_Is_Arithmetic_Logic = '1' AND w_Operation /= op_CMP) OR
        w_Operation = op_MOV OR
        w_Operation = op_LDR OR
        w_Operation = op_LI
    ) ELSE '0';

END ARCHITECTURE;