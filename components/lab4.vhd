library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab4 is
    port(
        clk : in std_logic;
        rst : in std_logic;
        wr_en : in std_logic;
        data_out : out unsigned(15 downto 0)
    );
    end entity lab4;

architecture a_lab4 of lab4 is
    component controlUnit is
        port(
            jump_en : out std_logic;
            instruction : in unsigned(15 downto 0);
            data_in_uc : in unsigned(6 downto 0);
            data_out_uc : out unsigned(6 downto 0);
            clk, rst : in std_logic
        );
    end component controlUnit;

    component programCounter is
        port(
            clk : in std_logic;
            rst : in std_logic;
            wr_en : in std_logic;
            data_in_pc : in unsigned(6 downto 0);
            data_out_pc : out unsigned(6 downto 0)
        );
    end component programCounter;
    
    component rom is
        port (
            clk : in std_logic;
            addr : in unsigned(6 downto 0);
            data : out unsigned(15 downto 0)
        );
    end component rom;

    signal data_out_pc                      : unsigned(6 downto 0);
    signal data_out_controlUnit             : unsigned(6 downto 0);
    signal jump_en                          : std_logic;
    signal instruction                      : unsigned(15 downto 0);
    signal UC_or_instruction                : unsigned(6 downto 0);

    begin
        UC : controlUnit 
            port map(
                instruction => instruction,
                jump_en => jump_en,
                data_in_uc => data_out_pc,
                data_out_uc => data_out_controlUnit,
                clk => clk,
                rst => rst
            );

        PC : programCounter
            port map(
                clk => clk,
                rst => rst,
                wr_en => wr_en,
                data_in_pc => UC_or_instruction,
                data_out_pc => data_out_pc
            );

        MEM : rom
            port map(
                clk => clk,
                addr => data_out_pc,
                data => instruction
            );

        UC_or_instruction <= ("000" & instruction(11 downto 8)) when jump_en = '1' else data_out_controlUnit;
        data_out <= instruction;
    end a_lab4;