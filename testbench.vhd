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
    
    COMPONENT alu IS
    GENERIC ( N : INTEGER := kSIZE );
    PORT (
        op1 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        op2 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        zf : OUT STD_LOGIC;
        res : BUFFER STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    COMPONENT control_unit IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        inst : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  
        alu_op : OUT STD_LOGIC;
        imm_op : OUT STD_LOGIC;
        alu_op_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        dst_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        src_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        imm : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
    END COMPONENT;
    
    COMPONENT rom IS
    PORT (
        clk : IN STD_LOGIC;
        addr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
    END COMPONENT;
    
    COMPONENT ram IS
    PORT (
        clk : IN STD_LOGIC;
        we : IN STD_LOGIC;
        addr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
    END COMPONENT;
    
    -- Control signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    
    -- Inputs
    SIGNAL addr : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    
    -- Outputs
    SIGNAL zf : STD_LOGIC := '0';
    SIGNAL alu_op : STD_LOGIC := '0';
    SIGNAL imm_op : STD_LOGIC := '0';
    SIGNAL imm : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL res : STD_LOGIC_VECTOR(kSIZE - 1 DOWNTO 0) := (OTHERS => '0');
   
    -- Intermediaries
    SIGNAL we : STD_LOGIC := '0';
    SIGNAL inst : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL din : STD_LOGIC_VECTOR(kSIZE - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL alu_op_sel : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL src_sel : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dst_sel : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL src_dout : STD_LOGIC_VECTOR(kSIZE - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dst_dout : STD_LOGIC_VECTOR(kSIZE - 1 DOWNTO 0) := (OTHERS => '0');
    
BEGIN
    DUT_REGS : register_file PORT MAP (clk, rst, we, src_sel, dst_sel, din, src_dout, dst_dout);
    DUT_ALU : alu PORT MAP (dst_dout, src_dout, alu_op_sel, zf, res);
    DUT_CONTROL_UNIT : control_unit PORT MAP (clk, rst, inst, alu_op, imm_op, alu_op_sel, dst_sel, src_sel, imm);
    DUT_ROM : rom PORT MAP (clk, addr, inst);

    clk <= NOT clk AFTER kCLK_PERIOD/2;
       
    we <= imm_op OR alu_op;
    
    PROCESS(imm_op, alu_op, imm, res)
    BEGIN
        IF(imm_op = '1') THEN
            din <= "0000" & imm;
        ELSIF(alu_op = '1') THEN 
            din <= res;
        END IF;
    END PROCESS;
    
    PROCESS
    BEGIN
        -- RESET INPUT VARIABLES
        addr <= "00000000";
        
        -- RESET CONDITION
        rst <= '1';
        WAIT FOR kCLK_PERIOD;
        
        -- WAIT FOR NEXT CYCLE
        rst <= '0';
        WAIT FOR kCLK_PERIOD;
        
        -- LD R1, A
        addr <= "00000001";
        WAIT FOR kCLK_PERIOD;
        
        -- LD R2, 3
        addr <= "00000010";
        WAIT FOR kCLK_PERIOD;
        
        -- ADD R2, R1
        addr <= "00000011";
        WAIT FOR kCLK_PERIOD;
        
        -- LD R0, F
        addr <= "00000100";
        WAIT FOR kCLK_PERIOD;
        
        -- ADD R0, R2
        addr <= "00000101";
        WAIT FOR kCLK_PERIOD;
        
        -- NOP
        addr <= "00000110";
        WAIT FOR 2*kCLK_PERIOD;
    END PROCESS;

END hardware;
