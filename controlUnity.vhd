library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlUnity is
    port(
        data_in_uc : in unsigned(6 downto 0);
        data_out_uc : out unsigned(6 downto 0)
    );
end entity controlUnity;

architecture a_controlUnity of controlUnity is
    begin
        data_out_uc <= data_in_uc + 1;
end architecture a_controlUnity;