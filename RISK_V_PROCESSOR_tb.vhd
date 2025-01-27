library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity processor_tb is
end entity;

architecture tb of processor_tb is

	signal clk            : STD_LOGIC;
    signal rst            : STD_LOGIC;
	
	component RISC_V_PROCESSOR 
		port (
			i_clk					: in STD_LOGIC;
			i_rst				  	: in STD_LOGIC
		);
	end component;
	
	component processor_tester
		port (
			o_clk					: out STD_LOGIC;
			o_rst					: out STD_LOGIC
		);
	end component;
	
	begin 
		uut : RISC_V_PROCESSOR 
		port map (
			i_clk					=> clk,
			i_rst					=> rst
		);
		
		tester : processor_tester 
		port map (
			o_clk					=> clk,
			o_rst					=> rst
		);
	
end architecture tb;
