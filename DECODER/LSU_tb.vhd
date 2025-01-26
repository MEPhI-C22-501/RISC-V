library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  
use work.csr_array_pkg.all;

entity LSU_tb is
end entity;

architecture LSU_tb_arch of LSU_tb is
		
		-- General signals

		signal clk		 													: std_logic;
		signal rst															: std_logic;

		-- LSU and LSUMEM linkage signals

		signal connection_LSU_LSUMEM_write_enable 				: std_logic;
		signal connection_LSU_LSUMEM_addr_memory 					: std_logic_vector (15 downto 0);
		signal connection_LSU_LSUMEM_write_data_memory 			: std_logic_vector (31 downto 0);
		
		-- LSU and decoder linkage signals

		signal connection_decoder_LSU_rs1 							: std_logic_vector (4 downto 0);
		signal connection_decoder_LSU_rs2 							: std_logic_vector (4 downto 0);
		signal connection_decoder_LSU_imm 							: std_logic_vector (11 downto 0);
		signal connection_decoder_LSU_rd 							: std_logic_vector (4 downto 0);
		signal connection_decoder_LSU_opcode 						: std_logic_vector (16 downto 0);
		signal connection_decoder_LSU_opcode_write 				: std_logic_vector (16 downto 0);
		signal connection_decoder_LSU_write_enable 				: std_logic;
		signal connection_decoder_LSU_rg_or_memory				: std_logic;
		
		-- ???
		
		signal o_rs_csr_tb 												: csr_array; 
		signal i_rs_csr_tb 												: csr_array;
	
		signal rd_csr_tb 													: std_logic_vector (4 downto 0);
		signal write_enable_csr											: std_logic;

		-- Decoder and tester linkage signals
		
		signal instr 														: std_logic_vector (31 downto 0);
		
		-- LSU and tester linkage signals
			
		signal connection_LSU_tester_alu_opcode 					: std_logic_vector (16 downto 0);
		signal connection_LSU_tester_alu_rs1						: std_logic_vector (31 downto 0);
		signal connection_LSU_tester_alu_rs2						: std_logic_vector (31 downto 0);
		signal connection_LSU_tester_rd_ans							: std_logic_vector (31 downto 0);
		
		  -- LSUMEM and tester linkage signals
		  
		signal connection_LSUMEM_tester_enable_memory 			: std_logic;
		signal connection_LSUMEM_tester_addr_memory 				: std_logic_vector (15 downto 0);
		signal connection_LSUMEM_tester_write_data_memory 		: std_logic_vector (31 downto 0);
		
		-- End General signals
	 
    begin
		  
		  command_decoder_v1_tester : entity work.decoder_LSU_tester(tester) port map(
		  
				-- General ports

				i_clk         				=> clk,
				i_rst         				=> rst,

				-- Ports to decoder

				i_instr       				=> instr,

				-- ports from decoder

				o_write_to_LSU 			=> connection_decoder_LSU_write_enable,
				o_rs1         				=> connection_decoder_LSU_rs1,
				o_rs2         				=> connection_decoder_LSU_rs2,
				o_imm		    				=> connection_decoder_LSU_imm,
				o_rd          				=> connection_decoder_LSU_rd,
				o_LSU_code					=> connection_decoder_LSU_opcode,
				o_LSU_code_post 			=> connection_decoder_LSU_opcode_write,
				o_LSU_reg_or_memory		=> connection_decoder_LSU_rg_or_memory,

				-- Ports from LSU

				o_write_enable_memory 	=> connection_LSU_LSUMEM_write_enable,
				o_write_enable_csr 		=> write_enable_csr,
				o_rs_csr 					=> o_rs_csr_tb,
				o_opcode_alu 				=> connection_LSU_tester_alu_opcode,
				o_rs1_alu 					=> connection_LSU_tester_alu_rs1,
				o_rs2_alu 					=> connection_LSU_tester_alu_rs2,
				o_addr_memory				=>	connection_LSU_LSUMEM_addr_memory,
				o_write_data_memory		=> connection_LSU_LSUMEM_write_data_memory,
				o_rd_csr 					=> rd_csr_tb,
				
				-- Ports to LSU
				
				i_write_enable_decoder 	=>	connection_decoder_LSU_write_enable,
				i_opcode_decoder			=> connection_decoder_LSU_opcode,
				i_opcode_write_decoder 	=> connection_decoder_LSU_opcode_write,
				i_rs1_decoder				=> connection_decoder_LSU_rs1,
				i_rs2_decoder				=> connection_decoder_LSU_rs2,
				i_rd_decoder 				=> connection_decoder_LSU_rd,
				i_rd_ans 					=> connection_LSU_tester_rd_ans,
				i_imm_decoder 				=> connection_decoder_LSU_imm,
				i_rs_csr 					=> i_rs_csr_tb

			);
		  

        command_decoder_v1 : entity work.command_decoder_v1(rtl) port map(
            i_clk 						=> clk,
            i_rst 						=> rst,        	
            i_instr 						=> instr,
				
            o_rs1 						=> connection_decoder_LSU_rs1, 
            o_rs2 						=> connection_decoder_LSU_rs2, 
            o_rd 							=> connection_decoder_LSU_rd, 
            o_imm 						=> connection_decoder_LSU_imm, 
            o_write_to_LSU 			=> connection_decoder_LSU_write_enable, 
            o_LSU_code 					=> connection_decoder_LSU_opcode,
            o_LSU_code_post 			=> connection_decoder_LSU_opcode_write
        );

        LSU : entity work.LSU(LSU_arch) port map(

            i_clk 						=> clk,
            i_rst 						=> rst,
            i_write_enable_decoder 	=> connection_decoder_LSU_write_enable, 
            i_opcode_decoder 			=> connection_decoder_LSU_opcode,
            i_opcode_write_decoder 	=> connection_decoder_LSU_opcode_write,
            i_rs1_decoder 				=> connection_decoder_LSU_rs1, 
            i_rs2_decoder 				=> connection_decoder_LSU_rs2, 
            i_rd_decoder 				=> connection_decoder_LSU_rd,
            i_imm_decoder 				=> connection_decoder_LSU_imm, 
				
            i_rd_ans 					=> connection_LSU_tester_rd_ans,
            i_rs_csr 					=> o_rs_csr_tb, --тут надо их крестом соединить с i_rs_csr_tb в тестере
            o_opcode_alu 				=> connection_LSU_tester_alu_opcode,
            o_rs_csr 					=> i_rs_csr_tb, --тут надо их крестом соединить с o_rs_csr_tb в тестере
            o_rs1_alu 					=> connection_LSU_tester_alu_rs1,
            o_rs2_alu 					=> connection_LSU_tester_alu_rs2,
				
            o_write_enable_memory 	=> connection_LSU_LSUMEM_write_enable,
            o_addr_memory 				=> connection_LSU_LSUMEM_addr_memory, 
            o_write_data_memory 		=> connection_LSU_LSUMEM_write_data_memory
				
				-- Добавить сигнал от декодера откуда читать данныеs

        );

        LSUMEM : entity work.LSUMEM(LSUMEM_arch) port map(
            
            i_clk 						=> clk, 
            i_rst 						=> rst,
            i_write_enable_LSU 		=> connection_LSU_LSUMEM_write_enable, 
            i_addr_LSU 					=> connection_LSU_LSUMEM_addr_memory, 
            i_write_data_LSU 			=> connection_LSU_LSUMEM_write_data_memory, 

            o_write_enable_memory 	=> connection_LSUMEM_tester_enable_memory,
            o_addr_memory 				=> connection_LSUMEM_tester_addr_memory,
            o_write_data_memory 		=> connection_LSUMEM_tester_write_data_memory

        );

end architecture;
