LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE hardware OF testbench IS
    CONSTANT kSIZE : INTEGER := 8;
    CONSTANT kCLK_FREQ : INTEGER := 50e6;
    CONSTANT kCLK_PERIOD : TIME := 5000ms / kCLK_FREQ;
    
    COMPONENT register_file IS
    GENERIC ( N : INTEGER := kSIZE );
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
    END COMPONENT;
    
    -- Control signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    
    -- Inputs
    SIGNAL we : STD_LOGIC := '0';
    SIGNAL src_sel : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dst_sel : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL din : STD_LOGIC_VECTOR(kSIZE - 1 DOWNTO 0) := (OTHERS => '0');
    
    -- Outputs
    SIGNAL src_dout : STD_LOGIC_VECTOR(kSIZE - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dst_dout : STD_LOGIC_VECTOR(kSIZE - 1 DOWNTO 0) := (OTHERS => '0');

BEGIN
    DUT_R0 : register_file PORT MAP (clk, rst, we, src_sel, dst_sel, din, src_dout, dst_dout);
    
    clk <= NOT clk AFTER kCLK_PERIOD/2;
    
    PROCESS
    BEGIN
        -- RESET INPUT VARIABLES
        src_sel <= "00";
        dst_sel <= "00";
        we <= '0';
        din <= (OTHERS => '0');
        
        -- RESET CONDITION
        rst <= '1';
        WAIT FOR kCLK_PERIOD;
        
        -- WAIT ONE MORE CYCLE
        rst <= '0';
        WAIT FOR kCLK_PERIOD;
        
        -- LOAD R0
        din <= "00010000"; -- (1 => '4', OTHERS => '0')
        dst_sel <= "00";
        WAIT FOR kCLK_PERIOD;
        
        we <= '1';
        WAIT FOR kCLK_PERIOD;
        
        -- LOAD R1
        we <= '0';
        din <= "00110000";
        dst_sel <= "01";
        WAIT FOR kCLK_PERIOD;
        
        we <= '1';
        WAIT FOR kCLK_PERIOD;
        
        -- LOAD R2
        we <= '0';
        din <= "01110000";
        dst_sel <= "10";
        WAIT FOR kCLK_PERIOD;
        
        we <= '1';
        WAIT FOR kCLK_PERIOD;
        
        -- LOAD R3
        we <= '0';
        din <= "11110000";
        dst_sel <= "11";
        WAIT FOR kCLK_PERIOD;
        
        we <= '1';
        WAIT FOR kCLK_PERIOD;
    END PROCESS;

END hardware;
