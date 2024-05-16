library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlUnit is
    port(
        clk, rst, zero : in std_logic;
        instruction : in unsigned(15 downto 0);
        addr : in unsigned(6 downto 0);
        immediate : out unsigned(15 downto 0);
        jump_en : out std_logic;
        next_addr : out unsigned(6 downto 0);
        op_ula : out unsigned(1 downto 0);
        write_en : out std_logic;
        readReg1, readReg2 : out unsigned(2 downto 0);
        writeReg : out unsigned(2 downto 0);
        imm_op : out std_logic;
        state_out : out unsigned(1 downto 0)
    );
end entity controlUnit;

architecture a_controlUnit of controlUnit is

    component stateMachine is
        port( clk,rst: in std_logic;
              state: out unsigned(1 downto 0)
        );
     end component;
    
    signal state : unsigned(1 downto 0) := "00";
    signal opcode : unsigned(4 downto 0) := "00000";
    signal imm : unsigned(15 downto 0) := "0000000000000000";
    signal jump_enable : std_logic := '0';

    begin
        uut : StateMachine port map(clk => clk, rst => rst, state => state);

        opcode <= instruction(15 downto 11);
        imm <=  "00000000000" & instruction(4 downto 0) when instruction(4) = '0' and opcode = "00111" else
                "11111111111" & instruction(4 downto 0) when instruction(4) = '1' and opcode = "00111" else 
                "00000000000" & instruction(4 downto 0) when opcode = "01000" else
                (others => '0');
        immediate <= imm;
        imm_op <= '1' when opcode = "00010" or opcode = "00100" or opcode = "00111" or opcode = "01000" else '0';

        jump_enable <= '1' when (opcode = "00111" and zero = '1') or opcode = "01000" else '0';
        jump_en <= jump_enable;

        next_addr <= addr + 1 when state = "01" and jump_enable = '0' else
                       addr when state = "00" and jump_enable = '0' else
                       imm(6 downto 0) when state = "01" and jump_enable = '1' and opcode = "01000" else
                       addr + imm(6 downto 0) when state = "01" and jump_enable = '1' and opcode = "00111" else
                       addr;
        
        state_out <= state;
    process(opcode)
    begin
        case opcode is
            when "00000" =>
                op_ula <= "11";
                write_en <= '0';
                readReg1 <= "000";
                readReg2 <= "000";
                writeReg <= "000";
            when "00001" =>
                op_ula <= "11";
                write_en <= '1';
                readReg1 <= instruction(7 downto 5);
                readReg2 <= "000";
                writeReg <= instruction(10 downto 8);
            when "00010" =>
                op_ula <= "11";
                write_en <= '1';
                readReg1 <= "000";
                readReg2 <= "000";
                writeReg <= instruction(10 downto 8);
            when "00011" =>
                op_ula <= "00";
                write_en <= '1';
                readReg1 <= instruction(7 downto 5);
                readReg2 <= "000";
                writeReg <= "000";
            when "00100" =>
                op_ula <= "11";
                write_en <= '1';
                readReg1 <= "000";
                readReg2 <= "000";
                writeReg <= "000";
            when "00101" =>
                op_ula <= "01";
                write_en <= '1';
                readReg1 <= instruction(7 downto 5);
                readReg2 <= "000";
                writeReg <= "000";
            when "00110" =>
                op_ula <= "01";
                write_en <= '0';
                readReg1 <= instruction(7 downto 5);
                readReg2 <= "000";
                writeReg <= "000";
            when "00111" =>
                op_ula <= "01";
                write_en <= '0';
                readReg1 <= instruction(7 downto 5);
                readReg2 <= "000";
                writeReg <= "000";
            when "01000" =>
                op_ula <= "11";
                write_en <= '0';

            when others =>
                op_ula <= "00";
                write_en <= '0';
                readReg1 <= "000";
                readReg2 <= "000";
                writeReg <= "000";
        end case;
    end process;
end architecture a_controlUnit;