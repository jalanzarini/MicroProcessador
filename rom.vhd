library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port (
        clk : in std_logic;
        addr : in unsigned(6 downto 0);
        data : out unsigned(11 downto 0)
    );
end entity rom;

architecture a_rom of rom is

    type mem is array (0 to 127) of unsigned(11 downto 0);
    constant conteudo_rom : mem :=(
        0 => "000000000010",
        1 => "100000000000",
        2 => "000000000000",
        3 => "000000000000",
        4 => "100000000000",
        5 => "111100000011",
        6 => "000000000010",
        7 => "000000000000",
        8 => "000000000000",
        9 => "000000000010",
        10 => "000000000010",
        others => (others => '0')
    );

begin
    process(clk)
    begin
        if rising_edge(clk) then
            data <= conteudo_rom(to_integer(addr));
        end if;
    end process;

end a_rom ; -- a_rom