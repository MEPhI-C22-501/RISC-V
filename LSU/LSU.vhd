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
        i_spec_reg_or_memory_decoder : in std_logic; --Если 1, то чтение из спец регистров, если 0 то из памяти (сделал)
        i_program_counter_csr : in std_logic_vector (15 downto 0); --Просто получаю (сделал)

        --i_addr_spec_reg_decoder : in std_logic_vector (11 downto 0); --продумать и написать логику Адрес берем из регестра 
        --i_spec_reg_data_csr : in std_logic_vector (31 downto 0); --продумать и написать логику, это будет получаться через write_back 

        o_opcode_alu : out std_logic_vector (16 downto 0);
        o_rs_csr : out registers_array;
        o_rs1_alu, o_rs2_alu : out std_logic_vector (31 downto 0);
        o_write_enable_memory, o_write_enable_csr : out std_logic;
        o_addr_memory: out std_logic_vector (15 downto 0);
        o_write_data_memory: out std_logic_vector (31 downto 0);
        o_rd_csr : out std_logic_vector (4 downto 0);
        o_addr_spec_reg_csr : out std_logic_vector (11 downto 0);  --Адрес берем из регестра (сделал)
		  o_program_counter : out std_logic_vector(15 downto 0);
		  o_program_counter_write_enable : out std_logic
        );

end entity;

architecture LSU_arch of LSU is

