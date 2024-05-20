library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port(
        clk, rst : in std_logic; --Clock e Reset
        state_out : out unsigned(1 downto 0); --Estado atual da máquina de estados
        pc : out unsigned(6 downto 0); -- Endereço atual do Program Counter
        inst : out unsigned(15 downto 0); -- Instrução atual
        ula_result : out unsigned(15 downto 0); -- Resultado da operação da ULA
        reg : out unsigned(15 downto 0); -- Dado lido do banco de registradores
        acu_output : out unsigned(15 downto 0) -- Saída do acumulador
    );
end entity processador;

architecture a_processador of processador is

    component programCounter is
        port(
            clk : in std_logic;
            rst : in std_logic;
            wr_en : in std_logic;
            data_in_pc : in unsigned(6 downto 0);
            data_out_pc : out unsigned(6 downto 0)
        );
    end component programCounter;

    component rom is
        port (
            clk : in std_logic;
            addr : in unsigned(6 downto 0);
            data : out unsigned(15 downto 0)
        );
    end component rom;

    component reg16bits is
        port( clk : std_logic;
              rst : std_logic;
              wr_en : std_logic;
              data_in : in unsigned(15 downto 0);
              data_out : out unsigned(15 downto 0)
        );
    end component;

    component registerBank is
        port(
            clk, rst : in std_logic;                --Clock / Reset
            WriteData : in unsigned(15 downto 0);   --Data to be written in the selected register
            ReadData : out unsigned(15 downto 0);   --Data read from the 1 register
            WriteReg : in unsigned(2 downto 0);     --Selects the register to write
            ReadReg : in unsigned(2 downto 0)       --Selects the 1 register to read
        );
    end component registerBank;

    component ula is
        port(
            x, y : in unsigned(15 downto 0);        -- Entradas da ULA - A entrada y é o acumulador
            op: in unsigned(1 downto 0);             -- Operação da ULA
            negative, carry, zero : out std_logic;  -- flags 
            saida : out unsigned(15 downto 0)      -- Saída da ULA / Entrada do acumulador
        );
    end component ula;

    component controlUnit is 
        port(
            clk, rst         : in std_logic;                 -- Clock
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
            ext_imm     : out unsigned(15 downto 0)    -- Immediate extendido 
        );
    end component controlUnit;

    signal clk_fetch, clk_decode, clk_exec : std_logic := '0';
    
    --Sinais de instrução
    signal addr, next_addr : unsigned(6 downto 0) := (others => '0');
    signal instruction, rom_data : unsigned(15 downto 0) := (others => '0');

    --Sinais de controle
    signal RB_src, is_zero : std_logic := '0';
    signal ula_op, acu_src, state : unsigned(1 downto 0) := (others => '0');
    signal wr_reg, read_reg : unsigned(2 downto 0) := (others => '0');
    signal ext_imm : unsigned(15 downto 0) := (others => '0');

    --Sinais de dados
    signal writeData, readData, acu_in, acu_out, ula_out : unsigned(15 downto 0) := (others => '0');

    begin

        uut_pc : programCounter port map(
            clk => clk,
            rst => rst,
            wr_en => '1',
            data_in_pc => next_addr,
            data_out_pc => addr
        );

        uut_rom : rom port map(
            clk => clk_fetch,
            addr => addr,
            data => rom_data
        );

        uut_ir : reg16bits port map(
            clk => clk_fetch,
            rst => rst,
            wr_en => '1',
            data_in => rom_data,
            data_out => instruction
        );

        control : controlUnit port map(
            clk => clk,
            rst => rst,
            is_zero => is_zero,
            addr => addr,
            instruction => instruction,
            RB_src => RB_src,
            ula_op => ula_op,
            acu_src => acu_src,
            state_out => state,
            wr_reg => wr_reg,
            read_reg => read_reg,
            next_addr => next_addr,
            ext_imm => ext_imm
        );

        uut_RB : registerBank port map(
            clk => clk_exec,
            rst => rst,
            WriteData => writeData,
            ReadData => readData,
            WriteReg => wr_reg,
            ReadReg => read_reg
        );

        uut_ula : ula port map(
            x => readData,
            y => acu_out,
            op => ula_op,
            negative => open,
            carry => open,
            zero => is_zero,
            saida => ula_out
        );

        acumulador : reg16bits port map(
            clk => clk_exec,
            rst => rst,
            wr_en => '1',
            data_in => acu_in,
            data_out => acu_out
        );

        
        clk_fetch <= clk when state = "00" else '0';
        clk_decode <= clk when state = "01" else '0';
        clk_exec <= clk when state = "10" else '0';

        writeData <= acu_out when RB_src = '0' else ext_imm;
        acu_in <= ext_imm when acu_src = "10" else
                  readData when acu_src = "01" else
                  ula_out when acu_src = "00" else
                  acu_out;
            
        ula_result <= ula_out;
        reg <= readData;
        acu_output <= acu_out;
        pc <= addr;
        inst <= instruction;
        state_out <= state;


end architecture;
    