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
        0 => "0001001100000101", --LI R3, 5
        1 => "0001010000001000", --LI R4, 8
        2 => "0000100001100010", --MOV A, R3
        3 => "0001100010000000", --ADD A, R4
        4 => "0000110100000001", --MOV R5, A
        5 => "0001000100000001", --LI R1,1
        6 => "0010100000100000", --SUB A,R1
        7 => "0000110100000001", --MOV R5, A
        8 => "0100000000010100", --JMPI 20
        9 => "0010000000000000", --ADDI A, 0
        10 => "0000110100000001", --MOV R5, A
        11 => "0000000000000000",
        12 => "0000000000000000",
        13 => "0000000000000000",
        14 => "0000000000000000",
        15 => "0000000000000000",
        16 => "0000000000000000",
        17 => "0000000000000000",
        18 => "0000000000000000",
        19 => "0000000000000000",
        20 => "0000101100000001", --MOV R3, A
        21 => "0100000000000011", --JMPI 3
        22 => "0010000000000000", --ADDI A, 0
        23 => "0000101100000001", --MOV R3, A
        24 => "0000000000000000",
        25 => "0000000000000000",
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