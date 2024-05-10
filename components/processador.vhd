library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity microProcessor is
end entity microProcessor;

architecture a_microProcessor of microProcessor is
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

    component ula is
        port(
            x, y: in unsigned(15 downto 0);
            saida : out unsigned(15 downto 0);
            op: in unsigned(1 downto 0)
        );
    end component;

    component mux2x1 is
        port(
            i0, i1 : in unsigned(15 downto 0);
            sel : in std_logic;
            data_out : out unsigned(15 downto 0)
        );
    end component;

    constant period_time                    : time := 100 ns;
    
    signal finished                         : std_logic := '0';
    signal clk                              : std_logic;
    signal WriteData, ReadData1, ReadData2  : unsigned (15 downto 0);
    signal WriteReg, ReadReg1, ReadReg2     : unsigned (2 downto 0);
    signal rst, WriteEnable                 : std_logic; 
   
    signal operation                        : unsigned (1 downto 0);
    signal data_out                         : unsigned (15 downto 0);
    signal const                            : unsigned (15 downto 0);
    signal const_enable                     : std_logic;
    signal ula_debug                        : unsigned (15 downto 0);

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

        ula_p : ula port map (
            x           => ReadData1,
            y           => data_out,
            saida       => WriteData,
            op          => operation
        );

        mux_ula : mux2x1 port map (
            i0          => ReadData2,
            i1          => const,
            sel         => const_enable,
            data_out    => data_out
        );

        ula_debug <= WriteData;

        reset_global : process
        begin 
            rst <= '1';
            rst <= '0';
            -- wait for period_time*16;
            -- rst <= '1';
            
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
            WriteEnable <= '1';
            wait for period_time*8;
            WriteEnable <= '0';
            wait;
        end process;

        process
        begin
            --inicializa o circuito (o reset ta na proprio processo)
            ReadReg1  <= "000"; ReadReg2 <= "000";
            const     <= "0000000000000000"; 
            const_enable <= '1';
            operation <= "00";
            WriteReg <= "000";
            
            -- O registrador 0 tem valor padrão e não precisa ser inicalizado 
            wait for period_time;
            const <= "0000000000000001"; WriteReg <= "001"; 
            wait for period_time;
            const <= "0000000000000010"; WriteReg <= "010"; 
            wait for period_time;
            const <= "0000000000000011"; WriteReg <= "011";
            
            wait for period_time;
            const <= "0000000000000100"; WriteReg <= "100"; 
            wait for period_time;
            const <= "0000000000000101"; WriteReg <= "101"; 
            wait for period_time;
            const <= "0000000000000110"; WriteReg <= "110"; 
            wait for period_time;
            const <= "0000000000000111"; WriteReg <= "111"; 
            
            wait for period_time;
            const_enable <= '0';
            ReadReg1  <= "000"; ReadReg2 <= "001"; WriteReg <= "001";
            wait for period_time;
            ReadReg1  <= "010"; ReadReg2 <= "011"; WriteReg <= "001";
            wait for period_time;
            ReadReg1  <= "100"; ReadReg2 <= "101"; WriteReg <= "001";
            wait for period_time;
            ReadReg1  <= "110"; ReadReg2 <= "111"; WriteReg <= "001";
            wait for period_time;
            const_enable <= '1'; 

            wait;
        end process;




    end architecture;
    