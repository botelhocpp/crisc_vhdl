LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.ProcessorPkg.ALL;

ENTITY CRISC IS
PORT (
    i_Clk       : IN STD_LOGIC;
    i_Rst       : IN STD_LOGIC;
    i_Switches  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    o_Leds      : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE Structural OF CRISC IS    
    -- Constants
    CONSTANT c_ROM_CONTENTS : t_MemoryArray := (
        --_start:
        "11000011", -- LI R3, 0

        -- Load user input
        "11000100", -- LI R0, 1
        "10010001", -- LDR R1, R0

        -- Load variable
        "11001000", -- LI R0, 2
        "10010010", -- LDR R2, R0

        -- Is equal?
        "10111001", -- CMP R1, R2
        "11000000", -- LI R0, 0
        "11110001", -- LI R1, 12
        "10001001", -- BEQ R1

        -- _led_off:
        "11000010", -- LI R2, 0
        "10100010", -- STR R2, R0
        "10000111", -- B R3

        -- _led_on:
        "11111110", -- LI R2, F
        "10100010", -- STR R2, R0
        "10000111", -- B R3

        OTHERS => (OTHERS => '0')
    );
    CONSTANT c_RAM_CONTENTS : t_MemoryArray := (
        0 => (OTHERS => '0'),
        1 => (OTHERS => '0'),
        2 => x"0A",
        OTHERS => (OTHERS => '0')
    );
    
    -- Wires
    SIGNAL w_Data_Bus                   : t_Reg8 := (OTHERS => '0');
    SIGNAL w_Data_Address_Bus           : t_Reg8 := (OTHERS => '0');
    SIGNAL w_Instruction_Bus            : t_Reg8 := (OTHERS => '0');
    SIGNAL w_Instruction_Address_Bus    : t_Reg8 := (OTHERS => '0');
    SIGNAL w_Write_Enable               : STD_LOGIC := '0';
    SIGNAL w_Memory_Enable              : STD_LOGIC := '0';
    SIGNAL w_Ram_Memory_Enable          : STD_LOGIC := '0';
    SIGNAL w_Input_Output_Enable        : STD_LOGIC := '0';
BEGIN
    e_PROCESSOR: ENTITY WORK.Processor
    PORT MAP ( 
        i_Instruction           => w_Instruction_Bus, 
        i_Clk                   => i_Clk, 
        i_Rst                   => i_Rst,
        o_Write_Enable          => w_Write_Enable, 
        o_Memory_Enable         => w_Memory_Enable, 
        o_Data_Address          => w_Data_Address_Bus, 
        o_Instruction_Address   => w_Instruction_Address_Bus,
        io_Data                 => w_Data_Bus
    );
    e_ROM_MEMORY: ENTITY WORK.Memory
    GENERIC MAP ( g_CONTENTS => c_ROM_CONTENTS )
    PORT MAP ( 
        i_Address       => w_Instruction_Address_Bus,
        i_Write_Enable  => '0',
        i_Enable        => '1',
        i_Clk           => i_Clk,
        io_Data         => w_Instruction_Bus
    );
    e_RAM_MEMORY: ENTITY WORK.Memory
    GENERIC MAP ( g_CONTENTS => c_RAM_CONTENTS )
    PORT MAP ( 
        i_Address       => w_Data_Address_Bus,
        i_Write_Enable  => w_Write_Enable,
        i_Enable        => w_Ram_Memory_Enable,
        i_Clk           => i_Clk,
        io_Data         => w_Data_Bus
    );
    e_IO_CONTROLLER: ENTITY WORK.InputOutputController
    PORT MAP (
        i_Address       => w_Data_Address_Bus, 
        i_Write_Enable  => w_Write_Enable, 
        i_Enable        => w_Input_Output_Enable, 
        i_Clk           => i_Clk, 
        i_Switches      => i_Switches,
        o_Leds          => o_Leds, 
        io_Data         => w_Data_Bus
    );

    w_Ram_Memory_Enable <= '1' WHEN (
        w_Memory_Enable = '1' AND w_Data_Address_Bus >= x"02"
    ) ELSE '0';
    
    w_Input_Output_Enable <= '1' WHEN (
        w_Memory_Enable = '1' AND w_Data_Address_Bus < x"02"
    ) ELSE '0';
END ARCHITECTURE;