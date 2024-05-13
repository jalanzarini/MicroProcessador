library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlUnit is
    port(
        clk, rst : in std_logic;
        instruction : in unsigned(15 downto 0);
        jump_en : out std_logic;
        data_in_uc : in unsigned(6 downto 0);
        data_out_uc : out unsigned(6 downto 0);
        op_ula : out unsigned(1 downto 0)
    );
end entity controlUnit;

architecture a_controlUnit of controlUnit is

    component stateMachine is
        port( clk,rst: in std_logic;
              state: out unsigned(1 downto 0)
        );
     end component;
    
    signal data_out_sm : unsigned(1 downto 0);
    signal opcode : unsigned(3 downto 0);

    begin
        uut : StateMachine port map(clk => clk, rst => rst, state => data_out_sm);

        opcode <= instruction(15 downto 12);

        jump_en <= '1' when opcode = ("0110" or "1000") else
                   '0';
        
        data_out_uc <= data_in_uc + 1 when data_out_sm = "01" else
                       data_in_uc when data_out_sm = "00" else
                       (others => '0');

end architecture a_controlUnit;