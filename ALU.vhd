library ieee;
use ieee.std_logic_1164.all;
library work;
use work.alu_package.all;

entity ALU is
    port(
        i_first_operand, i_second_operand : in std_logic_vector(31 downto 0);
        i_manage : in std_logic_vector(16 downto 0);
        i_clk : in std_logic;
        i_rst : in std_logic;
        o_result : out std_logic_vector(31 downto 0)
    );
end entity;

architecture ALU_arch of ALU is

    -- constant 

    constant ADDI_OP   : std_logic_vector := "00000000000010011";
    constant SLTI_OP   : std_logic_vector := "00000000100010011";
    constant SLTIU_OP  : std_logic_vector := "00000000110010011";
    constant XORI_OP   : std_logic_vector := "00000001000010011";
    constant ORI_OP    : std_logic_vector := "00000001100010011";
    constant ANDI_OP   : std_logic_vector := "00000001110010011";
    constant SLLI_OP   : std_logic_vector := "00000000010010011";
    constant SRLI_OP   : std_logic_vector := "00000001010010011";
    constant SRAI_OP   : std_logic_vector := "01000001010010011";
    
    constant ADD_OP    : std_logic_vector := "00000000000110011";
    constant SUB_OP    : std_logic_vector := "01000000000110011";
    constant SLL_OP    : std_logic_vector := "00000000010110011";
    constant SLT_OP    : std_logic_vector := "00000000100110011";
    constant SLTU_OP   : std_logic_vector := "00000000110110011";
    constant XOR_OP    : std_logic_vector := "00000001000110011";
    constant SRL_OP    : std_logic_vector := "00000001010110011";
    constant SRA_OP    : std_logic_vector := "01000001010110011";
    constant OR_OP     : std_logic_vector := "00000001100110011";
    constant AND_OP    : std_logic_vector := "00000001110110011";
    constant MUL_OP    : std_logic_vector := "00000010000110011";
    constant MULH_OP   : std_logic_vector := "00000010010110011";
    constant MULHSU_OP : std_logic_vector := "00000010100110011";
    constant MULHU_OP  : std_logic_vector := "00000010110110011";

    signal result_r : std_logic_vector(31 downto 0);
	signal result_r_1: std_logic_vector(31 downto 0);
	signal result_r_2: std_logic_vector(31 downto 0);
    
    begin
	
	o_result <= result_r_2;
	
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            result_r <= x"00000000";
        elsif(rising_edge(i_clk)) then
            if(i_manage = ADDI_OP or i_manage = ADD_OP) then
                result_r <= addition(i_first_operand, i_second_operand);
            elsif(i_manage = SLTI_OP or i_manage = SLT_OP) then 
                result_r <= set_less_then(i_first_operand, i_second_operand);            
            elsif(i_manage = SLTIU_OP) then 
                result_r <= set_less_then_unsigned(i_first_operand, i_second_operand);            
            elsif(i_manage = XORI_OP or i_manage = XOR_OP) then
                result_r <= i_first_operand xor i_second_operand;            
            elsif(i_manage = ORI_OP or i_manage = OR_OP) then
                result_r <= i_first_operand or i_second_operand;            
            elsif(i_manage = ANDI_OP or i_manage = AND_OP) then 
                result_r <= i_first_operand and i_second_operand;            
            elsif(i_manage = SLLI_OP or i_manage = SLL_OP) then 
                result_r <= shift_left_logic(i_first_operand, i_second_operand); 
            elsif(i_manage = SRLI_OP or i_manage = SRL_OP) then 
                result_r <= shift_right_logic(i_first_operand, i_second_operand); 
            elsif(i_manage = SRAI_OP or i_manage = SRA_OP) then
                result_r <= shift_right_arithmetic(i_first_operand, i_second_operand); 
            elsif(i_manage = SUB_OP) then
                result_r <= substraction(i_first_operand, i_second_operand); 
            elsif(i_manage = MUL_OP) then 
                result_r <= multiplication(i_first_operand, i_second_operand); 
            elsif(i_manage = MULH_OP) then 
                result_r <= multiplication_high(i_first_operand, i_second_operand); 
            elsif(i_manage = MULHSU_OP) then
                result_r <= multiplication_high_signed_unsigned(i_first_operand, i_second_operand);
            elsif(i_manage = MULHU_OP) then
                result_r <= multiplication_high_unsigned(i_first_operand, i_second_operand);
            end if;
        end if;
		result_r_2 <= result_r_1;
		result_r_1 <= result_r;
		
    end process;

end architecture;
