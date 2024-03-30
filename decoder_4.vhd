LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY decoder_4 IS
    PORT (
        sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END decoder_4;

ARCHITECTURE hardware OF decoder_4 IS
    SIGNAL sel_en : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
    sel_en <= en & sel;
    WITH sel_en SELECT
        dout <= "0001" WHEN "100",
                "0010" WHEN "101",
                "0100" WHEN "110",
                "1000" WHEN "111",
                "0000" WHEN OTHERS;
END hardware;
