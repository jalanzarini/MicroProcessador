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
        -- 0 => "0100011000000000", --LI R3, 0
        -- 1 => "0100100000000000", --LI R4, 0
        -- 2 => "0001011000000000", --MOV A, R3
        -- 3 => "0101100000000000", --ADD A, R4
        -- 4 => "0010100000000000", --MOV R4, A
        -- 5 => "0001011000000000", --MOV A, R3
        -- 6 => "0110000000000001", --ADDI A, 1
        -- 7 => "0010011000000000", --MOV R3, A
        -- 8 => "0011000000011110", --LI A, 30
        -- 9 => "0111011000000000", --SUB A, R3
        -- 10 => "1011011011111000", --BLT -8
        -- 11 => "0001100000000000", --MOV A, R4
        -- 12 => "0010101000000000", --MOV R5, A
        -- 13 => "0000000000000000", -- LAB 6
        0 => "0100001000011110", -- LI R3, 0X1E
        1 => "0100010000000111", -- LI R2, 0X07
        2 => "0100011001011010", -- LI R3, 0X5A
        
        3 => "0100100011111111", -- LI R2, 0XFF
        4 => "0100101010101010", -- LI R3, 0XAA
        5 => "0100110000100010", -- LI R2, 0x22
        6 => "0100111001010101", -- LI R3, 0X55
        
        7  => "1101100000000010", -- SW R4, R0        
        8  => "1101101001000010", -- SW R5, R1
        9  => "1101110010000010", -- SW R6, R2
        10 => "1101111011000010", -- SW R7, R3
        
        11 => "1100111000000010", -- LW R7, R0        
        12 => "1100110001000010", -- LW R6, R1
        13 => "1100101010000010", -- LW R5, R2
        14 => "1100100011000010", -- LW R4, R3
        
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