library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stateMachine is
    port( clk,rst: in std_logic;
          state: out unsigned(1 downto 0)
    );
 end entity;

 architecture a_stateMachine of stateMachine is
    signal estado_s: unsigned(1 downto 0) := "00";
 begin
    process(clk,rst)
    begin
       if rst='1' then
          estado_s <= "00";
       elsif rising_edge(clk) then
            if estado_s = "01" then
             estado_s <= "00";
            else
               estado_s <= estado_s + 1;
            end if;
       end if;
    end process;
    state <= estado_s;
 end architecture;