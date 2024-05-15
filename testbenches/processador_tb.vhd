library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is end;

architecture arq of tb is
  signal clk, rst: std_logic := '0';
  constant period_time: time := 100 ns;
  signal finished: std_logic := '0';
  signal state_out: unsigned(2 downto 0);
  signal pc: unsigned(6 downto 0);
  signal instruction: unsigned(15 downto 0);
  signal ula_result: unsigned(15 downto 0);
  signal reg1, reg2: unsigned(15 downto 0);
  signal acu_output: unsigned(15 downto 0);

component processador is
    port(
        clk, rst : in std_logic;
        state_out : out unsigned(2 downto 0);
        pc : out unsigned(6 downto 0);
        instruction : out unsigned(15 downto 0);
        ula_result : out unsigned(15 downto 0);
        reg1, reg2 : out unsigned(15 downto 0);
        acu_output : out unsigned(15 downto 0)
    );
end component processador;

begin

    uut: processador
        port map(
            clk => clk,
            rst => rst,
            state_out => state_out,
            pc => pc,
            instruction => instruction,
            ula_result => ula_result,
            reg1 => reg1,
            reg2 => reg2,
            acu_output => acu_output
        );

  sim_time_proc: process
  begin
    wait for 5 us;
    finished <= '1';
    wait;
  end process;

  clk_proc: process
  begin
    while finished /= '1' loop
      clk <= '0';
      wait for period_time/2;
      clk <= '1';
      wait for period_time/2;
    end loop;
    wait;
  end process;

  rst_proc: process
  begin
    rst<='1';
    wait for period_time;
    rst<='0';
    wait;
  end process;
end architecture;