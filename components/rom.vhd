library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port (
        clk : in std_logic; -- Clock
        addr : in unsigned(6 downto 0); -- Endereço de leitura
        data : out unsigned(15 downto 0) -- Instrução lida
    );
end entity rom;

architecture a_rom of rom is
    signal iniciado : boolean := false;

    type mem is array (0 to 127) of unsigned(15 downto 0);
    constant conteudo_rom : mem :=(
        0 => "0000000000000000", --NOP
        1 => "0100011000000101", --LI R3, 5
        2 => "0100100000001000", --LI R4, 8
        3 => "0001011000000000", --MOV A, R3
        4 => "0101100000000000", --ADD A, R4
        5 => "0010101000000000", --MOV R5, A
        6 => "0100001000000001", --LI R1,1
        7 => "0111001000000000", --SUB A,R1
        8 => "0010101000000000", --MOV R5, A
        9 => "1010000000010100", --JMPI 20
        10 => "0110000000000000", --ADDI A, 0
        11 => "0010101000000000", --MOV R5, A
        12 => "0000000000000000",
        13 => "0000000000000000",
        14 => "0000000000000000",
        15 => "0000000000000000",
        16 => "0000000000000000",
        17 => "0000000000000000",
        18 => "0000000000000000",
        19 => "0000000000000000",
        20 => "0010011000000000", --MOV R3, A
        21 => "1010000000000011", --JMPI 3
        22 => "0110000000000000", --ADDI A, 0
        23 => "0010011000000000", --MOV R3, A
        24 => "0000000000000000",
        25 => "0000000000000000",
        others => (others => '0')
    );

begin
    process(clk)
    begin
        if not iniciado then
            data <= conteudo_rom(0);
            iniciado <= true;
        elsif rising_edge(clk) then
            data <= conteudo_rom(to_integer(addr));
        end if;
    end process;

end a_rom ; -- a_rom