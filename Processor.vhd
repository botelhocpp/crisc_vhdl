LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.ProcessorPkg.ALL;

ENTITY Processor IS
PORT ( 
    i_Instruction         : IN t_Reg8;
    i_Clk                 : IN STD_LOGIC;
    i_Rst                 : IN STD_LOGIC;
    o_Write_Enable        : OUT STD_LOGIC;
    o_Memory_Enable       : OUT STD_LOGIC;
    o_Data_Address        : OUT t_Reg8;
    o_Instruction_Address : OUT t_Reg8;
    io_Data               : INOUT t_Reg8
);
END ENTITY;

ARCHITECTURE Structural OF Processor IS
    SIGNAL w_Branch                 : STD_LOGIC := '0';
    SIGNAL w_Branch_Equal           : STD_LOGIC := '0';
    SIGNAL w_Branch_Not_Equal       : STD_LOGIC := '0';
    SIGNAL w_Operation              : t_Operation := op_INVALID;
    SIGNAL w_Load_Flags             : STD_LOGIC := '0';
    SIGNAL w_Input_Select           : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL w_Register_Write_Enable  : STD_LOGIC := '0';
    SIGNAL w_Memory_Write_Enable    : STD_LOGIC := '0';
    SIGNAL w_Data_Out               : t_Reg8 := (OTHERS => '0');
BEGIN
    e_DATAPATH: ENTITY WORK.Datapath
    PORT MAP (
        i_Data_In               => io_Data,
        i_Instruction           => i_Instruction,
        i_Clk                   => i_Clk,
        i_Rst                   => i_Rst,
        i_Branch                => w_Branch,
        i_Branch_Equal          => w_Branch_Equal,
        i_Branch_Not_Equal      => w_Branch_Not_Equal,
        i_Operation             => w_Operation,
        i_Load_Flags            => w_Load_Flags,
        i_Input_Select          => w_Input_Select,
        i_Write_Enable          => w_Register_Write_Enable,
        o_Data_Address          => o_Data_Address, 
        o_Instruction_Address   => o_Instruction_Address,
        o_Data_Out              => w_Data_Out
    );
    e_CONTROL_UNIT: ENTITY WORK.ControlUnit
    PORT MAP (
        i_Instruction           => i_Instruction,
        o_Memory_Write_Enable   => w_Memory_Write_Enable, 
        o_Memory_Enable         => o_Memory_Enable, 
        o_Branch                => w_Branch,            
        o_Branch_Equal          => w_Branch_Equal, 
        o_Branch_Not_Equal      => w_Branch_Not_Equal, 
        o_Operation             => w_Operation,
        o_Load_Flags            => w_Load_Flags, 
        o_Input_Select          => w_Input_Select,
        o_Register_Write_Enable => w_Register_Write_Enable
    );
    
    o_Write_Enable <= w_Memory_Write_Enable;
    io_Data <= w_Data_Out WHEN (w_Memory_Write_Enable = '1') ELSE (OTHERS => 'Z');

END ARCHITECTURE;
