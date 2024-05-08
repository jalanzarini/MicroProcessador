library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port (
        clk : in std_logic;
        addr : in unsigned(6 downto 0);
        data : out unsigned(15 downto 0)
    );
end entity rom;

architecture a_rom of rom is

    type mem is array (0 to 127) of unsigned(15 downto 0);
    constant conteudo_rom : mem :=(
        0 => "0000000000000010",    --opcode 15-12, dst 11-8
        1 => "1000000000000000",
        2 => "1111010100000000",    --jump to 5
        3 => "0000000000000000",
        4 => "1000000000000000",
        5 => "0000000000000011",
        6 => "0000000000000010",
        7 => "0000000000000000",
        8 => "1111011000000000",    --jump to 6
        9 => "0000000000000010",
        10 => "0000000000000010",
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