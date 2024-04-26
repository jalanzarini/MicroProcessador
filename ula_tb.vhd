library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end entity ula_tb;

architecture a_ula_tb of ula_tb is
    component ula is
        port(
            x, y: in unsigned(15 downto 0);
            saida : out unsigned(15 downto 0);
            selec: in unsigned(1 downto 0)
        );
    end component;
    
    signal x, y, saida: unsigned(15 downto 0);
    signal selec : unsigned(1 downto 0);

begin
    uut: ula port map(
        x => x,
        y => y,
        saida => saida,
        selec => selec
    );
    process
    begin
        x <= "0000100001000001";
        y <= "0000101000100001";
        selec <= "00";
        wait for 10 ns;
        
        x <= "0000001000100010";
        y <= "0000000001010010";
        selec <= "01";
        wait for 10 ns;
        
        x <= "0000000010010011";
        y <= "0000000000001011";
        selec <= "10";
        wait for 10 ns;
        
        x <= "1001000010010100";
        y <= "0001010000110100";
        selec <= "11";
        wait for 10 ns;
        
        wait;
    end process;

    end architecture a_ula_tb;