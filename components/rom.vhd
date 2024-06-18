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
        0 => "0100011000100000", --LI R3, 32
        1 => "0100100000000000", --LI R4, 0
        2 => "0100001000000000", --LI R1, 0
        3 => "0001001000000000", --MOV A, R1
        4 => "0110000000000001", --ADDI A, 1
        5 => "0010001000000000", --MOV R1, A
        6 => "1101001001000000", --SW R1, (R1)
        7 => "1110001011000011", --CJNE R1, R3, 3
        8 => "0100001000000001", --LI R1, 1
        9 => "0001001000000000", --MOV A, R1
        10 => "0110000000000001", --ADDI A, 1
        11 => "0010001000000000", --MOV R1, A
        12 => "1100101001000000", --LW R5, (R1)
        13 => "0011000000000000", --LI A, 0
        14 => "0111101000000000", --SUB A, R5
        15 => "1001000011111010", --BEQ -6
        16 => "0001001000000000", --MOV A, R1
        17 => "0010010000000000", --MOV R2, A
        18 => "0001010000000000", --MOV A, R2
        19 => "0101001000000000", --ADD A, R1
        20 => "0010010000000000", --MOV R2, A
        21 => "1101100010000000", --SW R4, (R2)
        22 => "0001011000000000", --MOV A, R3
        23 => "0111010000000000", --SUB A, R2
        24 => "1011000011111010", --BLE -6
        --22 => "1110010011010010", --CJNE R2, R3, 18
        25 => "0001011000000000", --MOV A, R3
        26 => "0111001000000000", --SUB A, R1
        27 => "1011000011101110", --BLE -18
        --23 => "1110001011001001", --CJNE R1, R3, 9
        28 => "0100001000000001", --LI R1, 1
        29 => "0001001000000000", --MOV A, R1
        30 => "0110000000000001", --ADDI A, 1
        31 => "0010001000000000", --MOV R1, A
        32 => "1100101001000000", --LW R5, (R1)
        33 => "0001101000000000", --MOV A, R5
        34 => "1110001011011101", --CJNE R1, R3, 29
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