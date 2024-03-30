LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY register_file IS
    GENERIC ( N : INTEGER := 8 );
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        we : IN STD_LOGIC;
        src_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        dst_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        din : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        src_dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        dst_dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END register_file;

ARCHITECTURE hardware OF register_file IS
    COMPONENT register_nbit IS
    GENERIC ( N : INTEGER := N );
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        we : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    COMPONENT mux_4 IS
    GENERIC ( N : INTEGER := N );
    PORT (
        din_0 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        din_1 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        din_2 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        din_3 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    COMPONENT decoder_4 IS
    PORT (
        sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
    END COMPONENT;
    
    -- Intermediary Signals
    SIGNAL regs_we : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0'); -- Write enable signals
    SIGNAL dout_r0 : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dout_r1 : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dout_r2 : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dout_r3 : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
    
BEGIN    
    DUT_WRITE_DECODER : decoder_4 PORT MAP (dst_sel, we, regs_we);
    DUT_R0 : register_nbit PORT MAP (clk, rst, regs_we(0), din, dout_r0);
    DUT_R1 : register_nbit PORT MAP (clk, rst, regs_we(1), din, dout_r1);
    DUT_R2 : register_nbit PORT MAP (clk, rst, regs_we(2), din, dout_r2);
    DUT_R3 : register_nbit PORT MAP (clk, rst, regs_we(3), din, dout_r3);
    DUT_SRC_MUX : mux_4 PORT MAP (dout_r0, dout_r1, dout_r2, dout_r3, src_sel, '1', src_dout);
    DUT_DST_MUX : mux_4 PORT MAP (dout_r0, dout_r1, dout_r2, dout_r3, dst_sel, '1', dst_dout);
END hardware;
