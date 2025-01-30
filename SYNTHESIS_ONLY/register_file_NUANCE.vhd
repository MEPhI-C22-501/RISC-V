library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.register_file_pkg.all;
use ieee.std_logic_unsigned.all;

entity RegisterFile is
    port (
        i_clk        : in     std_logic;
        i_rst                  : in     std_logic;
	i_program_counter_write_enable : in std_logic;
	i_program_counter : in std_logic_vector(15 downto 0);
	o_program_counter   : out std_logic_vector(15 downto 0);
	i_registers_write_enable : in std_logic;
	i_registers_array : in std_logic;
	i_registers_number : in std_logic_vector(4 downto 0);
	o_registers_array : out std_logic
    );
end RegisterFile;

architecture beh of RegisterFile is
    	signal registers : registers_array := (others => (others => '0'));
	signal program_counter_r : std_logic_vector(15 downto 0) := (others => '0');

begin     


end beh;

