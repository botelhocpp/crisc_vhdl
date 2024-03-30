LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY register_nbit IS
    GENERIC ( N : INTEGER := 8 );
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        we : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END register_nbit;

ARCHITECTURE hardware OF register_nbit IS
BEGIN    
    PROCESS(rst, clk)
    BEGIN
        IF(rst = '1') THEN
            dout <= (OTHERS => '0');
        ELSIF(rising_edge(clk) AND we = '1') THEN
            dout <= din;
        END IF;
    END PROCESS;
END hardware;
