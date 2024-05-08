library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end entity rom_tb;

architecture a_rom_tb of rom_tb is
    component rom is
        port(
            clk : in std_logic;
            addr : in unsigned(6 downto 0);
            data : out unsigned(15 downto 0)
        );
    end component rom;

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal clk : std_logic;
    signal data : unsigned(15 downto 0);
    signal addr : unsigned(6 downto 0);

    begin
        uut : rom port map(
            data => data,
            clk => clk,
            addr => addr
        );

        sim_time_proc : process
        begin
            wait for 10 us;
            finished <= '1';
            wait;
        end process sim_time_proc;

        clk_proc : process
        begin
            while finished /= '1' loop
                clk <= '0';
                wait for period_time/2;
                clk <= '1';
                wait for period_time/2;
            end loop;
            wait;
        end process clk_proc;

        process
        begin
            addr <= "0000000";
            wait for 100 ns;
            addr <= "0000001";
            wait for 100 ns;
            addr <= "0000010";
            wait for 100 ns;
            addr <= "0000011";
            wait for 100 ns;
            addr <= "0000100";
            wait for 100 ns;
            addr <= "0000101";
            wait for 100 ns;
            addr <= "0000110";
            wait for 100 ns;
            addr <= "0000111";
            wait for 100 ns;
            addr <= "0001000";
            wait for 100 ns;
            addr <= "0001001";
            wait for 100 ns;
            addr <= "0001010";
            wait for 100 ns;
            addr <= "0001011";
            wait for 100 ns;
            addr <= "0001100";
            wait for 100 ns;
            addr <= "0001101";
            wait for 100 ns;
            addr <= "0001110";
            wait for 100 ns;
            addr <= "0001111";
            wait;
        end process;
    end architecture a_rom_tb;