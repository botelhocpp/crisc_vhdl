LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ProcessorPkg.ALL;

ENTITY RegisterFile IS
PORT ( 
    i_Write_Data : IN t_Reg8;
    i_Source_Select : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    i_Destiny_Select : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    i_Write_Enable : IN STD_LOGIC;
    i_Clk : IN STD_LOGIC;
    i_Rst : IN STD_LOGIC;
    o_Read_Source : OUT t_Reg8;
    o_Read_Destiny : OUT t_Reg8 
);
END ENTITY;

ARCHITECTURE RTL OF RegisterFile IS
    TYPE t_RegisterArray IS ARRAY (0 TO c_NUMBER_REGISTERS - 1) OF t_Reg8;
    
    SIGNAL w_Registers : t_RegisterArray;
    SIGNAL w_Load_Registers : STD_LOGIC_VECTOR(c_NUMBER_REGISTERS - 1 DOWNTO 0) := (OTHERS => '0');
BEGIN
    gen_GENERATE_REGISTERS:
    FOR i IN w_Load_Registers'RANGE GENERATE
        w_Load_Registers(i) <= '1' WHEN (TO_INTEGER(UNSIGNED(i_Destiny_Select)) = i AND i_Write_Enable = '1') ELSE '0';
        
        e_REGISTER: ENTITY WORK.GenericRegister
        PORT MAP (
            i_D     => i_Write_Data,
            i_Load  => w_Load_Registers(i),
            i_Clk   => i_Clk,
            i_Rst   => i_Rst,
            o_Q     => w_Registers(i)
        );
    END GENERATE gen_GENERATE_REGISTERS;

    o_Read_Source <= w_Registers(TO_INTEGER(UNSIGNED(i_Source_Select)));  
    o_Read_Destiny <= w_Registers(TO_INTEGER(UNSIGNED(i_Destiny_Select)));    
END ARCHITECTURE;
