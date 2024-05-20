library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlUnit is
    port(
        clk         : in std_logic;                 -- Clock
        is_zero     : in std_logic;                 -- Zero flag
        addr        : in unsigned(6 downto 0);      -- Endereço atual
        instruction : in unsigned(15 downto 0);     -- Instrução atual
        RB_src      : out std_logic;                -- Controle de entrada do banco de registradores
        ula_op      : out unsigned(1 downto 0);     -- Operação da ULA
        acu_src     : out unsigned(1 downto 0);     -- Entrada do acumulador
        state_out   : out unsigned(1 downto 0);     -- Estado atual do state machine
        wr_reg      : out unsigned(2 downto 0);     -- Registrador de escrita
        read_reg    : out unsigned(2 downto 0);     -- Registrador de leitura
        next_addr   : out unsigned(6 downto 0);     -- Próximo endereço
        ext_imm     : out unsigned(15 downto 0);    -- Immediate extendido 
    );
end entity controlUnit;

architecture a_controlUnit of controlUnit is

    component stateMachine is
        port( clk,rst: in std_logic;
              state: out unsigned(1 downto 0)
        );
     end component;

     signal opcode : unsigned(3 downto 0);
     signal imm : unsigned(8 downto 0);
 
     begin
        uut : stateMachine port map(clk, rst, state);

        opcode <= instruction(15 downto 12);

        imm <= instruction(8 downto 0);

        ext_imm <= "0000000" & imm when opcode = "1010" or imm(8) = '0' else
                   "1111111" & imm when imm(8) = '1';
        
        ula_op <= "00" when opcode = "0101" or opcode = "0110" else --ADD, ADDI
                  "01" when opcode = "0111" or opcode = "1000" or opcode = "1001" else --SUB, CMP, JMP
                  "11";

        RB_src <= '1' when opcode = "0100" else -- Entrada do banco de registradores é um immediate
                  '0'; -- Entrada do banco de registradores é a saida do acumulador
        
        acu_src <=  "10" when opcode = "0011" else -- Entrada do acumulador é um immediate
                    "01" when opcode = "0001" else -- Entrada do acumulador é a saida do banco de registradores
                    "00"; -- Entrada do acumulador é a saida da ULA

        next_addr <= addr + 1 when state = "00" else -- atualização padrão do pc
                     addr when state = "01" else
                     imm(6 downto 0) when opcode = "1010" else        --JMPI
                     addr + imm(6 downto 0) when opcode = "1011" else --JMP
                     "0000000";
        
        wr_reg <= instruction(11 downto 9) when opcode = "0010" or opcode = "0100" else
                    "000";
        
        read_reg <= instruction(11 downto 9) when opcode = "0001" or opcode = "0101" or 
                                                  opcode = "0111" or opcode = "1000" or
                                                  opcode = "1001" else
                    "000";
                    
        state_out <= state;
end architecture a_controlUnit;