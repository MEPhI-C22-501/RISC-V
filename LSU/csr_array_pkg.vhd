library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

-- Пакет, который содержит тип и функции для работы с ним
package csr_array_pkg is

    -- Определим тип csr_array как массив из std_logic_vector
    type csr_array is array (0 to 31) of std_logic_vector(31 downto 0);

    -- Функции для работы с типом

    -- Функция для создания нового вектора
    function create_vector(init_value: std_logic_vector) return csr_array;

end csr_array_pkg;

package body csr_array_pkg is

    -- Реализация функции для создания нового вектора
    function create_vector(init_value: std_logic_vector) return csr_array is
    
        variable new_vector : csr_array;
    
    begin

        -- Инициализация каждого элемента вектора одинаковым значением
        for i in 0 to 31 loop
        
            new_vector(i) := init_value;
        
        end loop;
        
        return new_vector;
    
    end function;

end package body csr_array_pkg;