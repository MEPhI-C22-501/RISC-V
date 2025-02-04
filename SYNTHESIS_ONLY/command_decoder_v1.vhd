library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity command_decoder_v1 is
	 port(
		  i_clk         				: in std_logic;
		  i_rst         				: in std_logic;
		  i_instr       				: in std_logic_vector(31 downto 0);
		  o_rs1         				: out std_logic_vector(4 downto 0);
		  o_rs2         				: out std_logic_vector(4 downto 0);
		  o_imm		    				: out std_logic_vector(11 downto 0);
		  o_rd          				: out std_logic_vector(4 downto 0);
	--	  -- o_read_to_LSU 				: out std_logic;
		  o_write_to_LSU 				: out std_logic;
		  o_LSU_code					: out std_logic_vector(16 downto 0);
		  o_LSU_code_post				: out std_logic_vector(16 downto 0);
		  o_LSU_reg_or_memory_flag : out std_logic;
		  o_wb_result_src     		: out  STD_LOGIC_VECTOR(1 downto 0)
	 );
end entity;

architecture rtl of command_decoder_v1 is  
  signal reg_stage_LSU_1 : std_logic_vector(22 downto 0) := (others => '0');
  signal reg_stage_LSU_2 : std_logic_vector(22 downto 0) := (others => '0');
  signal reg_stage_LSU_3 : std_logic_vector(22 downto 0) := (others => '0');
  signal reg_stage_LSU_4 : std_logic_vector(22 downto 0) := (others => '0');
  
  signal o_wb_result_src_1 : std_logic_vector(1 downto 0) := (others => '0');
  signal o_wb_result_src_2 : std_logic_vector(1 downto 0) := (others => '0');
  signal o_wb_result_src_3 : std_logic_vector(1 downto 0) := (others => '0');
