library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port(
        clk, rst : in std_logic;
        state_out : out unsigned(2 downto 0);
        pc : out unsigned(6 downto 0);
        instruction : out unsigned(15 downto 0);
        ula_result : out unsigned(15 downto 0);
        reg1, reg2 : out unsigned(15 downto 0);
        acu_output : out unsigned(15 downto 0)
    );
end entity processador;

architecture a_processador of processador is

    component registerBank is
        port(
            clk: in std_logic; --Clock signal
            WriteData: in unsigned(15 downto 0); --Data to be written in the selected register
            ReadData1: out unsigned(15 downto 0); --Data read from the 1 register
            ReadData2: out unsigned(15 downto 0); --Data read from the 2 register
            WriteReg : in unsigned(2 downto 0); --Selects the register to write
            ReadReg1 : in unsigned(2 downto 0); --Selects the 1 register to read
            ReadReg2 : in unsigned(2 downto 0); --Selects the 2 register to read
            rst : in std_logic; --Resets all registers
            WriteEnable : in std_logic --Enables the write operation
        );
    end component registerBank;

    component ula is
        port(
            x, y : in unsigned(15 downto 0);
            saida : out unsigned(15 downto 0);
            negative, carry, zero : out std_logic;
            op: in unsigned(1 downto 0)
        );
    end component ula;

    component rom is
        port (
            clk : in std_logic;
            addr : in unsigned(6 downto 0);
            data : out unsigned(15 downto 0)
        );
    end component rom;

    component reg16bits is --Instruction register
        port( clk : std_logic;
              rst : std_logic;
              wr_en : std_logic;
              data_in : in unsigned(15 downto 0);
              data_out : out unsigned(15 downto 0)
        );
    end component;

    component controlUnit is
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
            writeReg : out unsigned(2 downto 0)
        );
    end component controlUnit;

    component programCounter is
        port(
            clk : in std_logic;
            rst : in std_logic;
            wr_en : in std_logic;
            data_in_pc : in unsigned(6 downto 0);
            data_out_pc : out unsigned(6 downto 0)
        );
    end component programCounter;

        signal immediate : signed(15 downto 0) := "0000000000000000";
        signal opcode : unsigned(4 downto 0) := "00000";
        --ULA
        signal ula_in1 : unsigned(15 downto 0) := "0000000000000000";
        signal ula_out : unsigned(15 downto 0) := "0000000000000000";
        signal zero : std_logic := '0';
        --instruction register
        signal instruction : unsigned(15 downto 0) := "0000000000000000";
        --ROM
        signal rom_data : unsigned(15 downto 0) := "0000000000000000";
        --Program Counter
        signal pc_out : unsigned(6 downto 0) := "0000000";
        --Control Unit
        signal state : unsigned(2 downto 0) := "000";
        signal op_ula : unsigned(1 downto 0) := "00";
        signal uc_out : unsigned(6 downto 0) := "000000";
        signal jump_en, wr_en : std_logic := '0';
        signal readReg1, readReg2 : unsigned(2 downto 0) := "000";
        signal WriteReg : unsigned(2 downto 0) := "000";
        signal imm_op : std_logic := '0';
        --Acumulador
        signal acu_out : unsigned(15 downto 0) := "0000000000000000";
        signal acu_in : unsigned(15 downto 0) := "0000000000000000";
        --Register Bank
        signal RB_in : unsigned(15 downto 0) := "0000000000000000";
        signal readData1, readData2 : unsigned(15 downto 0) := "0000000000000000";

    begin
        --Ports mapping
        ula : ula port map (ula_in1, acu_out, ula_out, open, open, zero, op_ula);
        registerBank : registerBank port map (clk, RB_in, readData1, readData2, WriteReg, readReg1, open, rst, wr_en);
        rom : rom port map (clk, pc_out, rom_data);
        instruction_register : reg16bits port map (clk, rst, wr_en, rom_data, instruction);
        control_unit : controlUnit port map (clk, rst, zero, instruction, pc_out, immediate, jump_en, uc_out, op_ula, wr_en, readReg1, readReg2, WriteReg, imm_op);
        program_counter : programCounter port map (clk, rst, wr_en, uc_out, pc_out);
        acumulador : reg16bits port map (clk, rst, wr_en, acu_in, acu_out);

        --Outputs
        state_out <= state;
        pc <= pc_out;
        instruction <= instruction;
        ula_result <= ula_result;
        reg1 <= reg1_out;
        reg2 <= reg2_out;
        acu_output <= acu_out;

        --Multiplexers
        acu_in <= readData1 when opcode = "00001" and immediate(1) = '1' else
                  ula_out;

        ula_in1 <= reg1_out when imm_op = '0' else 
                   immediate;

        RB_in <= reg1_out when opcode = "00001" else
                 immediate when opcode = "00010" else
                 acu_out when opcode = "00001" and immediate(0) = '1';


    end architecture;
    