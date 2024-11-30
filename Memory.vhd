LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ProcessorPkg.ALL;

ENTITY Memory IS
GENERIC ( g_CONTENTS : t_MemoryArray := (OTHERS => (OTHERS => '0')) );
PORT (
    i_Address : IN t_Reg8;
    i_Write_Enable : IN STD_LOGIC;
    i_Enable : IN STD_LOGIC;
    i_Clk : IN STD_LOGIC;
    io_Data : INOUT t_Reg8
);
END ENTITY;

ARCHITECTURE RTL OF Memory IS 
    SIGNAL r_Contents : t_MemoryArray := g_CONTENTS;
BEGIN 
    io_Data <= r_Contents(TO_INTEGER(t_UReg8(i_Address))) WHEN (i_Write_Enable = '0' AND i_Enable = '1') ELSE (OTHERS => 'Z');

    p_MEMORY_READ_WRITE_CONTROL:
    PROCESS(i_Clk)
    BEGIN
        IF(RISING_EDGE(i_Clk)) THEN
            IF(i_Write_Enable = '1' AND i_Enable = '1') THEN
                r_Contents(TO_INTEGER(t_UReg8(i_Address))) <= io_Data;
            END IF;
        END IF;
    END PROCESS p_MEMORY_READ_WRITE_CONTROL;
END ARCHITECTURE;
