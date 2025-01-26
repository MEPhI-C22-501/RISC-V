library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.inst_mem_pkg.all;
use work.csr_mem_pkg.all;


entity inst_mem_verification is
end inst_mem_verification;

architecture inst_mem_verification_arch of inst_mem_verification is
    	component InstructionMemory
        port (
            i_clk       : in  std_logic;
	    i_rst       : in  std_logic;
            i_read_addr : in  std_logic_vector(15 downto 0);
            o_read_data : out std_logic_vector(31 downto 0)
        );
    	end component;

    	component CSR is
	port (
		i_clk              : in  std_logic;
        	i_rst              : in  std_logic;
		o_program_counter  : out std_logic_vector(15 downto 0);
		i_csr_write_enable : in  std_logic;
		i_csr_array        : in  csr_array;
		i_csr_number       : in  std_logic_vector(4 downto 0);
		o_csr_array        : out csr_array
	);
	end component;

	component command_decoder_v1 is
	port(
  		i_clk         	: in  std_logic;
  		i_rst         	: in  std_logic;
  		i_instr       	: in  std_logic_vector(31 downto 0);
  		o_r_type      	: out std_logic;
  		o_s_type      	: out std_logic;
  		o_i_type      	: out std_logic;
  		o_rs1         	: out std_logic_vector(4 downto 0);
  		o_rs2         	: out std_logic_vector(4 downto 0);
  		o_imm		: out std_logic_vector(11 downto 0);
  		o_rd          	: out std_logic_vector(4 downto 0);
  		o_read_to_LSU 	: out std_logic;
  		o_write_to_LSU 	: out std_logic;
  		o_LSU_code	: out std_logic_vector(16 downto 0)
 	);
	end component;

    	signal clk_s     	  : std_logic := '0';
   	signal rst_s              : std_logic := '0';
   	signal csr_write_enable_s : std_logic := '0';
    	signal program_counter_s        : std_logic_vector(15 downto 0) := (others => '0');
    	signal read_instruction_s        : std_logic_vector(31 downto 0);



    	constant clk_period : time := 10 ns;

    	procedure wait_clk(constant j: in integer) is 
        	variable ii: integer := 0;
        	begin
        	while ii < j loop
           		if (rising_edge(clk_s)) then
                		ii := ii + 1;
            		end if;
            		wait for 10 ps;
        	end loop;
    	end;


begin         
	
	clk_s <= not clk_s after clk_period / 2;
	

	t1: InstructionMemory
	generic map (
		file_path => "program.hex"
	)
        port map (
	    i_rst       => rst_s,
            i_clk       => clk_s,
            i_read_addr => program_counter_s,
            o_read_data => read_instruction_s
        );


	t2: CSR
	port map (
		i_clk => clk_s,
		i_rst => rst_s,
		o_program_counter => program_counter_s,
		i_csr_write_enable => csr_write_enable_s,
		i_csr_array => (others => (others => '0')),
		i_csr_number => "00000"
	);

	t3: command_decoder_v1
	port map (
		i_clk => clk_s,
		i_rst => rst_s,
		i_instr => read_instruction_s
	);


	process
	begin
		rst_s <= '1';
		wait_clk(2);
		rst_s <= '0';
		wait;
	end process;
end inst_mem_verification_arch;