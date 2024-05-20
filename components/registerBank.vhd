library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerBank is
    port(
        clk, rst    : in std_logic;             --Clock / Reset
        WriteData   : in unsigned(15 downto 0); --Data to be written in the selected register
        WriteReg    : in unsigned(2 downto 0);  --Selects the register to write
        ReadReg     : in unsigned(2 downto 0);   --Selects the 1 register to read
        ReadData    : out unsigned(15 downto 0)--Data read from the 1 register
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

    signal wr_en0, wr_en1, wr_en2, wr_en3, wr_en4, wr_en5, wr_en6, wr_en7 : std_logic;
    signal data_out0, data_out1, data_out2, data_out3, data_out4, data_out5, data_out6, data_out7 : unsigned(15 downto 0);

    begin
        reg0 : reg16bits port map (clk => clk, rst => rst, wr_en => wr_en0, data_in => WriteData); -- não tem saida
        reg1 : reg16bits port map (clk => clk, rst => rst, wr_en => wr_en1, data_in => WriteData, data_out => data_out1);
        reg2 : reg16bits port map (clk => clk, rst => rst, wr_en => wr_en2, data_in => WriteData, data_out => data_out2);
        reg3 : reg16bits port map (clk => clk, rst => rst, wr_en => wr_en3, data_in => WriteData, data_out => data_out3);
        reg4 : reg16bits port map (clk => clk, rst => rst, wr_en => wr_en4, data_in => WriteData, data_out => data_out4);
        reg5 : reg16bits port map (clk => clk, rst => rst, wr_en => wr_en5, data_in => WriteData, data_out => data_out5);
        reg6 : reg16bits port map (clk => clk, rst => rst, wr_en => wr_en6, data_in => WriteData, data_out => data_out6);
        reg7 : reg16bits port map (clk => clk, rst => rst, wr_en => wr_en7, data_in => WriteData, data_out => data_out7);

        readData <= data_out1 when ReadReg = "001" else
                    data_out2 when ReadReg = "010" else
                    data_out3 when ReadReg = "011" else
                    data_out4 when ReadReg = "100" else
                    data_out5 when ReadReg = "101" else
                    data_out6 when ReadReg = "110" else
                    data_out7 when ReadReg = "111" else
                    "0000000000000000" when ReadReg = "000" else
                    "0000000000000000";

        wr_en0 <= '0';
        wr_en1 <= '1' when WriteReg = "001" else '0';
        wr_en2 <= '1' when WriteReg = "010" else '0';
        wr_en3 <= '1' when WriteReg = "011" else '0';
        wr_en4 <= '1' when WriteReg = "100" else '0';
        wr_en5 <= '1' when WriteReg = "101" else '0';
        wr_en6 <= '1' when WriteReg = "110" else '0';
        wr_en7 <= '1' when WriteReg = "111" else '0';
    end architecture;