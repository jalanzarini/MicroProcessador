library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerBank_tb is
end entity registerBank_tb;

architecture a_registerBank_tb of registerBank_tb is
    component registerBank is
        port(
            clk: in std_logic; --Clock signal
            WriteData: in unsigned(15 downto 0); --Data to be written in the selected register
            ReadData1: out unsigned(15 downto 0); --Data read from the 1 register
            ReadData2: out unsigned(15 downto 0); --Data read from the 2 register
            WriteReg : in unsigned(2 downto 0); --Selects the register to write
            ReadReg1 : in unsigned(2 downto 0); --Selects the 1 register to read
            ReadReg2 : in unsigned(2 downto 0); --Selects the 2 register to read
            rst : in std_logic; --Resets all registers
            WriteEnable : in std_logic --Enables the write operation
        );
    end component;

    constant period_time                    : time := 100 ns;
    
    signal finished                         : std_logic := '0';
    signal clk                              : std_logic;
    signal WriteData, ReadData1, ReadData2  : unsigned (15 downto 0);
    signal WriteReg, ReadReg1, ReadReg2     : unsigned (2 downto 0);
    signal rst, WriteEnable                 : std_logic; 

    begin
        reg : registerBank port map (
            clk         => clk,
            WriteData   => WriteData,
            ReadData1   => ReadData1,
            ReadData2   => ReadData2, 
            WriteReg    => WriteReg,
            ReadReg1    => ReadReg1,
            ReadReg2    => ReadReg2,
            rst         => rst,
            WriteEnable => WriteEnable
        );

        reset_global : process
        begin 
            rst <= '0';
            wait for period_time*16;
            rst <= '1';
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

        write_enable_proc : process
        begin   
            WriteEnable <= '0';
            wait for 800 ns;
            WriteEnable <= '1';
            wait;
        end process;

        process
        begin
            wait for 100 ns;
            WriteData <= "1111111111111111"; WriteReg <= "000"; ReadReg1 <= "000"; ReadReg2 <= "000";
            wait for 100 ns;
            WriteData <= "1111111111111111"; WriteReg <= "001"; ReadReg1 <= "001"; ReadReg2 <= "000";
            wait for 100 ns;
            WriteData <= "1111111111111111"; WriteReg <= "010"; ReadReg1 <= "010"; ReadReg2 <= "000";
            wait for 100 ns;
            WriteData <= "1111111111111111"; WriteReg <= "011"; ReadReg1 <= "011"; ReadReg2 <= "000";
            
            wait for 100 ns;
            WriteData <= "1111111111111111"; WriteReg <= "100"; ReadReg1 <= "100"; ReadReg2 <= "110";
            wait for 100 ns;
            WriteData <= "1111111111111111"; WriteReg <= "101"; ReadReg1 <= "101"; ReadReg2 <= "000";
            wait for 100 ns;
            WriteData <= "1111111111111111"; WriteReg <= "110"; ReadReg1 <= "110"; ReadReg2 <= "000";
            wait for 100 ns;
            WriteData <= "1111111111111111"; WriteReg <= "111"; ReadReg1 <= "111"; ReadReg2 <= "000";
            
            wait for 100 ns;
            WriteData <= "1111111111111111"; WriteReg <= "000"; ReadReg1 <= "000"; ReadReg2 <= "000";
            wait for 100 ns;
            WriteData <= "1111111111111111"; WriteReg <= "001"; ReadReg1 <= "001"; ReadReg2 <= "000";
            wait for 100 ns;
            WriteData <= "1111111111111111"; WriteReg <= "010"; ReadReg1 <= "010"; ReadReg2 <= "000";
            wait for 100 ns;
            WriteData <= "1111111111111111"; WriteReg <= "011"; ReadReg1 <= "011"; ReadReg2 <= "000";
            
            wait for 100 ns;
            WriteData <= "1111111111111111"; WriteReg <= "100"; ReadReg1 <= "100"; ReadReg2 <= "110";
            wait for 100 ns;
            WriteData <= "1111111111111111"; WriteReg <= "101"; ReadReg1 <= "101"; ReadReg2 <= "000";
            wait for 100 ns;
            WriteData <= "1111111111111111"; WriteReg <= "110"; ReadReg1 <= "110"; ReadReg2 <= "000";
            wait for 100 ns;
            WriteData <= "1111111111111111"; WriteReg <= "111"; ReadReg1 <= "111"; ReadReg2 <= "000";

            wait for 100 ns;
            WriteData <= "1111101111111111"; WriteReg <= "000"; ReadReg1 <= "000"; ReadReg2 <= "000";
            wait for 100 ns;
            WriteData <= "1111111111110111"; WriteReg <= "001"; ReadReg1 <= "001"; ReadReg2 <= "000";
            wait for 100 ns;
            WriteData <= "1011111111111111"; WriteReg <= "010"; ReadReg1 <= "010"; ReadReg2 <= "000";
            wait for 100 ns;
            WriteData <= "1111111110111111"; WriteReg <= "011"; ReadReg1 <= "011"; ReadReg2 <= "000";
            
            wait for 100 ns;
            WriteData <= "1111111101111111"; WriteReg <= "100"; ReadReg1 <= "100"; ReadReg2 <= "110";
            wait for 100 ns;
            WriteData <= "1111111110111111"; WriteReg <= "101"; ReadReg1 <= "101"; ReadReg2 <= "000";
            wait for 100 ns;
            WriteData <= "1111111101111111"; WriteReg <= "110"; ReadReg1 <= "110"; ReadReg2 <= "000";
            wait for 100 ns;
            WriteData <= "1110111111111111"; WriteReg <= "111"; ReadReg1 <= "111"; ReadReg2 <= "000";
            
            
            wait;
        end process;

    end architecture;