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
        0 => "0100011000000000", --LI R3, 0
        1 => "0100100000000000", --LI R4, 0
        2 => "0001011000000000", --MOV A, R3
        3 => "0101100000000000", --ADD A, R4
        4 => "0010100000000000", --MOV R4, A
        5 => "0001011000000000", --MOV A, R3
        6 => "0110000000000001", --ADDI A, 1
        7 => "0010011000000000", --MOV R3, A
        8 => "0011000000011110", --LI A, 30
        9 => "0111011000000000", --SUB A, R3
        10 => "1011011011111000", --BLT -8
        11 => "0001100000000000", --MOV A, R4
        12 => "0010101000000000", --MOV R5, A
        13 => "0000000000000000",
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