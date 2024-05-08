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
    component controlUnity is
        port(
            data_in_uc : in unsigned(6 downto 0);
            data_out_uc : out unsigned(6 downto 0)
        );
    end component controlUnity;

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
    signal data_out_controlUnity            : unsigned(6 downto 0);
    
    begin
        UC : controlUnity 
            port map(
                data_in_uc => data_out_pc,
                data_out_uc => data_out_controlUnity
            );

        PC : programCounter
            port map(
                clk => clk,
                rst => rst,
                wr_en => wr_en,
                data_in_pc => data_out_controlUnity,
                data_out_pc => data_out_pc
            );

        MEM : rom
            port map(
                clk => clk,
                addr => data_out_pc,
                data => data_out
            );
        
    end a_lab4;