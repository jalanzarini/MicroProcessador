library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlUnit is
    port(
        clk, rst        : in std_logic;                 -- Clock
        is_zero, carry  : in std_logic;                 -- Zero flag
        addr            : in unsigned(6 downto 0);      -- Endereço atual
        instruction     : in unsigned(15 downto 0);     -- Instrução atual
        RB_src, ula_src_1, ula_src_2 : out std_logic;                -- Controle de entrada do banco de registradores
        writeFlags      : out std_logic;
        ram_wr_en       : out std_logic;                -- Habilita escrita na RAM
        ram_src         : out std_logic;                -- Define a RAM como entrada do banco de registradores
        ula_op          : out unsigned(1 downto 0);     -- Operação da ULA
        acu_src         : out unsigned(1 downto 0);     -- Entrada do acumulador
        state_in        : in unsigned(1 downto 0);     -- Estado atual do state machine
        wr_reg          : out unsigned(2 downto 0);     -- Registrador de escrita
        read_reg1       : out unsigned(2 downto 0);     -- Registrador de leitura
        read_reg2       : out unsigned(2 downto 0);     -- Registrador de leitura
        next_addr       : out unsigned(6 downto 0);     -- Próximo endereço
        ext_imm         : out unsigned(15 downto 0)    -- Immediate extendido 
    );
end entity controlUnit;

architecture a_controlUnit of controlUnit is

     signal opcode : unsigned(3 downto 0);
     signal imm : unsigned(8 downto 0);
     signal relative_addr : unsigned(7 downto 0);
 
     begin
        opcode <= instruction(15 downto 12);

        imm <= "000" & instruction(5 downto 0) when opcode = "1110" else instruction(8 downto 0);

        relative_addr <= ('0' & addr) + imm(7 downto 0);

        ext_imm <= "0000000" & imm when opcode = "1010" or imm(8) = '0' else
                   "1111111" & imm when imm(8) = '1';
        
        ula_op <= "00" when opcode = "0101" or opcode = "0110" else --ADD, ADDI
                  "01" when opcode = "0111" or opcode = "1000" or opcode = "1001" or opcode = "1011" or opcode = "1110" else --SUB, CMP, BEQ, BLT
                  "11";

        RB_src <= '1' when opcode = "0100" else -- Entrada do banco de registradores é um immediate
                  '0'; -- Entrada do banco de registradores é a saida do acumulador
        
        acu_src <=  "10" when opcode = "0011" else -- Entrada do acumulador é um immediate
                    "01" when opcode = "0001" else -- Entrada do acumulador é a saida do banco de registradores
                    "00" when opcode = "0101" or opcode = "0110" or opcode = "0111" else -- Entrada do acumulador é a saida da ULA
                    "11";
        
        ula_src_1 <= '1' when opcode = "0110" else '0'; -- ULA recebe a saida do banco de registradores ou immediate
        ula_src_2 <= '1' when opcode = "1110" else '0'; --Segunda entrada ULA

        next_addr <= imm(6 downto 0) when opcode = "1010" or (opcode = "1110" and is_zero = '0') else        --JMPI
                     relative_addr(6 downto 0) when (opcode = "1011" and carry = '0' and is_zero = '0') or (opcode = "1011" and is_zero = '1') or (opcode = "1001" and is_zero = '1') else --BLT e BEQ
                     addr + 1 when state_in = "11" else -- atualização padrão do pc
                     addr;
        
        wr_reg <= instruction(11 downto 9) when opcode = "0010" or opcode = "0100" or
                                                opcode = "1100" else "000";
        
        read_reg1 <= instruction(11 downto 9) when opcode = "0001" or opcode = "0101" or 
                                                   opcode = "0111" or opcode = "1000" or
                                                   opcode = "1001" or opcode = "1011" or
                                                   opcode = "1101" or opcode = "1110" else "000";
        
        read_reg2 <= instruction(8 downto 6) when opcode = "1100" or opcode = "1101" or opcode = "1110" else -- endereço da ram
                                                  "000";
        
        writeFlags <= '1' when opcode = "0101" or opcode = "0110" or opcode = "0111" or opcode = "1000" or opcode = "1110" else
                        '0';
        ram_wr_en <= '1' when opcode = "1101" else
                     '0';
        ram_src <= '1' when opcode = "1100" else
                   '0';
                    
end architecture a_controlUnit;