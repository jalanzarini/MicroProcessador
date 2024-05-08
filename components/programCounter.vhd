library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity programCounter is
    port(
        clk : in std_logic;
        rst : in std_logic;
        wr_en : in std_logic;
        data_in_pc : in unsigned(6 downto 0);
        data_out_pc : out unsigned(6 downto 0)
    );
end entity programCounter;

architecture a_programCounter of programCounter is
    signal registro : unsigned(6 downto 0);
begin
    process(clk,rst,wr_en)
    begin
        if rst = '1' then
            registro <= "0000000";
        elsif wr_en = '1' then
            if rising_edge(clk) then
                registro <= data_in_pc;
            end if;
        end if;
    end process;
    data_out_pc <= registro;
end architecture a_programCounter;