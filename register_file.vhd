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
	i_registers_array : in registers_array;
	i_registers_number : in std_logic_vector(4 downto 0);
	o_registers_array : out registers_array
    );
end RegisterFile;

architecture beh of RegisterFile is
    	signal registers : registers_array := (others => (others => '0'));
	signal program_counter_r : std_logic_vector(15 downto 0) := (others => '0');

begin     

	o_program_counter <= program_counter_r;
	o_registers_array(0) <= (others => '0');
	o_registers_array(31 downto 1) <= registers(31 downto 1);
     
    process (i_clk, i_rst)
	variable register_number : integer := 0;
    begin
	if i_rst = '1' then
		program_counter_r <= (others => '0');
		registers <= (others => (others => '0'));
	elsif rising_edge(i_clk) then
		program_counter_r <= program_counter_r + '1';

		if i_registers_write_enable = '1' then
			register_number := to_integer(unsigned(i_registers_number));
			registers(register_number) <= i_registers_array(register_number);
		elsif i_program_counter_write_enable = '1' then
			program_counter_r <= i_program_counter;
		end if;
	end if;
    end process;

end beh;

