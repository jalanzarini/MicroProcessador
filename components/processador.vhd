library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port(
        clk, rst : in std_logic;
        state : out unsigned(1 downto 0);
        pc : out unsigned(6 downto 0);
        inst : out unsigned(15 downto 0);
        ula_result : out unsigned(15 downto 0);
        reg1 : out unsigned(15 downto 0);
        acu_output : out unsigned(15 downto 0)
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
            clk, rst : in std_logic; --Clock signal
            WriteData : in unsigned(15 downto 0); --Data to be written in the selected register
            ReadData : out unsigned(15 downto 0); --Data read from the 1 register
            WriteReg : in unsigned(2 downto 0); --Selects the register to write
            ReadReg1 : in unsigned(2 downto 0)  --Selects the 1 register to read
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

    

end architecture;
    