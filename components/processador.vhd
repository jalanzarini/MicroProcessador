library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port(
        clk, rst : in std_logic; --Clock e Reset
        state : out unsigned(1 downto 0); --Estado atual da máquina de estados
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
            op: in unsigned(1 downto 0)             -- Operação da ULA
            negative, carry, zero : out std_logic;  -- flags 
            saida : out unsigned(15 downto 0);      -- Saída da ULA / Entrada do acumulador
        );
    end component ula;

    component controlUnit is 
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
    end component controlUnit;


    

end architecture;
    