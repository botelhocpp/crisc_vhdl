LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux_4 IS
    GENERIC ( N : INTEGER := 8 );
    PORT (
        din_0 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        din_1 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        din_2 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        din_3 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END mux_4;

ARCHITECTURE hardware OF mux_4 IS
    SIGNAL sel_en : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN    
    sel_en <= en & sel;
    WITH sel_en SELECT
        dout <= din_0 WHEN "100",
                din_1 WHEN "101",
                din_2 WHEN "110",
                din_3 WHEN "111",
                (OTHERS => 'Z') WHEN OTHERS;
END hardware;
