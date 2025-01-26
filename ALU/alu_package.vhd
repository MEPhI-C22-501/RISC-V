library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package alu_package is
        
    function addition (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector;

    function substraction (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector;

    function set_less_then (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector;

    function set_less_then_unsigned (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector;

    function xor_op (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector;

    function or_op (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector;

    function and_op (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector;

    function shift_left_logic (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
        ) return std_logic_vector;

    function shift_right_logic (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector;

    function shift_right_arithmetic (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector;

    function multiplication (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector;

    function multiplication_high (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector;

    function multiplication_high_signed_unsigned (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector;

    function multiplication_high_unsigned (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector;

end package;

package body alu_package is 

    -- simple arithmetic functions --

    function addition (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector is
        constant len : integer := i_first_operand'length - 1;
        variable result : signed(len downto 0);
    begin
        result := signed(i_first_operand) + signed(i_second_operand);
        return std_logic_vector(result(len downto 0));
    end function;

    function substraction (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector is
        constant len : integer := i_first_operand'length - 1;
        variable result : signed(len downto 0);
    begin
        result := signed(i_first_operand) - signed(i_second_operand);
        return std_logic_vector(result(len downto 0));
    end function;

    function set_less_then (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector is
        constant len : integer := i_first_operand'length - 1;
        variable result : signed(len downto 0);
    begin
        result := signed(i_first_operand) - signed(i_second_operand);
        if(result(len) = '1') then
            return std_logic_vector(to_unsigned(1, len + 1));
        else
            return std_logic_vector(to_unsigned(0, len + 1));
        end if;
    end function;

    function set_less_then_unsigned (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector is 
        constant len : integer := i_first_operand'length - 1;
        variable result : unsigned(i_first_operand'length - 1 downto 0);
    begin
        result := unsigned(i_first_operand) - unsigned(i_second_operand);
        if(result(len) = '1') then
            return std_logic_vector(to_unsigned(1, len + 1));
        else
            return std_logic_vector(to_unsigned(0, len + 1));
        end if;
    end function;

    -- simple logic functions

    function xor_op (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector is
    begin
        return (i_first_operand xor i_second_operand);
    end function;

    function or_op (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector is
    begin
        return i_first_operand or i_second_operand;
    end function;

    function and_op (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector is
    begin
        return i_first_operand and i_second_operand;
    end function;

    function shift_left_logic (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector is 
        constant shift : integer := to_integer(unsigned(i_second_operand));
    begin
        return to_stdlogicvector(to_bitvector(i_first_operand) sll shift);
    end function;

    function shift_right_logic (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector is
        variable shift : integer := to_integer(unsigned(i_second_operand));
    begin
        return to_stdlogicvector(to_bitvector(i_first_operand) srl shift);
    end function;

    function shift_right_arithmetic (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector is
        variable shift : integer := to_integer(unsigned(i_second_operand));
    begin
        return to_stdlogicvector(to_bitvector(i_first_operand) sra shift);
    end function;

    function multiplication (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector is
        constant len1 : integer := i_first_operand'length;
        constant len2 : integer := i_second_operand'length;
        variable result : std_logic_vector(len1 + len2 - 1 downto 0); 
    begin
        result := std_logic_vector(signed(i_first_operand) * signed(i_second_operand));
        return result(len1 - 1 downto 0);
    end function;

    function multiplication_high (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector is 
        constant len1 : integer := i_first_operand'length;
        constant len2 : integer := i_second_operand'length;
        variable result : std_logic_vector(len1 + len2 - 1 downto 0); 
    begin
        result := std_logic_vector(signed(i_first_operand) * signed(i_second_operand));
        return result(len1 + len2 - 1 downto len2);
    end function;

    function multiplication_high_signed_unsigned (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector is 
        constant len1 : integer := i_first_operand'length;
        constant len2 : integer := i_second_operand'length;
        constant second_extended : std_logic_vector(len2 downto 0) := '0' & i_second_operand;
        variable result : std_logic_vector(len1 + len2 downto 0); 
    begin
        result := std_logic_vector(signed(i_first_operand) * signed(second_extended));
        return result(len1 + len2 downto len2 + 1);
    end function;

    function multiplication_high_unsigned (
        signal i_first_operand : in std_logic_vector;
        signal i_second_operand : in std_logic_vector
    ) return std_logic_vector is 
        constant len1 : integer := i_first_operand'length;
        constant len2 : integer := i_second_operand'length;
        variable result : std_logic_vector(len1 + len2 - 1 downto 0); 
    begin
        result := std_logic_vector(unsigned(i_first_operand) * unsigned(i_second_operand));
        return result(len1 + len2 - 1 downto len2);
    end function;
end package body;