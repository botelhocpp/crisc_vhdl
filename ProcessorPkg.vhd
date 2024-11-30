LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY STD;
USE STD.TEXTIO.ALL;

PACKAGE ProcessorPkg IS
    CONSTANT c_MEMORY_SIZE : INTEGER := 256;
    CONSTANT c_WORD_SIZE : INTEGER := 8;
    CONSTANT c_NUMBER_REGISTERS : INTEGER := 4;

    SUBTYPE t_Nibble IS STD_LOGIC_VECTOR(3 DOWNTO 0);
    SUBTYPE t_Reg8 IS STD_LOGIC_VECTOR(c_WORD_SIZE - 1 DOWNTO 0);
    SUBTYPE t_UReg8 IS UNSIGNED(c_WORD_SIZE - 1 DOWNTO 0);
    SUBTYPE t_SReg8 IS SIGNED(c_WORD_SIZE - 1 DOWNTO 0);
    
    TYPE t_MemoryArray IS ARRAY (0 TO c_MEMORY_SIZE - 1) OF t_Reg8;

    TYPE t_Operation IS (
        op_HALT,
        op_MOV,
        op_ADD,
        op_SUB,
        op_AND,
        op_OR,
        op_SHL,
        op_SHR,
        op_NOT,
        op_B,
        op_BEQ,
        op_BNE,
        op_LDR,
        op_STR,
        op_CMP,
        op_LI,
        op_INVALID
    );
    
    PURE FUNCTION f_DecodeInstruction(i_Instruction : t_Reg8) RETURN t_Operation;
    PURE FUNCTION f_HexToBin(i_Hex : CHARACTER) RETURN t_Nibble;
    IMPURE FUNCTION f_InitMemory(i_File_Name : STRING) RETURN t_MemoryArray;
END ProcessorPkg;

PACKAGE BODY ProcessorPkg IS
    PURE FUNCTION f_DecodeInstruction(i_Instruction : t_Reg8) RETURN t_Operation IS
        ALIAS a_OPCODE_FIELD IS i_Instruction(7 DOWNTO 4);
        ALIAS a_ONE_OPERAND_OPERATION_FIELD IS i_Instruction(3 DOWNTO 2);

        VARIABLE v_Operation : t_Operation := op_INVALID;
    BEGIN
        IF(i_Instruction(7 DOWNTO 6) = "11") THEN
            v_Operation := op_LI;
        ELSE
            CASE a_OPCODE_FIELD IS
                WHEN "0000" =>
                    v_Operation := op_HALT;
                WHEN "0001" =>
                    v_Operation := op_MOV;
                WHEN "0010" =>
                    v_Operation := op_ADD;
                WHEN "0011" =>
                    v_Operation := op_SUB;
                WHEN "0100" =>
                    v_Operation := op_AND;
                WHEN "0101" =>
                    v_Operation := op_OR;
                WHEN "0110" =>
                    v_Operation := op_SHL;
                WHEN "0111" =>
                    v_Operation := op_SHR;
                WHEN "1000" =>
                    CASE a_ONE_OPERAND_OPERATION_FIELD IS
                        WHEN "00" =>
                            v_Operation := op_NOT;
                        WHEN "01" =>
                            v_Operation := op_B;
                        WHEN "10" =>
                            v_Operation := op_BEQ;
                        WHEN "11" =>
                            v_Operation := op_BNE;
                        WHEN OTHERS =>
                            v_Operation := op_INVALID;
                    END CASE;
                WHEN "1001" =>
                    v_Operation := op_LDR;
                WHEN "1010" =>
                    v_Operation := op_STR;
                WHEN "1011" =>
                    v_Operation := op_CMP;
                WHEN OTHERS =>
                    v_Operation := op_INVALID;
            END CASE;
        END IF;
        RETURN v_Operation;
    END f_DecodeInstruction;   
    
    PURE FUNCTION f_HexToBin(i_Hex : CHARACTER) RETURN t_Nibble IS
        VARIABLE v_Bin : t_Nibble := (OTHERS => '0');
    BEGIN
        CASE i_Hex IS
            WHEN '0' => v_Bin := "0000";
            WHEN '1' => v_Bin := "0001";
            WHEN '2' => v_Bin := "0010";
            WHEN '3' => v_Bin := "0011";
            WHEN '4' => v_Bin := "0100";
            WHEN '5' => v_Bin := "0101";
            WHEN '6' => v_Bin := "0110";
            WHEN '7' => v_Bin := "0111";
            WHEN '8' => v_Bin := "1000";
            WHEN '9' => v_Bin := "1001";
            WHEN 'A' | 'a' => v_Bin := "1010";
            WHEN 'B' | 'b' => v_Bin := "1011";
            WHEN 'C' | 'c' => v_Bin := "1100";
            WHEN 'D' | 'd' => v_Bin := "1101";
            WHEN 'E' | 'e' => v_Bin := "1110";   
            WHEN 'F' | 'f' => v_Bin := "1111";
            WHEN OTHERS => v_Bin := "0000";     
        END CASE;
        
        RETURN v_Bin;
    END f_HexToBin;
    
    IMPURE FUNCTION f_InitMemory(i_File_Name : STRING) RETURN t_MemoryArray IS
      FILE v_Text_File : TEXT;
      VARIABLE v_Text_Line : LINE;
      VARIABLE v_Contents : t_MemoryArray := (OTHERS => (OTHERS => '0'));
      VARIABLE v_Success : FILE_OPEN_STATUS;
      VARIABLE v_Hex_String : STRING(1 TO 8);
      
      VARIABLE i : INTEGER := 0;
    BEGIN
        FILE_OPEN(v_Success, v_Text_File, i_File_Name, READ_MODE);
        IF (v_Success = OPEN_OK) THEN
          WHILE NOT ENDFILE(v_Text_File) LOOP
            READLINE(v_Text_File, v_Text_Line);
            READ(v_Text_Line, v_Hex_String);
            
            FOR j IN 0 TO 3 LOOP
                 v_Contents(i + 3 - j) := f_HexToBin(v_Hex_String(2*j + 1)) & f_HexToBin(v_Hex_String(2*j + 2));
            END LOOP;
            
            i := i + 4;
          END LOOP;
          
          FOR j IN i TO c_MEMORY_SIZE - 1 LOOP
            v_Contents(j) := (OTHERS => '0');
          END LOOP;
      END IF;
      RETURN v_Contents;
    END FUNCTION;
END ProcessorPkg;
