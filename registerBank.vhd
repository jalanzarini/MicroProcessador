library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerBank is
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
end entity registerBank;

architecture a_registerBank of registerBank is
    component reg16bits is
        port( clk : std_logic;
              rst : std_logic;
              wr_en : std_logic;
              data_in : in unsigned(15 downto 0);
              data_out : out unsigned(15 downto 0)
        );
    end component;
    
    component mux8x1 is
        port(
            i0, i1, i2, i3, i4, i5, i6, i7 : in unsigned(15 downto 0);
            sel : in unsigned(2 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    component wr_en_demux is
        port (
            sel : in unsigned(2 downto 0);
            data_in: in std_logic;
            out0 : out std_logic;
            out1 : out std_logic;
            out2 : out std_logic;
            out3 : out std_logic;
            out4 : out std_logic;
            out5 : out std_logic;
            out6 : out std_logic;
            out7 : out std_logic
        );
    end component;

    signal wr_en0, wr_en1, wr_en2, wr_en3, wr_en4, wr_en5, wr_en6, wr_en7 : std_logic;
    signal data_out0, data_out1, data_out2, data_out3, data_out4, data_out5, data_out6, data_out7 : unsigned(15 downto 0);

    begin
        reg0 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en0, data_in => WriteData, data_out => data_out0);
        reg1 : reg16bits port map (clk => clk, rst => rst, wr_en => wr_en1, data_in => WriteData, data_out => data_out1);
        reg2 : reg16bits port map (clk => clk, rst => rst, wr_en => wr_en2, data_in => WriteData, data_out => data_out2);
        reg3 : reg16bits port map (clk => clk, rst => rst, wr_en => wr_en3, data_in => WriteData, data_out => data_out3);
        reg4 : reg16bits port map (clk => clk, rst => rst, wr_en => wr_en4, data_in => WriteData, data_out => data_out4);
        reg5 : reg16bits port map (clk => clk, rst => rst, wr_en => wr_en5, data_in => WriteData, data_out => data_out5);
        reg6 : reg16bits port map (clk => clk, rst => rst, wr_en => wr_en6, data_in => WriteData, data_out => data_out6);
        reg7 : reg16bits port map (clk => clk, rst => rst, wr_en => wr_en7, data_in => WriteData, data_out => data_out7);
        demux : wr_en_demux port map(sel => WriteReg, data_in => WriteEnable, out0 => wr_en0, out1 => wr_en1, out2 => wr_en2, out3 => wr_en3, out4 => wr_en4, out5 => wr_en5, out6 => wr_en6, out7 => wr_en7);
        mux1 : mux8x1 port map(i0 => data_out0, i1 => data_out1, i2 => data_out2, i3 => data_out3, i4 => data_out4, i5 => data_out5, i6 => data_out6, i7 => data_out7, sel => ReadReg1, data_out => ReadData1);
        mux2 : mux8x1 port map(i0 => data_out0, i1 => data_out1, i2 => data_out2, i3 => data_out3, i4 => data_out4, i5 => data_out5, i6 => data_out6, i7 => data_out7, sel => ReadReg2, data_out => ReadData2);
    end architecture;