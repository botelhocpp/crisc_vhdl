LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ProcessorPkg.ALL;

ENTITY InputOutputController IS
PORT (
    i_Address       : IN t_Reg8;
    i_Write_Enable  : IN STD_LOGIC;
    i_Enable        : IN STD_LOGIC;
    i_Clk           : IN STD_LOGIC;
    i_Switches      : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    o_Leds          : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    io_Data         : INOUT t_Reg8
);
END ENTITY;

ARCHITECTURE RTL OF InputOutputController IS 
    CONSTANT c_LEDS_ADDRESS : INTEGER := 0;
    CONSTANT c_SWITCHES_ADDRESS : INTEGER := 1;
    
    TYPE t_IORegisterArray IS ARRAY (0 TO 1) OF t_Reg8; 
    SIGNAL r_IO_Registers : t_IORegisterArray := (OTHERS => (OTHERS => '0'));
    SIGNAL r_Leds : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');

    --ALIAS a_Leds_Register : t_Reg8 IS r_IO_Registers(c_LEDS_ADDRESS);
    --ALIAS a_Switches_Register : t_Reg8 IS r_IO_Registers(c_SWITCHES_ADDRESS);
BEGIN 
    o_Leds <= r_Leds;
    io_Data <= r_IO_Registers(TO_INTEGER(t_UReg8(i_Address))) WHEN (
        i_Write_Enable = '0' AND 
        i_Enable = '1' AND
        i_Address < x"02"
    ) ELSE (OTHERS => 'Z');

    p_REGISTERS_READ_WRITE_CONTROL:
    PROCESS(i_Clk)
    BEGIN
        IF(RISING_EDGE(i_Clk)) THEN
            r_IO_Registers(c_SWITCHES_ADDRESS)(3 DOWNTO 0) <= i_Switches;
            
            IF(
                i_Write_Enable = '1' AND 
                i_Enable = '1' AND 
                i_Address /= t_Reg8(TO_UNSIGNED(c_SWITCHES_ADDRESS, c_WORD_SIZE))
            ) THEN
                r_IO_Registers(TO_INTEGER(t_UReg8(i_Address))) <= io_Data;
            END IF;
        END IF;
    END PROCESS p_REGISTERS_READ_WRITE_CONTROL;

    p_DEVICES_CONTROL:
    PROCESS(i_Clk)
    BEGIN
        IF(RISING_EDGE(i_Clk)) THEN
            r_Leds <= r_IO_Registers(c_LEDS_ADDRESS)(3 DOWNTO 0);
        END IF;
    END PROCESS p_DEVICES_CONTROL;
END ARCHITECTURE;