begin

        process(i_clk, i_rst) is
	begin

                if (i_rst = '1') then

                        o_opcode_alu <= std_logic_vector(to_unsigned(0, 17));

                elsif (rising_edge(i_clk)) then

                        o_write_enable_csr <= i_write_enable_decoder;
                        
                        --передача кода операции в ALU
                        o_opcode_alu <= i_opcode_decoder;

                        --передача imm в ALU
                        if(i_opcode_decoder = "00000000010010011" or i_opcode_decoder = "00000001010010010" or i_opcode_decoder = "01000001010010011" or i_opcode_decoder = "00000000000010011" or i_opcode_decoder = "00000001000010011" or i_opcode_decoder = "00000001100010011" or i_opcode_decoder = "00000001110010011" or i_opcode_decoder = "00000000100010011" or i_opcode_decoder = "00000000110010011") then

                                o_rs2_alu <= std_logic_vector(to_unsigned(0, 32));

                                for n in 0 to 11 loop

                                        o_rs2_alu(n) <= i_imm_decoder(n);

                                end loop;
                        
                        end if;

                        --связь с LSUMEM
                        if ((i_opcode_decoder = "00000000000100011" or i_opcode_decoder = "00000000010100011" or i_opcode_decoder = "00000000100100011")) then -- Store
                                
                                o_write_enable_memory <= '1';

                        elsif ((i_opcode_decoder = "00000000000000011" or i_opcode_decoder = "00000000010000011" or i_opcode_decoder = "00000000100000011" or i_opcode_decoder = "00000001000000011" or i_opcode_decoder = "00000001010000011")) then --Load
                                
                                o_write_enable_memory <= '0';

                        else          

                                o_write_enable_memory <= '0';

                        end if;


                        --реализация 32 регистров
                        for i in 0 to 31 loop

                                if (i_write_enable_decoder = '1' and i_opcode_decoder = "00000000000000011" and i_rd_decoder = std_logic_vector(to_unsigned(i, 5))) then --Load LB
                                                
                                        --7 младших битов, все остальное знаковым битом (32)
                                        for n in 0 to 7 loop

                                                o_rs_csr(i)(n) <= i_rd_ans(n);

                                        end loop;

                                        for n in 8 to 31 loop

                                                o_rs_csr(i)(n) <= i_rd_ans(31);

                                        end loop;

                                        o_rd_csr <= i_rd_decoder;
                                        
                                elsif (i_write_enable_decoder = '1' and i_opcode_decoder = "00000000010000011" and i_rd_decoder = std_logic_vector(to_unsigned(i, 5))) then --Load LH
                                                
                                        --15 младших битов, все остальное знаковым битом (32)
                                        for n in 0 to 14 loop

                                                o_rs_csr(i)(n) <= i_rd_ans(n);

                                        end loop;

                                        for n in 15 to 31 loop

                                                o_rs_csr(i)(n) <= i_rd_ans(31);

                                        end loop;

                                        o_rd_csr <= i_rd_decoder;
                                        
                                elsif (i_write_enable_decoder = '1' and i_opcode_decoder = "00000000100000011" and i_rd_decoder = std_logic_vector(to_unsigned(i, 5))) then --Load LW  
                                        
                                        o_rs_csr(i) <= i_rd_ans;
                                        o_rd_csr <= i_rd_decoder;
                                        
                                elsif (i_write_enable_decoder = '1' and i_opcode_decoder = "00000001000000011" and i_rd_decoder = std_logic_vector(to_unsigned(i, 5))) then --Load LBU 
                                        
                                        o_rs_csr(i) <= i_rd_ans;
                                        o_rd_csr <= i_rd_decoder;
                                        
                                elsif (i_write_enable_decoder = '1' and i_opcode_decoder = "00000001010000011" and i_rd_decoder = std_logic_vector(to_unsigned(i, 5))) then --Load LHU 
                                                
                                        o_rs_csr(i) <= i_rd_ans;
                                        o_rd_csr <= i_rd_decoder;
                                        
                                elsif (i_write_enable_decoder = '1' and i_rd_decoder = std_logic_vector(to_unsigned(i, 5))) then --Save answer
                                                
                                        o_rs_csr(i) <= i_rd_ans;
                                        o_rd_csr <= i_rd_decoder;
                                        
                                elsif (i_write_enable_decoder = '0') then
                                        
                                        o_rd_csr <= std_logic_vector(to_unsigned(0, 5));
                                        
                                end if;

                                --связь с LSUMEM data
                                if (i_opcode_decoder = "00000000000100011" and i_rs2_decoder = std_logic_vector(to_unsigned(i, 5))) then -- Store SB
                                                
                                        --7 младших битов, все остальное знаковым битом (32)
                                        for n in 0 to 7 loop

                                                o_write_data_memory(n) <= i_rs_csr(i)(n);

                                        end loop;

                                        for n in 8 to 31 loop

                                                o_write_data_memory(n) <= i_rs_csr(i)(31);

                                        end loop;
                                        
                                elsif (i_opcode_decoder = "00000000010100011" and i_rs2_decoder = std_logic_vector(to_unsigned(i, 5))) then -- Store SH
                                                
                                        --15 младших битов, все остальное знаковым битом (32)
                                        for n in 0 to 14 loop

                                                o_write_data_memory(n) <= i_rs_csr(i)(n);

                                        end loop;

                                        for n in 15 to 31 loop

                                                o_write_data_memory(n) <= i_rs_csr(i)(31);

                                        end loop;
                                        
                                elsif (i_opcode_decoder = "00000000100100011" and i_rs2_decoder = std_logic_vector(to_unsigned(i, 5))) then -- Store SW
                                                
                                        o_write_data_memory <= i_rs_csr(i);

                                elsif (i_opcode_decoder /= "00000000000100011" and i_opcode_decoder /= "00000000010100011" and i_opcode_decoder /= "00000000100100011") then
                                        
                                        o_write_data_memory <= std_logic_vector(to_unsigned(0, 32));

                                end if;

                                --связь с LSUMEM и spec_reg addres
                                if (i_opcode_decoder = "00000000100000011" and i_spec_reg_or_memory_decoder = '1' and i_rs1_decoder = std_logic_vector(to_unsigned(i, 5))) then
                                        
                                        for n in 0 to 11 loop

                                                o_addr_spec_reg_csr(n) <= i_rs_csr(i)(n);

                                        end loop;

                                        o_addr_memory <= std_logic_vector(to_unsigned(0, 16));

                                elsif ((i_opcode_decoder = "00000000000100011" or i_opcode_decoder = "00000000010100011" or i_opcode_decoder = "00000000100100011" or i_opcode_decoder = "00000000000000011" or i_opcode_decoder = "00000000010000011" or i_opcode_decoder = "00000000100000011" or i_opcode_decoder = "00000001000000011" or i_opcode_decoder = "00000001010000011") and i_rs1_decoder = std_logic_vector(to_unsigned(i, 5))) then 
                                
                                        o_addr_spec_reg_csr <= std_logic_vector(to_unsigned(0, 12));

                                        for n in 0 to 15 loop

                                                o_addr_memory(n) <= i_rs_csr(i)(n);

                                        end loop;

                                elsif (i_opcode_decoder /= "00000000000100011" and i_opcode_decoder /= "00000000010100011" and i_opcode_decoder /= "00000000100100011" and i_opcode_decoder /= "00000000000000011" and i_opcode_decoder /= "00000000010000011" and i_opcode_decoder /= "00000000100000011" and i_opcode_decoder /= "00000001000000011" and i_opcode_decoder /= "00000001010000011") then          

                                        o_addr_spec_reg_csr <= std_logic_vector(to_unsigned(0, 12));
                                        o_addr_memory <= std_logic_vector(to_unsigned(0, 16));

                                end if;

                                if (i_rs1_decoder = std_logic_vector(to_unsigned(i, 5))) then
                                        
                                        o_rs1_alu <= i_rs_csr(i);
                                        
                                elsif ((i_rs2_decoder = std_logic_vector(to_unsigned(i, 5)) and (i_opcode_decoder = "00000000010110011" or i_opcode_decoder = "00000001010110011" or i_opcode_decoder = "01000001010110011" or i_opcode_decoder = "00000000000110011" or i_opcode_decoder = "01000000000110011" or i_opcode_decoder = "00000001000110011" or i_opcode_decoder = "00000001100110011" or i_opcode_decoder = "00000001110110011" or i_opcode_decoder = "00000000100110011" or i_opcode_decoder = "00000000110110011"))) then
                                        
                                        o_rs2_alu <= i_rs_csr(i);
                                        
                                end if;

                        end loop;

                end if;

        end process;

end architecture;