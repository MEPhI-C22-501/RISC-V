library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity LSUMEM is
	Port (
        
        i_clk, i_rst, i_write_enable_LSU : in std_logic;
        i_addr_LSU : in std_logic_vector (15 downto 0);
        i_write_data_LSU : in std_logic_vector (31 downto 0);

        o_write_enable_memory: out std_logic;
        o_addr_memory: out std_logic_vector (15 downto 0);
        o_write_data_memory: out std_logic_vector (31 downto 0));

end entity;

architecture LSUMEM_arch of LSUMEM is
begin

    process(i_clk, i_rst) is
	begin

                if (i_rst = '1') then

                        o_addr_memory <= std_logic_vector(to_unsigned(0, 16));
                        o_write_data_memory <= std_logic_vector(to_unsigned(0, 32));
                        o_write_enable_memory <= '0';

                elsif (rising_edge(i_clk)) then
                        
                        o_addr_memory <= i_addr_LSU;
                        o_write_data_memory <= i_write_data_LSU;
                        o_write_enable_memory <= i_write_enable_LSU;

                end if;

        end process;

end architecture;