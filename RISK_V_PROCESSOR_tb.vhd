library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity processor_tb is
end entity;

architecture tb of processor_tb is

	signal clk            : STD_LOGIC := '0';
    signal rst            : STD_LOGIC := '1';
	
	component processor 
		port (
			i_clk		: in STD_LOGIC;
			i_rst		: in STD_LOGIC
		);
	end component;
	
	component processor_tester
		port (
			o_clk		: out STD_LOGIC;
			o_rst		: out STD_LOGIC
		);
	end component;
	
	begin 
		uut : processor
		port map (
			i_clk	=> clk,
			i_rst	=> rst
		);
		
		tester : processor_tester
		port map (
			o_clk	=> clk,
			o_rst	=> rst
		);
	
end architecture tb;