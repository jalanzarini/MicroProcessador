library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab4_tb is
end entity lab4_tb;

architecture a_lab4_tb of lab4_tb is
    component lab4 is
        port(
            clk : in std_logic;
            rst : in std_logic;
            wr_en : in std_logic;
            data_out : out unsigned(15 downto 0)
        );
        end component lab4;

    constant period_time                    : time := 100 ns;
    
    signal finished                         : std_logic := '0';
    signal clk, rst : std_logic;
    signal saida : unsigned(15 downto 0) := "0000000000000000";

begin
    uut : lab4
    port map(
        clk => clk,
        rst => rst,
        wr_en => '1',
        data_out => saida
    );

    reset_global : process
        begin 
            rst <= '1';
            wait for period_time/2;
            rst <= '0';
            wait;
        end process;

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

end architecture a_lab4_tb;