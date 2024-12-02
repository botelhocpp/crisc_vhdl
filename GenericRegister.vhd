LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.ProcessorPkg.ALL;

ENTITY GenericRegister IS
PORT (
    i_D : IN t_Reg8;
    i_Load : IN STD_LOGIC;
    i_Clk : IN STD_LOGIC;
    i_Rst : IN STD_LOGIC;
    o_Q : OUT t_Reg8
);
END ENTITY;

ARCHITECTURE RTL OF GenericRegister IS
    SIGNAL r_Q : t_Reg8 := (OTHERS => '0');
BEGIN    
    o_Q <= r_Q;

    p_LOAD_REGISTER:
    PROCESS(i_Rst, i_Clk)
    BEGIN
        IF(i_Rst = '1') THEN
            r_Q <= (OTHERS => '0');
        ELSIF(RISING_EDGE(i_Clk)) THEN
            IF(i_Load = '1') THEN
                r_Q <= i_D;
            END IF;
        END IF;
    END PROCESS p_LOAD_REGISTER;
END ARCHITECTURE;