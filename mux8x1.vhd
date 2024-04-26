library ieee;
use ieee.std_logic_1164.all;

entity mux8x1 is
    port(
        i0, i1, i2, i3, i4, i5, i6, i7 : in unsigned(15 downto 0);
        sel : in unsigned(2 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end entity mux8x1;

architecture a_mux8x1 of mux8x1 is
    begin
        data_out <= i0 when sel = "000" else
                    i1 when sel = "001" else
                    i2 when sel = "010" else
                    i3 when sel = "011" else
                    i4 when sel = "100" else
                    i5 when sel = "101" else
                    i6 when sel = "110" else
                    i7;
end architecture a_mux8x1;