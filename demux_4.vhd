LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY demux_4 IS
    GENERIC ( N : INTEGER := 8 );
    PORT (
        din : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        en : IN STD_LOGIC;
        dout_0 : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        dout_1 : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        dout_2 : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        dout_3 : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END demux_4;

ARCHITECTURE hardware OF demux_4 IS
BEGIN
    dout_0 <= din WHEN en = '1' AND sel = "00" ELSE (OTHERS => 'Z');
    dout_1 <= din WHEN en = '1' AND sel = "01" ELSE (OTHERS => 'Z');
    dout_2 <= din WHEN en = '1' AND sel = "10" ELSE (OTHERS => 'Z');
    dout_3 <= din WHEN en = '1' AND sel = "11" ELSE (OTHERS => 'Z'); 
END hardware;
