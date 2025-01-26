library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.csr_array_pkg.all;

-- Suffix v_ used to analysis signal between devices in modeling scheme

entity decoder_LSU_tester is
    port (
		-- General ports to decoder and LSU
	 
		i_clk         				: out std_logic;
		i_rst         				: out std_logic;
		
		-- Ports to decoder
		
		i_instr       				: out std_logic_vector(31 downto 0);
		
		-- ports from decoder
		
		o_write_to_LSU 			: in std_logic;
		o_rs1         				: in std_logic_vector(4 downto 0);
		o_rs2         				: in std_logic_vector(4 downto 0);
		o_imm		    				: in std_logic_vector(11 downto 0);
		o_rd          				: in std_logic_vector(4 downto 0);
		o_LSU_code					: in std_logic_vector(16 downto 0);
		o_LSU_code_post 			: in std_logic_vector(16 downto 0);
		o_LSU_reg_or_memory		: in std_logic;
		
		-- ports to LSU
		
		i_write_enable_decoder 	: in std_logic;
      i_opcode_decoder			: in std_logic_vector (16 downto 0); 
		i_opcode_write_decoder 	: in std_logic_vector (16 downto 0);
      i_rs1_decoder				: in std_logic_vector (4 downto 0); 
		i_rs2_decoder				: in std_logic_vector (4 downto 0); 
		i_rd_decoder 				: in std_logic_vector (4 downto 0);
      i_rd_ans 					: in std_logic_vector (31 downto 0);
      i_imm_decoder 				: in std_logic_vector (11 downto 0);
      i_rs_csr 					: in csr_array;
		
		-- Ports from LSU

		o_write_enable_memory 	: in std_logic;
		o_write_enable_csr 		: in std_logic;
		o_rs_csr 					: in csr_array;
		o_opcode_alu 				: in std_logic_vector (16 downto 0);
		o_rs1_alu, o_rs2_alu 	: in std_logic_vector (31 downto 0);
		o_addr_memory				: in std_logic_vector (15 downto 0);
		o_write_data_memory		: in std_logic_vector (31 downto 0);
		o_rd_csr 					: in std_logic_vector (4 downto 0)
		
		);
		
end entity decoder_LSU_tester;

architecture tester of decoder_LSU_tester is
    signal clk : std_logic := '0';
    constant clk_period : time := 10 ns;
begin
    clk_process : process 
	 
    begin
        i_clk <= '0';
        wait for clk_period / 2;
        i_clk <= '1';
        wait for clk_period / 2;
    end process;
	 
    test_process : process
	 
    begin
			wait for 11ns;
	 
			i_rst <= '1';
			wait for 3ns;

			i_rst <= '0';
			i_instr <= "11111111111100101100011100010011";
			
			wait for clk_period;
			
			i_instr <= "00000000101010101010010100110011";
			
			wait for clk_period;
			
			i_instr <= "11111111111101010001110100000011";
			
			wait for clk_period;
			
			i_instr <= "11111110101000101000101010100011";

        wait;
    end process;
end architecture tester;