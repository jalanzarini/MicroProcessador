library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlUnit is
    port(
        clk, is_zero : in std_logic;
        addr : in unsigned(6 downto 0);
        next_addr : out unsigned(6 downto 0);
        instruction : in unsigned(15 downto 0);
        ext_imm : out unsigned(15 downto 0);
        ula_op : out unsigned(1 downto 0);
        RB_src : out std_logic;
        acu_src : out unsigned(1 downto 0);
        wr_reg, read_reg : out unsigned(2 downto 0);
        state_out : out unsigned(1 downto 0)
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
     signal ext_imm : unsigned(15 downto 0);
 
     begin
        uut : stateMachine port map(clk, rst, state);

        opcode <= instruction(15 downto 12);
        imm <= instruction(8 downto 0);
        ext_imm <= "0000000" & imm when opcode = "1010" or imm(8) = '0' else
                    "1111111" & imm when imm(8) = '1';
        
        ula_op <= "00" when opcode = "0101" or opcode = "0110" else --ADD, ADDI
                  "01" when opcode = "0111" or opcode = "1000" or opcode = "1001" else --SUB, CMP, JMP
                  "11";

        RB_src <= '1' when opcode = "0100" else --LI
                  '0'; --MOV
        
        acu_src <= "10" when opcode = "0011" else
                    "01" when opcode = "0001" else
                    "00";

        next_addr <= addr + 1 when state = "00" else
                     addr when state = "01" else
                     imm(6 downto 0) when opcode = "1010" else
                     

        state_out <= state;
end architecture a_controlUnit;