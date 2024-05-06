library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity oneStateMachine is
    port( clk : std_logic;
          rst : std_logic;
          data_out : out std_logic
    );
end entity;

architecture a_oneStateMachine of oneStateMachine is
    signal estado : std_logic;
begin
    process(clk,rst)
    begin
        if rising_edge(rst) then
            estado <= '0';
        elsif rising_edge(clk) then
            estado <= not estado;
        end if;
    end process;
    data_out <= estado;
end architecture;