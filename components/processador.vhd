library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port(
        clk, rst, write_enable, const_enable : in std_logic;
        WriteReg, ReadReg1, ReadReg2     : in unsigned (2 downto 0);
        operation : in unsigned (1 downto 0);
        const :  in unsigned (15 downto 0);
        ula_debug : out unsigned (15 downto 0);

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
    end component;

    component ula is
        port(
            x, y: in unsigned(15 downto 0);
            saida : out unsigned(15 downto 0);
            op: in unsigned(1 downto 0)
        );
    end component;

    component mux2x1 is
        port(
            i0, i1 : in unsigned(15 downto 0);
            sel : in std_logic;
            data_out : out unsigned(15 downto 0)
        );
    end component;

    
    signal WriteData, ReadData1, ReadData2  : unsigned (15 downto 0);
   
    signal data_out                         : unsigned (15 downto 0);
    signal ula_debug                        : unsigned (15 downto 0);

    begin
        reg : registerBank port map (
            clk         => clk,
            WriteData   => WriteData,
            ReadData1   => ReadData1,
            ReadData2   => ReadData2, 
            WriteReg    => WriteReg,
            ReadReg1    => ReadReg1,
            ReadReg2    => ReadReg2,
            rst         => rst,
            WriteEnable => WriteEnable
        );

        ula_p : ula port map (
            x           => ReadData1,
            y           => data_out,
            saida       => WriteData,
            op          => operation
        );

        mux_ula : mux2x1 port map (
            i0          => ReadData2,
            i1          => const,
            sel         => const_enable,
            data_out    => data_out
        );

        ula_debug <= WriteData;

    end architecture;
    