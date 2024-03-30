LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY alu IS
    GENERIC ( N : INTEGER := 8 );
    PORT (
        op1 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        op2 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        zf : OUT STD_LOGIC;
        res : BUFFER STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END alu;

ARCHITECTURE hardware OF alu IS
    CONSTANT zero : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
BEGIN
    WITH sel SELECT
        res <= STD_LOGIC_VECTOR(signed(op1) + signed(op2)) WHEN "001",
               STD_LOGIC_VECTOR(signed(op1) - signed(op2)) WHEN "010",
               STD_LOGIC_VECTOR(signed(op1) and signed(op2)) WHEN "011",
               STD_LOGIC_VECTOR(signed(op1) or signed(op2)) WHEN "100",
               (OTHERS => '0') WHEN OTHERS;
               
    zf <= '1' WHEN (res = zero) ELSE '0';
END hardware;
