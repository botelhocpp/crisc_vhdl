LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY control_unit IS
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
END control_unit;

ARCHITECTURE hardware OF control_unit IS
    COMPONENT register_nbit IS
    GENERIC ( N : INTEGER := 8 );
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        we : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    SIGNAL dout_ir : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
BEGIN
    DUT_IR : register_nbit PORT MAP (clk, rst, '1', inst, dout_ir);
    
    PROCESS(dout_ir)
    BEGIN
        -- IMM: 11XXXXDD
        IF(dout_ir(7 DOWNTO 6) = "11") THEN
            imm_op <= '1';
            alu_op <= '0';
            alu_op_sel <= "000";
            imm <= dout_ir(5 DOWNTO 2);
            dst_sel <= dout_ir(1 DOWNTO 0);
        
        -- NOP/HALT
        ELSIF(dout_ir = "00000000") THEN
            alu_op <= '0';
            imm_op <= '0';
            alu_op_sel <= "000";
            dst_sel <= "00";
            src_sel <= "00";
            imm <= "0000";
            
        -- ALU: 0XXXSSDD
        ELSIF(dout_ir(7) = '0') THEN
            alu_op <= '1';
            imm_op <= '0';
            alu_op_sel <= dout_ir(6 DOWNTO 4);
            src_sel <= dout_ir(3 DOWNTO 2);
            dst_sel <= dout_ir(1 DOWNTO 0);
        
        ELSE
            alu_op <= '0';
            imm_op <= '0';
            alu_op_sel <= "000";
            dst_sel <= "00";
            src_sel <= "00";
            imm <= "0000";
            
        END IF;
    END PROCESS;
END hardware;
