library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    port(
        x, y : in unsigned(15 downto 0);        -- Entradas da ULA - A entrada y é o acumulador
        op: in unsigned(1 downto 0);             -- Operação da ULA
        negative, carry, zero : out std_logic;  -- flags 
        saida : out unsigned(15 downto 0)      -- Saída da ULA / Entrada do acumulador
    );
end entity ula;

architecture ula_arch of ula is
    signal result : unsigned(15 downto 0);

    begin
        result <= x + y when op = "00" else
                 y - x when op = "01" else
                 x * y when op = "10" else
                 y when op = "11";

        negative <= result(15);
        zero <= '1' when result = "0000000000000000" and op = "01" else '0';
        carry <= (x(15) and y(15)) or (x(15) and not result(15)) or (y(15) and not result(15)) when op = "00" else 
                 '1' when x > y and op = "01" else
                 '0' when x <= y and op = "01" else
                 '0';
        saida <= result;
      
end architecture ula_arch; 
