library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_decoder is
end tb_decoder;

architecture sim of tb_decoder is

	signal clk         	: std_logic;
	signal i_rst         	: std_logic;
	signal i_instr       	: std_logic_vector(31 downto 0);
	signal o_r_type      	: std_logic;
	signal o_s_type      	: std_logic;
	signal o_i_type      	: std_logic;
	signal o_opcode      	: std_logic_vector(6 downto 0);
	signal o_rs1         	: std_logic_vector(4 downto 0);
	signal o_rs2         	: std_logic_vector(4 downto 0);
	signal o_imm		    	: std_logic_vector(11 downto 0);
	signal o_rd          	: std_logic_vector(4 downto 0);
	signal o_read_to_LSU 	: std_logic;
	signal o_write_to_LSU 	: std_logic;
	signal o_LSU_code	: std_logic_vector(16 downto 0);
    
 component command_decoder_v1
	  port (
			  i_clk         	: in std_logic;
			  i_rst         	: in std_logic;
			  i_instr       	: in std_logic_vector(31 downto 0);
			  o_r_type      	: out std_logic;
			  o_s_type      	: out std_logic;
			  o_i_type      	: out std_logic;
			  o_opcode      	: out std_logic_vector(6 downto 0);
			  o_rs1         	: out std_logic_vector(4 downto 0);
			  o_rs2         	: out std_logic_vector(4 downto 0);
			  o_imm		    	: out std_logic_vector(11 downto 0);
			  o_rd          	: out std_logic_vector(4 downto 0);
			  o_read_to_LSU 	: out std_logic;
			  o_write_to_LSU 	: out std_logic;
			  o_LSU_code		: out std_logic_vector(16 downto 0)

		);
 end component;

 component instruction_decoder_tester
	  port (
			  i_clk         	: out std_logic;
			  i_rst         	: out std_logic;
			  i_instr       	: out std_logic_vector(31 downto 0);
			  o_r_type      	: in std_logic;
			  o_s_type      	: in std_logic;
			  o_i_type      	: in std_logic;
			  o_opcode      	: in std_logic_vector(6 downto 0);
			  o_rs1         	: in std_logic_vector(4 downto 0);
			  o_rs2         	: in std_logic_vector(4 downto 0);
			  o_imm		    	: in std_logic_vector(11 downto 0);
			  o_rd          	: in std_logic_vector(4 downto 0);
			  o_read_to_LSU 	: in std_logic;
			  o_write_to_LSU 	: in std_logic;
			  o_LSU_code		: in std_logic_vector(16 downto 0)
		);
 end component;

begin
    t1: command_decoder_v1
        port map (
				i_clk 				=> clk,        	
				i_rst         		=> i_rst,
				i_instr       		=> i_instr,
				o_r_type      		=> o_r_type,	
				o_s_type    		=> o_s_type,  	
				o_i_type     		=> o_i_type, 	
				o_opcode 			=> o_opcode,     	
				o_rs1 				=> o_rs1,        	
				o_rs2					=> o_rs2,         	
				o_imm					=> o_imm,   	
				o_rd    				=> o_rd,      	
				o_read_to_LSU 		=> o_read_to_LSU,
				o_write_to_LSU 	=> o_write_to_LSU,
				o_LSU_code			=> o_LSU_code
        );

    -- Вызов тестера
    t2: instruction_decoder_tester
        port map (
            i_clk 				=> clk,        	
				i_rst         		=> i_rst,
				i_instr       		=> i_instr,
				o_r_type      		=> o_r_type,	
				o_s_type    		=> o_s_type,  	
				o_i_type     		=> o_i_type, 	
				o_opcode 			=> o_opcode,     	
				o_rs1 				=> o_rs1,        	
				o_rs2					=> o_rs2,         	
				o_imm					=> o_imm,   	
				o_rd    				=> o_rd,      	
				o_read_to_LSU 		=> o_read_to_LSU,
				o_write_to_LSU 	=> o_write_to_LSU,
				o_LSU_code			=> o_LSU_code
        );
end sim;