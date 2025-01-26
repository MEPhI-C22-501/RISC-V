library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DataMemory is
    port (
        i_clk           : in  std_logic;
	i_rst           : in  std_logic;
        i_write_enable  : in  std_logic;
        i_addr          : in  std_logic_vector(15 downto 0);
        i_write_data    : in  std_logic_vector(31 downto 0);
        o_read_data     : out std_logic_vector(31 downto 0)
    );
end DataMemory;

architecture DataMemory_beh of DataMemory is
    type memory_array is array (0 to 65535) of std_logic_vector(31 downto 0);

    signal memory : memory_array := (others => (others => '0'));
    signal data_r : std_logic_vector(31 downto 0);
    
    attribute ramstyle : string;
    attribute ramstyle of memory : signal is "M9K";

begin
    o_read_data <= data_r;
	 
	 
    process(i_clk, i_rst)
    begin
	if i_rst = '1' then
		data_r <= (others => '0');
	elsif rising_edge(i_clk) then
            if i_write_enable = '0' then
                data_r <= memory(to_integer(unsigned(i_addr)));
            end if;
        end if;
    end process;

    process(i_clk, i_rst)
    begin
	if rising_edge(i_clk) then
            if i_write_enable = '1' then
                memory(to_integer(unsigned(i_addr))) <= i_write_data;
            end if;
        end if;
    end process;

end DataMemory_beh;
