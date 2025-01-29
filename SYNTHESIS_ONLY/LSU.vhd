library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  
use work.register_file_pkg.all;

entity LSU is
	Port (
        
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

end entity;

architecture LSU_arch of LSU is

        signal o_opcode_alu_r : std_logic_vector (16 downto 0);
        signal o_rs1_alu_r : std_logic_vector (31 downto 0);
        signal o_rs2_alu_r : std_logic_vector (31 downto 0);
        signal o_write_enable_memory_r : std_logic;
        signal o_write_enable_csr_r : std_logic;
        signal o_addr_memory_r: std_logic_vector (15 downto 0);
        signal o_write_data_memory_r: std_logic_vector (31 downto 0);
        signal o_rd_csr_r : std_logic_vector (4 downto 0);
        signal o_addr_spec_reg_csr_r : std_logic_vector (11 downto 0);
	signal o_program_counter_r : std_logic_vector(15 downto 0);
	signal o_program_counter_write_enable_r : std_logic;

begin

        o_opcode_alu <= o_opcode_alu_r;
        o_rs1_alu <= o_rs1_alu_r;
        o_rs2_alu <= o_rs2_alu_r;
        o_write_enable_memory <= o_write_enable_memory_r;
        o_write_enable_csr <= o_write_enable_csr_r;
        o_addr_memory <= o_addr_memory_r;
        o_write_data_memory <= o_write_data_memory_r;
        o_rd_csr <= o_rd_csr_r;
        o_addr_spec_reg_csr <= o_addr_spec_reg_csr_r;
        o_program_counter <= o_program_counter_r;
        o_program_counter_write_enable <= o_program_counter_write_enable_r;

        process(i_clk, i_rst) is
 	begin

                if (i_rst = '1') then

                        o_opcode_alu_r <= (others => '0');
                        o_rs1_alu_r <= (others => '0');
                        o_rs2_alu_r <= (others => '0');
                        o_write_enable_memory_r <= '0';
                        o_write_enable_csr_r <= '0';
                        o_addr_memory_r <= (others => '0');
                        o_write_data_memory_r <= (others => '0');
                        o_rd_csr_r <= (others => '0');
                        o_addr_spec_reg_csr_r <= (others => '0');
                        o_program_counter_r <= (others => '0');
                        o_program_counter_write_enable_r <= '0';
                        o_rs_csr <= (others => (others => '0'));

                elsif (rising_edge(i_clk)) then

                        --передача разрегения на запись csr
                        o_write_enable_csr_r <= i_write_enable_decoder;
                        
                        --передача кода операции в ALU
                        o_opcode_alu_r <= i_opcode_decoder;

                        --передача rs2 в ALU
                        if(i_opcode_decoder = "00000000010010011" or
                           i_opcode_decoder = "00000001010010011" or
                           i_opcode_decoder = "01000001010010011" or
                           i_opcode_decoder = "00000000000010011" or
                           i_opcode_decoder = "00000001000010011" or
                           i_opcode_decoder = "00000001100010011" or
                           i_opcode_decoder = "00000001110010011" or
                           i_opcode_decoder = "00000000100010011" or
                           i_opcode_decoder = "00000000110010011") then

                                o_rs2_alu_r <= std_logic_vector(to_unsigned(0, 32));
                                o_rs2_alu_r(11 downto 0) <= i_imm_decoder(11 downto 0);
                        
                         elsif (i_opcode_decoder = "00000000010110011" or 
                                 i_opcode_decoder = "00000001010110011" or 
                                 i_opcode_decoder = "01000001010110011" or 
                                 i_opcode_decoder = "00000000000110011" or 
                                 i_opcode_decoder = "00000001000110011" or 
                                 i_opcode_decoder = "00000001100110011" or 
                                 i_opcode_decoder = "00000001110110011" or 
                                 i_opcode_decoder = "00000000100110011" or 
                                 i_opcode_decoder = "00000000110110011") then
                                        
                                        for i in 0 to 31 loop 
                                        
                                                if (i_rs2_decoder = std_logic_vector(to_unsigned(i, 5))) then
                                        
                                                        o_rs2_alu_r <= i_rs_csr(i);
                                        
                                                end if;

                                        end loop;

                        end if;

                        --связь с LSUMEM разрешение на запись
                        if ((i_opcode_decoder = "00000000000100011" or 
                              i_opcode_decoder = "00000000010100011" or 
                              i_opcode_decoder = "00000000100100011")) then -- Store
                                
                                o_write_enable_memory_r <= '1';

                        else          

                                o_write_enable_memory_r <= '0';

                        end if;

                        --Передача номера регистра в CSR для записи
                        if (i_write_enable_decoder = '1') then 
                                    
                                o_rd_csr_r <= i_rd_decoder;
                            
                        elsif (i_write_enable_decoder = '0') then
                            
                                o_rd_csr_r <= (others => '0');
                            
                        end if;

                        --реализация 32 регистров
                        for i in 0 to 31 loop

                                --Запись в регистр
                                if (i_write_enable_decoder = '1' and 
                                    i_opcode_write_decoder = "00000000000000011" and 
                                    i_rd_decoder = std_logic_vector(to_unsigned(i, 5))) then --Load LB
                                                
                                        --7 младших битов, все остальное знаковым битом (32)
                                        o_rs_csr(i)(7 downto 0) <= i_rd_ans(7 downto 0);
                                        o_rs_csr(i)(31 downto 8) <= (others => i_rd_ans(31));
                                        
                                elsif (i_write_enable_decoder = '1' and 
                                       i_opcode_write_decoder = "00000000010000011" and 
                                       i_rd_decoder = std_logic_vector(to_unsigned(i, 5))) then --Load LH
                                                
                                        --15 младших битов, все остальное знаковым битом (32)
                                        o_rs_csr(i)(14 downto 0) <= i_rd_ans(14 downto 0);
                                        o_rs_csr(i)(31 downto 15) <= (others => i_rd_ans(31));
                                        
                                elsif (i_write_enable_decoder = '1' and 
                                       i_opcode_write_decoder = "00000000100000011" and 
                                       i_rd_decoder = std_logic_vector(to_unsigned(i, 5))) then --Load LW  
                                        
                                        o_rs_csr(i) <= i_rd_ans;
                                        
                                elsif (i_write_enable_decoder = '1' and 
                                       i_opcode_write_decoder = "00000001000000011" and 
                                       i_rd_decoder = std_logic_vector(to_unsigned(i, 5))) then --Load LBU 
                                        
                                        o_rs_csr(i) <= i_rd_ans;
                                        
                                elsif (i_write_enable_decoder = '1' and 
                                       i_opcode_write_decoder = "00000001010000011" and 
                                       i_rd_decoder = std_logic_vector(to_unsigned(i, 5))) then --Load LHU 
                                                
                                        o_rs_csr(i) <= i_rd_ans;
                                        
                                elsif (i_write_enable_decoder = '1' and 
                                       i_rd_decoder = std_logic_vector(to_unsigned(i, 5))) then --Save answer
                                                
                                        o_rs_csr(i) <= i_rd_ans;
                                        
                                end if;

                                --связь с LSUMEM data
                                if (i_opcode_decoder = "00000000000100011" and 
                                    i_rs2_decoder = std_logic_vector(to_unsigned(i, 5))) then -- Store SB
                                                
                                        --7 младших битов, все остальное знаковым битом (32)
                                        o_write_data_memory_r(7 downto 0) <= i_rs_csr(i)(7 downto 0);
                                        o_write_data_memory_r(31 downto 8) <= (others => i_rs_csr(i)(31));
                                        
                                elsif (i_opcode_decoder = "00000000010100011" and 
                                       i_rs2_decoder = std_logic_vector(to_unsigned(i, 5))) then -- Store SH
                                                
                                        --15 младших битов, все остальное знаковым битом (32)
                                        o_write_data_memory_r(14 downto 0) <= i_rs_csr(i)(14 downto 0);
                                        o_write_data_memory_r(31 downto 15) <= (others => i_rs_csr(i)(31));
                                        
                                elsif (i_opcode_decoder = "00000000100100011" and 
                                       i_rs2_decoder = std_logic_vector(to_unsigned(i, 5))) then -- Store SW
                                                
                                        o_write_data_memory_r <= i_rs_csr(i);

                                elsif (i_opcode_decoder /= "00000000000100011" and 
                                       i_opcode_decoder /= "00000000010100011" and 
                                       i_opcode_decoder /= "00000000100100011") then
                                        
                                        o_write_data_memory_r <= (others => '0');

                                end if;

                                --связь с LSUMEM и spec_reg addres
                                if (i_opcode_decoder = "00000000100000011" and 
                                    i_spec_reg_or_memory_decoder = '1' and 
                                    i_rs1_decoder = std_logic_vector(to_unsigned(i, 5))) then
                                        
                                        o_addr_spec_reg_csr_r(11 downto 0) <= i_rs_csr(i)(11 downto 0);
                                        o_addr_memory_r <= (others => '0');

                                elsif ((i_opcode_decoder = "00000000000100011" or 
                                        i_opcode_decoder = "00000000010100011" or 
                                        i_opcode_decoder = "00000000100100011" or 
                                        i_opcode_decoder = "00000000000000011" or 
                                        i_opcode_decoder = "00000000010000011" or 
                                        i_opcode_decoder = "00000000100000011" or 
                                        i_opcode_decoder = "00000001000000011" or 
                                        i_opcode_decoder = "00000001010000011") and 
                                        i_rs1_decoder = std_logic_vector(to_unsigned(i, 5))) then 
                                
                                        o_addr_spec_reg_csr_r <= (others => '0');
                                        o_addr_memory_r(15 downto 0) <= i_rs_csr(i)(15 downto 0);

                                elsif (i_opcode_decoder /= "00000000000100011" and 
                                       i_opcode_decoder /= "00000000010100011" and 
                                       i_opcode_decoder /= "00000000100100011" and 
                                       i_opcode_decoder /= "00000000000000011" and 
                                       i_opcode_decoder /= "00000000010000011" and 
                                       i_opcode_decoder /= "00000000100000011" and 
                                       i_opcode_decoder /= "00000001000000011" and 
                                       i_opcode_decoder /= "00000001010000011") then          

                                        o_addr_spec_reg_csr_r <= (others => '0');
                                        o_addr_memory_r <= (others => '0');

                                end if;

                                if (i_rs1_decoder = std_logic_vector(to_unsigned(i, 5))) then
                                        
                                        o_rs1_alu_r <= i_rs_csr(i);
                                        
                                end if;

                        end loop;

                end if;

        end process;

end architecture;