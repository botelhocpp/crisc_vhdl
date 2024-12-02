LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.ProcessorPkg.ALL;

ENTITY Testbench IS
END ENTITY;

ARCHITECTURE Structural OF Testbench IS
    -- Constants
    CONSTANT c_CLOCK_50MHZ_PERIOD : TIME := 20ns;

    -- Input Signals
    SIGNAL i_Clk : STD_LOGIC := '0';
    SIGNAL i_Rst : STD_LOGIC := '0';
    
    -- Wires
    SIGNAL i_Switches   : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL o_Leds       : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
BEGIN
    e_CRISC: ENTITY WORK.CRISC
    PORT MAP (
        i_Clk       => i_Clk,
        i_Rst       => i_Rst,
        i_Switches  => i_Switches,
        o_Leds      => o_Leds
    );
    
    i_Clk <= NOT i_Clk AFTER c_CLOCK_50MHZ_PERIOD/2;
    i_Rst <= '1', '0' AFTER c_CLOCK_50MHZ_PERIOD/4;
    
    i_Switches <= "0000", "1010" AFTER 10*c_CLOCK_50MHZ_PERIOD, "0010" AFTER 20*c_CLOCK_50MHZ_PERIOD;
END ARCHITECTURE;