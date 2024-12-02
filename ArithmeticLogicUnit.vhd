LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ProcessorPkg.ALL;

ENTITY ArithmeticLogicUnit IS
PORT(
    i_Op_1 : IN t_Reg8;
    i_Op_2 : IN t_Reg8;
    i_Sel : IN t_Operation;
    o_Flag_Zero : OUT STD_LOGIC;
    o_Result : OUT t_Reg8
);
END ENTITY;

ARCHITECTURE RTL OF ArithmeticLogicUnit IS
    CONSTANT c_ZERO : t_Reg8 := (OTHERS => '0');
    
    SIGNAL w_Result : t_Reg8 := (OTHERS => '0');
BEGIN
    WITH i_Sel SELECT
        w_Result <= (t_Reg8(t_SReg8(i_Op_1) + t_SReg8(i_Op_2)))     WHEN op_ADD,
                    (t_Reg8(t_SReg8(i_Op_1) - t_SReg8(i_Op_2)))     WHEN op_SUB | op_CMP,
                    (i_Op_1 AND i_Op_2)                             WHEN op_AND,
                    (i_Op_1 OR i_Op_2)                              WHEN op_OR,
                    (t_Reg8(SHIFT_LEFT(t_UReg8(i_Op_1), TO_INTEGER(t_UReg8(i_Op_2)))))        WHEN op_SHL,
                    (t_Reg8(SHIFT_RIGHT(t_UReg8(i_Op_1), TO_INTEGER(t_UReg8(i_Op_2)))))       WHEN op_SHR,
                    (NOT i_Op_1)                                    WHEN op_NOT,
                    (i_Op_2)                                        WHEN op_MOV | op_LDR | op_STR,
                    (OTHERS => '0')                                 WHEN OTHERS;

    o_Result <= w_Result;

	o_Flag_Zero <= '1' WHEN (w_Result = c_ZERO) ELSE '0';
END ARCHITECTURE;
