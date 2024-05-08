library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlUnity is
    port(
        clk, rst : in std_logic;
        instruction : in unsigned(15 downto 0);
        jump_en : out std_logic;
        data_in_uc : in unsigned(6 downto 0);
        data_out_uc : out unsigned(6 downto 0)
    );
end entity controlUnity;

architecture a_controlUnity of controlUnity is

    component oneStateMachine is
        port( clk : std_logic;
              rst : std_logic;
              data_out : out std_logic
        );
    end component;

    signal data_out_sm : std_logic;
    signal opcode : unsigned(3 downto 0);

    begin
        uut : oneStateMachine port map(clk => clk, rst => rst, data_out => data_out_sm);

        opcode <= instruction(15 downto 12);

        jump_en <= '1' when opcode = "1111" else
                   '0';
        
        data_out_uc <= data_in_uc + 1 when data_out_sm = '1' else
                       data_in_uc when data_out_sm = '0' else
                       (others => '0');

end architecture a_controlUnity;