begin
  process(i_clk, i_rst)
  begin
    if i_rst = '1' then
		reg_stage_LSU_1 <= (others => '0');
		reg_stage_LSU_2 <= (others => '0');
		reg_stage_LSU_3 <= (others => '0');
		reg_stage_LSU_4 <= (others => '0');
		o_wb_result_src_1 <= (others => '0');
		o_wb_result_src_2 <= (others => '0');
		o_wb_result_src_3 <= (others => '0');
		o_rs1 <= (others => '0');
		o_rs2 <= (others => '0');
		o_imm <= (others => '0');
		o_rd <= (others => '0');
	--	-- o_read_to_LSU <= '0';
		o_LSU_code <= (others => '0');
		o_LSU_code_post <= (others => '0');
		o_LSU_reg_or_memory_flag <= '0';
		
    elsif rising_edge(i_clk) then
		
		-- final write information for LSU
		o_write_to_LSU <= reg_stage_LSU_4(22);
		o_rd <= reg_stage_LSU_4(21 downto 17);
		o_LSU_code_post <= reg_stage_LSU_4(16 downto 0);
		o_wb_result_src <= o_wb_result_src_3;
		
		-- shift information for LSU
		reg_stage_LSU_4 <= reg_stage_LSU_3;
		reg_stage_LSU_3 <= reg_stage_LSU_2;
		reg_stage_LSU_2 <= reg_stage_LSU_1;
		
		-- shift information for WriteBack
		
		o_wb_result_src_3 <= o_wb_result_src_2;
		o_wb_result_src_2 <= o_wb_result_src_1;
		
		if not (
			 i_instr(6 downto 0) = "0110011" or
			 i_instr(6 downto 0) = "0000011" or
			 i_instr(6 downto 0) = "0010011" or
			 i_instr(6 downto 0) = "0100011"
		) then
		--	 -- o_read_to_LSU <= '0';
			 reg_stage_LSU_1(22) <= '0';
		end if;
		
		-- R-type
		if (i_instr(6 downto 0) = "0110011") then
	--		 -- o_read_to_LSU <= '1';
		end if;
		
		if (i_instr(6 downto 0) = "0110011") then
			 reg_stage_LSU_1(21 downto 17) <= i_instr(11 downto 7);
		end if;
		
		if (i_instr(6 downto 0) = "0110011") then
			 reg_stage_LSU_1(22) <= '1';
		end if;
		
		if (i_instr(6 downto 0) = "0110011") then
			 o_rs1 <= i_instr(19 downto 15);
		end if;

		if (i_instr(6 downto 0) = "0110011") then
			 o_rs2 <= i_instr(24 downto 20);
		end if;

		if (i_instr(6 downto 0) = "0110011") then
			 o_LSU_code(9 downto 7) <= i_instr(14 downto 12);
			 reg_stage_LSU_1(9 downto 7) <= i_instr(14 downto 12);
		end if;

		if (i_instr(6 downto 0) = "0110011") then
			 o_LSU_code(16 downto 10) <= i_instr(31 downto 25);
			 reg_stage_LSU_1(16 downto 10) <= i_instr(31 downto 25);
		end if;
		
		if (i_instr(6 downto 0) = "0110011") then
			 o_LSU_code(6 downto 0) <= i_instr(6 downto 0);
			 reg_stage_LSU_1(6 downto 0) <= i_instr(6 downto 0);
		end if;
		-- end R-type
		
		
		-- I-type
		if (i_instr(6 downto 0) = "0000011" and i_instr(14 downto 12) = "010") then
			 o_LSU_reg_or_memory_flag <= '1';
		else
			 o_LSU_reg_or_memory_flag <= '0';
		end if;
		
		if (i_instr(6 downto 0) = "0000011" or i_instr(6 downto 0) = "0010011") then
		--	 -- o_read_to_LSU <= '1';
		end if;
		
		if (i_instr(6 downto 0) = "0000011" or i_instr(6 downto 0) = "0010011") then
			 reg_stage_LSU_1(21 downto 17) <= i_instr(11 downto 7);
		end if;
		
		if (i_instr(6 downto 0) = "0000011" or i_instr(6 downto 0) = "0010011") then
			 reg_stage_LSU_1(22) <= '1';
		end if;
		
		if (i_instr(6 downto 0) = "0000011" or i_instr(6 downto 0) = "0010011") then
			 o_rs1 <= i_instr(19 downto 15);
		end if;

		if (i_instr(6 downto 0) = "0000011" or i_instr(6 downto 0) = "0010011") then
			 o_imm <= i_instr(31 downto 20);
		end if;
		
		if (i_instr(6 downto 0) = "0000011" or i_instr(6 downto 0) = "0010011") then
			 o_LSU_code(9 downto 7) <= i_instr(14 downto 12);
			 reg_stage_LSU_1(9 downto 7) <= i_instr(14 downto 12);
		end if;
		
		if (i_instr(6 downto 0) = "0000011" or i_instr(6 downto 0) = "0010011") then
			 o_LSU_code(16 downto 10) <= (others => '0');
			 reg_stage_LSU_1(16 downto 10) <= (others => '0');
		end if;
		
		if (i_instr(6 downto 0) = "0000011" or i_instr(6 downto 0) = "0010011") then
			 o_LSU_code(6 downto 0) <= i_instr(6 downto 0);
			 reg_stage_LSU_1(6 downto 0) <= i_instr(6 downto 0);
		end if;
		-- end I-type
		
		
		-- S-type
		if (i_instr(6 downto 0) = "0100011") then
			 -- o_read_to_LSU <= '1';
		end if;

		if (i_instr(6 downto 0) = "0100011") then
			 reg_stage_LSU_1(22) <= '0';
		end if;
		
		if (i_instr(6 downto 0) = "0100011") then
			 o_rs1 <= i_instr(19 downto 15);
		end if;

		if (i_instr(6 downto 0) = "0100011") then
			 o_rs2 <= i_instr(24 downto 20);
		end if;

		if (i_instr(6 downto 0) = "0100011") then
			 o_imm(4 downto 0) <= i_instr(11 downto 7);
			 o_imm(11 downto 5) <= i_instr(31 downto 25);
		end if;
		
		if (i_instr(6 downto 0) = "0100011") then
			 o_LSU_code(9 downto 7) <= i_instr(14 downto 12);
			 reg_stage_LSU_1(9 downto 7) <= i_instr(14 downto 12);
		end if;
		
		if (i_instr(6 downto 0) = "0100011") then
			 o_LSU_code(16 downto 10) <= (others => '0');
			 reg_stage_LSU_1(16 downto 10) <= (others => '0');
		end if;
		
		if (i_instr(6 downto 0) = "0100011") then
			 o_LSU_code(6 downto 0) <= i_instr(6 downto 0);
			 reg_stage_LSU_1(6 downto 0) <= i_instr(6 downto 0);
		end if;
		
		if(i_instr(6 downto 0) = "0000011") then
			o_wb_result_src_1 <= "01";
		elsif(i_instr(6 downto 0) = "0010011" or i_instr(6 downto 0) = "0110011") then
			o_wb_result_src_1 <= "00";
		else
			o_wb_result_src_1 <= "11";
		end if;
				
	end if;
  end process;
end rtl;