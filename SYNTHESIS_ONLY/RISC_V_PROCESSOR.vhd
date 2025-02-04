library ieee;
use ieee.std_logic_1164.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL; 
library work;
use work.register_file_pkg.all;

entity RISC_V_PROCESSOR is
  port (
    i_clk : in std_logic;
    i_rst : in std_logic;
	 
	 i_datamem_src   : in  std_logic;
    o_addr          : out  std_logic_vector(15 downto 0);
    i_outer_data    : in std_logic_vector(31 downto 0);
	 o_outer_data 	  : out  std_logic_vector(31 downto 0);
	 o_outer_write_enable : out  std_logic
	
  );
end entity RISC_V_PROCESSOR;

architecture behavioral of RISC_V_PROCESSOR is

    component command_decoder_v1 
    port ( 
		  i_clk         	: in std_logic;
		  i_rst         	: in std_logic;
		  i_instr       	: in std_logic_vector(31 downto 0);
		  o_rs1         	: out std_logic_vector(4 downto 0);
		  o_rs2         	: out std_logic_vector(4 downto 0);
		  o_imm		    	: out std_logic_vector(11 downto 0);
		  o_rd          	: out std_logic_vector(4 downto 0);
		  o_write_to_LSU 	: out std_logic;
		  o_LSU_code		: out std_logic_vector(16 downto 0);
		  o_LSU_code_post	: out std_logic_vector(16 downto 0);
		  o_LSU_reg_or_memory_flag : out std_logic;
		  o_wb_result_src     : out  STD_LOGIC_VECTOR(1 downto 0)
	 
	 ); 
  end component;
  
    component ALU
    port ( 
         i_first_operand	: in std_logic_vector(31 downto 0);
			i_second_operand 	: in std_logic_vector(31 downto 0);
         i_manage 			: in std_logic_vector(16 downto 0);
         i_clk 				: in std_logic;
         i_rst 				: in std_logic;
		  
         o_result 			: out std_logic_vector(31 downto 0)
	 ); 
  end component;
  
    component LSU
     port (
        i_clk, i_rst, i_write_enable_decoder : in std_logic;
        i_opcode_decoder, i_opcode_write_decoder : in std_logic_vector (16 downto 0);
        i_rs1_decoder, i_rs2_decoder, i_rd_decoder : in std_logic_vector (4 downto 0);
        i_rd_ans : in std_logic_vector (31 downto 0);
        i_imm_decoder : in std_logic_vector (11 downto 0);
        i_rs_csr : in registers_array;
        i_spec_reg_or_memory_decoder : in std_logic; 
        i_program_counter_csr : in std_logic_vector (15 downto 0); 

        o_opcode_alu : out std_logic_vector (16 downto 0);
        o_rs_csr : out registers_array;
        o_rs1_alu, o_rs2_alu : out std_logic_vector (31 downto 0);
        o_write_enable_memory, o_write_enable_csr : out std_logic;
        o_addr_memory: out std_logic_vector (15 downto 0);
        o_write_data_memory: out std_logic_vector (31 downto 0);
        o_rd_csr : out std_logic_vector (4 downto 0);
        o_addr_spec_reg_csr : out std_logic_vector (11 downto 0);  
		  o_program_counter : out std_logic_vector(15 downto 0);
		  o_program_counter_write_enable : out std_logic
	 ); 
  end component;
  
    component LSUMEM 
		port ( 
		  
        i_clk, i_rst, i_write_enable_LSU : in std_logic;
        i_addr_LSU : in std_logic_vector (15 downto 0);
        i_write_data_LSU : in std_logic_vector (31 downto 0);

        o_write_enable_memory: out std_logic;
        o_addr_memory: out std_logic_vector (15 downto 0);
        o_write_data_memory: out std_logic_vector (31 downto 0)
		);
	end component;
		
    component RegisterFile 
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
  end component;
  
    component InstructionMemory
		generic (
			file_path : string := "C:/RISC_V_TESTS/program.hex"
	);

		port (
			i_clk       : in  std_logic;
			i_rst       : in  std_logic;
			i_read_addr : in  std_logic_vector(15 downto 0);
			o_read_data : out std_logic_vector(31 downto 0)
    );
	end component;
  
    component DataMemory
		port (
        i_clk           : in  std_logic;
		  i_rst           : in  std_logic;
        i_write_enable  : in  std_logic;
        i_addr          : in  std_logic_vector(15 downto 0);
        i_write_data    : in  std_logic_vector(31 downto 0);
        o_read_data     : out std_logic_vector(31 downto 0)
			
		);
	end component;
  
	component CSR
		port (
		i_addr		: IN std_logic_vector (11 DOWNTO 0);
		i_clk			: IN std_logic;
		o_data		: OUT std_logic_vector (31 DOWNTO 0)
	);
	end component;
  
	component WriteBack
		port (
		
			i_clk           		: in  STD_LOGIC;
			i_rst           		: in  STD_LOGIC;
        
			i_ALU_result     		: in  STD_LOGIC_VECTOR(31 downto 0); 
			i_datamem_result   	: in  STD_LOGIC_VECTOR(31 downto 0); 
			i_CSR_result 			: in STD_LOGIC_VECTOR (31 downto 0);
		  
			i_result_src       	: in  STD_LOGIC_VECTOR(1 downto 0);  
			o_result        		: out STD_LOGIC_VECTOR(31 downto 0)  
		  
  );
  end component;
  
  signal core_clock 				: std_logic;
  signal core_reset 				: std_logic;
  
  
  signal instruction_command 	: std_logic_vector(31 downto 0);
   
  signal instruction_rs1      : std_logic_vector(4 downto 0);
  signal instruction_rs2      : std_logic_vector(4 downto 0);
  signal instruction_imm      : std_logic_vector(11 downto 0);
  signal instruction_rd     	: std_logic_vector(4 downto 0);
  
  signal decoder_write_to_lsu : std_logic;
  signal lsu_code     			: std_logic_vector(16 downto 0);
  signal lsu_postcode     		: std_logic_vector(16 downto 0);
  
  signal alu_rs1 					: std_logic_vector(31 downto 0);
  signal alu_rs2 					: std_logic_vector(31 downto 0);
  signal alu_opcode				: std_logic_vector (16 downto 0);
  signal alu_result    			: std_logic_vector(31 downto 0);

  signal datamem_WB_input 		: std_logic_vector(31 downto 0);
  signal datamem_result 		: std_logic_vector(31 downto 0);
  signal outer_datamem_result 		: std_logic_vector(31 downto 0);
  signal CSR_result 				: std_logic_vector(31 downto 0);
  signal reg_file_input			: registers_array;
  signal reg_file_output		: registers_array;
  
  signal PC_lsu_to_regfile					: std_logic_vector(15 downto 0);
  signal PC_regfile_to_lsu					: std_logic_vector(15 downto 0);
  signal PC_write_enable		: std_logic;

  signal wb_result_src 			: std_logic_vector(1 downto 0);
  signal wb_result				: std_logic_vector(31 downto 0);
  signal wb_regWrite				: std_logic;
  
  signal read_to_LSU   : std_logic;

  signal csr_write    : std_logic_vector(31 downto 0);  
  
  signal write_enable_lsu_to_lsumem 				: std_logic;
  signal write_enable_lsumem_to_datamem 			: std_logic;
  signal write_enable_datamem_input 				: std_logic;	 
  signal write_enable_lsu_to_regfile 				: std_logic;
  
  signal addr_lsu_to_lsumem	:  std_logic_vector (15 downto 0);
  signal datamem_addr_input 			:  std_logic_vector (15 downto 0);

  signal addr_lsumem_to_datamem	:  std_logic_vector (15 downto 0);
  signal outer_datamem_addr : std_logic_vector (15 downto 0);
  
  signal write_lsu_to_lsumem  :  std_logic_vector (31 downto 0); 
  
  signal write_enable_datamem_to_csr :  std_logic;
  signal regfile_number : std_logic_vector(4 downto 0);
  
  signal addr_lsu_to_memory 	: std_logic_vector (15 downto 0);
  signal data_lsu_to_memory	: std_logic_vector (31 downto 0);
  signal datamem_input 			: std_logic_vector (31 downto 0);
  
  signal src_decoder_to_lsu 	: std_logic;
  signal addr_lsu_to_CSR		: std_logic_vector(11 downto 0);
  signal datamem_src:  std_logic := '1';
