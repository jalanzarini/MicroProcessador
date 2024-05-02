library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2x1 is
    port(
        i0, i1 : in unsigned(15 downto 0);
        sel : in std_logic;
        data_out : out unsigned(15 downto 0)
    );
end entity mux2x1;

architecture a_mux2x1 of mux2x1 is
    begin
        data_out <= i0 when sel <= '0' else
                    i1 when sel <= '1' else
                    "0000000000000000";
end architecture a_mux2x1;