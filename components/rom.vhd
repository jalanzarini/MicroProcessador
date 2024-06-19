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
        12 => "1000011000000000", --CMP A, R3
        13 => "1001000000010001", --BEQ 17
        14 => "1100101001000000", --LW R5, (R1)
        15 => "0011000000000000", --LI A, 0
        16 => "0111101000000000", --SUB A, R5
        17 => "1001000011111000", --BEQ -8
        
        18 => "0001001000000000", --MOV A, R1
        19 => "0010010000000000", --MOV R2, A
        
        20 => "0001010000000000", --MOV A, R2
        21 => "0101001000000000", --ADD A, R1
        22 => "0010010000000000", --MOV R2, A
        23 => "1101100010000000", --SW R4, (R2)
        24 => "0001011000000000", --MOV A, R3
        25 => "0111010000000000", --SUB A, R2
        26 => "1011000011111010", --BLE -6
        
        27 => "0001011000000000", --MOV A, R3
        28 => "0111001000000000", --SUB A, R1
        29 => "1011000011101100", --BLE -20
        
        30 => "0100001000000001", --LI R1, 1
        31 => "0001001000000000", --MOV A, R1
        32 => "0110000000000001", --ADDI A, 1
        33 => "0010001000000000", --MOV R1, A
        34 => "1100101001000000", --LW R5, (R1)
        35 => "0001101000000000", --MOV A, R5 #Leitura
        36 => "1110001011011111", --CJNE R1, R3, 31
        37 => "0000000000000000",
        38 => "1010000000101000", --JMPI 40
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