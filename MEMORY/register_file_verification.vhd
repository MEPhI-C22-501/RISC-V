library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.csr_mem_pkg.all;


entity csr_verification is
end csr_verification;

architecture csr_verification_arch of csr_verification is
    	component CSR is
	port (
		i_clk        : in     std_logic;
       		i_rst                  : in     std_logic;
		i_program_counter_write_enable : in std_logic;
		i_program_counter : in std_logic_vector(15 downto 0);
		o_program_counter   : out std_logic_vector(15 downto 0);
		i_csr_write_enable : in std_logic;
		i_csr_array : in csr_array;
		i_csr_number : in std_logic_vector(4 downto 0);
		o_csr_array : out csr_array
	);
	end component;

	component LSU is
	Port (
        	i_clk, i_rst, i_write_enable_decoder : in std_logic;
        	i_opcode_decoder, i_opcode_write_decoder : in std_logic_vector (16 downto 0);
        	i_rs1_decoder, i_rs2_decoder, i_rd_decoder : in std_logic_vector (4 downto 0);
        	i_imm_decoder, i_rd_ans : in std_logic_vector (31 downto 0);
        	i_addr_memory_decoder : in std_logic_vector (15 downto 0);
        	i_rs_csr : in csr_array;

        	o_opcode_alu : out std_logic_vector (16 downto 0);
        	o_rs_csr : out csr_array;
        	o_rs1_alu, o_rs2_alu : out std_logic_vector (31 downto 0);
        	o_write_enable_memory : out std_logic;
        	o_addr_memory: out std_logic_vector (15 downto 0);
        	o_write_data_memory: out std_logic_vector (31 downto 0)
	);

    	signal clk_r     	  : std_logic := '0';
   	signal rst_r              : std_logic := '0';
   	signal csr_write_enable_r : std_logic := '0';
	signal csr_number_r       : std_logic_vector(4 downto 0) := "00000";
    	signal program_counter_r  : std_logic_vector(15 downto 0) := (others => '0');
	signal program_counter_res_r  : std_logic_vector(15 downto 0) := (others => '0');
	signal program_counter_write_enable_r  : std_logic := '0';
    	constant clk_period       : time := 10 ns;
	signal csr_array_r        : csr_array := (others => (others => '0'));
	signal csr_array_res_r    : csr_array := (others => (others => '0'));

    	procedure wait_clk(constant j: in integer) is 
        	variable ii: integer := 0;
        	begin
        	while ii < j loop
           		if (rising_edge(clk_r)) then
                		ii := ii + 1;
            		end if;
            		wait for 10 ps;
        	end loop;
    	end;

begin         
	clk_r <= not clk_r after clk_period / 2;
	

	t1: CSR
	port map (
		i_clk => clk_r,
		i_rst => rst_r,
		o_program_counter => program_counter_res_r,
		i_program_counter_write_enable => program_counter_write_enable_r,
		i_program_counter => program_counter_r,
		i_csr_write_enable => csr_write_enable_r,
		i_csr_array => csr_array_r,
		i_csr_number => csr_number_r,
		o_csr_array => csr_array_res_r
	);

	t2: LSU
	port map (
		i_clk => clk_r,
		i_rst => rst_r,
		i_rs_csr => csr_array_res,
		o_rs_csr => csr_array_r,
		
	);


	process
	begin
		rst_r <= '1';
		wait_clk(2);
		wait for 1 ns;
		rst_r <= '0';

		wait_clk(1);
		program_counter_r <= x"AAAA";
		program_counter_write_enable_r <= '1';
		wait_clk(1);
		program_counter_write_enable_r <= '0';
		
		csr_number_r <= "11111";
		csr_array_r(31) <= x"AAAAAAAA";
		csr_write_enable_r <= '1';
		wait_clk(1);
		csr_write_enable_r <= '0';
		wait_clk(1);

		csr_number_r <= "11110";
		csr_array_r(30) <= x"BBBBBBBB";
		csr_write_enable_r <= '1';
		wait_clk(1);
		csr_write_enable_r <= '0';

		csr_number_r <= "11111";
		csr_array_r(31) <= x"CCCCCCCC";
		csr_write_enable_r <= '1';
		wait_clk(1);
		csr_write_enable_r <= '0';

        	wait;
	end process;
end csr_verification_arch;