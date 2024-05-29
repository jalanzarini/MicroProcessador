library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is end;

architecture arq of tb is
  signal clk, rst: std_logic := '0';
  constant period_time: time := 100 ns;
  signal finished: std_logic := '0';
  signal state_out: unsigned(1 downto 0);
  signal pc: unsigned(6 downto 0);
  signal instruction: unsigned(15 downto 0);
  signal ula_result: unsigned(15 downto 0);
  signal reg : unsigned(15 downto 0);
  signal acu_output: unsigned(15 downto 0);

  component processador is
    port(
        clk, rst : in std_logic; --Clock e Reset
        state_out : out unsigned(1 downto 0); --Estado atual da máquina de estados
        pc : out unsigned(6 downto 0); -- Endereço atual do Program Counter
        inst : out unsigned(15 downto 0); -- Instrução atual
        ula_result : out unsigned(15 downto 0); -- Resultado da operação da ULA
        reg : out unsigned(15 downto 0); -- Dado lido do banco de registradores
        acu_output : out unsigned(15 downto 0) -- Saída do acumulador
    );
end component processador;

begin

    uut: processador
        port map(
            clk => clk,
            rst => rst,
            state_out => state_out,
            pc => pc,
            inst => instruction,
            ula_result => ula_result,
            reg => reg,
            acu_output => acu_output
        );

  sim_time_proc: process
  begin
    wait for 100 us;
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