begin
	


  decoder_inst : command_decoder_v1  port map ( 
	i_clk           => core_clock,--
	i_rst           => core_reset,--
	i_instr         => instruction_command, --
	o_rs1           => instruction_rs1, --
	o_rs2           => instruction_rs2, --
	o_imm           => instruction_imm, --
	o_rd            => instruction_rd, --

	o_write_to_LSU  => decoder_write_to_lsu, --
	o_LSU_code      => lsu_code, --
	o_LSU_code_post => lsu_postcode,
	o_LSU_reg_or_memory_flag => src_decoder_to_lsu, --
	o_wb_result_src => wb_result_src--
  );

  alu_inst : ALU port map (
    i_clk            => core_clock, --
    i_rst            => core_reset, --
	 i_first_operand  => alu_rs1, --
    i_second_operand => alu_rs2, --
    i_manage         => alu_opcode, --
    o_result         => alu_result --
  );

  lsu_inst : LSU port map (
      
	 i_clk 				=> core_clock, -- 
	 i_rst 				=> core_reset, --
	 i_write_enable_decoder  => decoder_write_to_lsu, --
    i_opcode_decoder => lsu_code, --
	 i_opcode_write_decoder => lsu_postcode, --
    i_rs1_decoder => instruction_rs1, -- 
	 i_rs2_decoder => instruction_rs2, --
	 i_rd_decoder => instruction_rd, --
    i_rd_ans => wb_result, -- 
    i_imm_decoder => instruction_imm, --
    i_rs_csr => reg_file_output, --
	 i_spec_reg_or_memory_decoder => src_decoder_to_lsu,--
    i_program_counter_csr => PC_regfile_to_lsu, --


    o_opcode_alu => alu_opcode, --
    o_rs_csr => reg_file_input, --
    o_rs1_alu => alu_rs1, --
	 o_rs2_alu => alu_rs2, --
    o_write_enable_memory => write_enable_lsu_to_lsumem, --
	 o_write_enable_csr => write_enable_lsu_to_regfile,
    o_addr_memory => addr_lsu_to_lsumem,--, 
    o_write_data_memory => write_lsu_to_lsumem, --
    o_rd_csr => regfile_number, --
	 o_addr_spec_reg_csr => addr_lsu_to_CSR,--
	 o_program_counter => PC_lsu_to_regfile, --
	 o_program_counter_write_enable 	=> PC_write_enable
	 
  );			
  
  lsumem_inst : LSUMEM port map (
    i_clk => core_clock, --
	 i_rst => core_reset, --
	 i_write_enable_LSU => write_enable_lsu_to_lsumem, --
    i_addr_LSU => addr_lsu_to_lsumem, --
    i_write_data_LSU => write_lsu_to_lsumem,  --

    o_write_enable_memory => write_enable_lsumem_to_datamem, --
    o_addr_memory => addr_lsumem_to_datamem,   --
    o_write_data_memory => data_lsu_to_memory --
	 
  );

	CSR_inst : CSR port map (		
		i_addr => addr_lsu_to_CSR,	 --
		i_clk	 => core_clock, --
		o_data => CSR_result	--
	);
  
  regfile_inst : RegisterFile port map (
    i_clk                    			=> core_clock,--
    i_rst                    			=> core_reset,--
    i_program_counter_write_enable 	=> PC_write_enable, --
    i_program_counter        			=> PC_lsu_to_regfile,    --
    i_registers_array             	=> reg_file_input,--
	 i_registers_number 					=> regfile_number,--
	 i_registers_write_enable			=> write_enable_lsu_to_regfile,--
    o_program_counter        			=> PC_regfile_to_lsu,   --
    o_registers_array              	=> reg_file_output--
	 
  );
  
  
  datamem_inst : DataMemory port map (
	 i_clk        			=> core_clock, --
    i_rst        			=> core_reset, --
    i_write_enable 		=> write_enable_lsumem_to_datamem, --write_enable_datamem_input, --
    i_addr 					=> datamem_addr_input, --
    i_write_data 			=> datamem_input,-- 
	  
    o_read_data 			=> datamem_result --
  );
  
  instrmem_inst : InstructionMemory port map (
	 i_clk => core_clock, --
	 i_rst => core_reset, --
	 i_read_addr => PC_regfile_to_lsu, --
	 o_read_data =>	instruction_command --
  );

  wb_inst : WriteBack port map (
    i_clk          => core_clock, --
    i_rst          => core_reset, --
    
	 i_datamem_result    => datamem_WB_input,  --
	 i_CSR_result			=> CSR_result, --
    i_ALU_result    => alu_result, --
    i_result_src    => wb_result_src,  --   
	 
    o_result       => wb_result --
  );
  
  	core_clock <= i_clk;
	core_reset <= i_rst;
	
--	datamem_src <= i_datamem_src; 
--	o_addr <=  wb_result; --datamem_result;--addr_lsumem_to_datamem;
	datamem_addr_input <= addr_lsumem_to_datamem;
	o_outer_write_enable <= write_enable_lsumem_to_datamem;
	
--	write_enable_datamem_input <= write_enable_lsumem_to_datamem; 
	datamem_input <= data_lsu_to_memory;
	o_outer_data <= data_lsu_to_memory;
	
	datamem_src <= i_datamem_src;

	process (i_clk, i_rst, datamem_src, i_outer_data, datamem_result, wb_result)
	begin
	   if i_rst = '1' then  
        o_addr <= (others => '0');
   elsif(rising_edge(i_clk)) then 
			if (datamem_src = '0') then -- внутри
				datamem_WB_input <= datamem_result;
				o_addr <= (others => '0');
			else  
				datamem_WB_input <= i_outer_data;   -- снаружи
				o_addr <=  addr_lsumem_to_datamem;
			end if;
		end if;
	end process;
	
end architecture behavioral;
