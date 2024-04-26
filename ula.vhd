library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    port(
        x, y: in unsigned(15 downto 0);
        saida : out unsigned(15 downto 0);
        selec: in unsigned(1 downto 0)
    );
end entity ula;

architecture ula_arch of ula is
    begin
        saida <= x + y when selec = "00" else
                 x - y when selec = "01" else
                 x or y when selec = "10" else
                 x and y when selec = "11" else
                 "0000000000000000";
end architecture ula_arch;