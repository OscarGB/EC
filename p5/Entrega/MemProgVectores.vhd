----------------------------------------------------------------------
-- Fichero: MemProgVectores.vhd
-- Descripción: Memoria de programa para Vectores
-- Fecha última modificación: 2016-03-30

-- Autores: Óscar Gómez (2016), José Ignacio Gómez (2016) 
-- Asignatura: E.C. 1º grado
-- Grupo de Prácticas: 2101
-- Grupo de Teoría: 210
-- Práctica: 5
-- Ejercicio: 1
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity MemProgMIPS is
    port (
        MemProgAddr : in std_logic_vector(31 downto 0); -- Dirección para la memoria de programa
        MemProgData : out std_logic_vector(31 downto 0) -- Código de operación
    );
end MemProgMIPS;

architecture Simple of MemProgMIPS is

begin

    LecturaMemProg: process(MemProgAddr)
    begin
        -- La memoria devuelve un valor para cada dirección.
        -- Estos valores son los códigos de programa de cada instrucción,
        -- estando situado cada uno en su dirección.
        case MemProgAddr is
            when X"00000000" => MemProgData <= X"20080000";
            when X"00000004" => MemProgData <= X"8c092000";
            when X"00000008" => MemProgData <= X"01294820";
            when X"0000000C" => MemProgData <= X"01294820";
            when X"00000010" => MemProgData <= X"0109502a";
            when X"00000014" => MemProgData <= X"11400009";
            when X"00000018" => MemProgData <= X"8d0b2004";
            when X"0000001C" => MemProgData <= X"8d0c201c";
            when X"00000020" => MemProgData <= X"018c8020";
            when X"00000024" => MemProgData <= X"02108020";
            when X"00000028" => MemProgData <= X"02108020";
            when X"0000002C" => MemProgData <= X"01708822";
            when X"00000030" => MemProgData <= X"ad112034";
            when X"00000034" => MemProgData <= X"21080004";
            when X"00000038" => MemProgData <= X"08000004";
            when X"0000003C" => MemProgData <= X"0800000f";
            when others => MemProgData <= X"00000000"; -- Resto de memoria vacía
        end case;
    end process LecturaMemProg;

end Simple;