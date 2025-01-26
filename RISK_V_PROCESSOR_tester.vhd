library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor_tester is
	Port (
			o_clk		: out STD_LOGIC;
			o_rst		: out STD_LOGIC
	);
end entity processor_tester;

architecture tester of processor_tester is

	signal clk : std_logic := '0';
	constant clk_period : time := 10 ns;

	procedure wait_clk(constant j: in integer) is 
		variable ii: integer := 0;
		begin
		while ii < j loop
			if (rising_edge(clk)) then
				ii := ii + 1;
			end if;
			wait for 10 ps;
		end loop;
	end;

	begin

	clk <= not clk after clk_period / 2;
	o_clk <= clk;

	process
	begin
	
		o_rst <= '1';
		wait_clk(2);
		o_rst <= '0';
		wait;
 
	end process;

end architecture tester;

		 