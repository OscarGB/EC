----------------------------------------------------------------------
-- Fichero: MemProgSuma.vhd
-- Descripción: Memoria de programa para el MIPS. Contiene sumas entre un registro y un dato inmediato
-- Fecha última modificación: 2011-01-22

-- Autores: Alberto Sánchez (2012), Ángel de Castro (2010) 
-- Asignatura: E.C. 1º grado
-- Grupo de Prácticas:
-- Grupo de Teoría:
-- Práctica: 2
-- Ejercicio: 2
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity MemProgSuma is
	port (
		MemProgAddr : in std_logic_vector(31 downto 0); -- Dirección para la memoria de programa
		MemProgData : out std_logic_vector(31 downto 0) -- Código de operación
	);
end MemProgSuma;

architecture Simple of MemProgSuma is

begin

	LecturaMemProg: process(MemProgAddr)
	begin
		-- La memoria devuelve un valor para cada dirección.
		-- Estos valores son los códigos de programa de cada instrucción,
		-- estando situado cada uno en su dirección.
		case MemProgAddr is
			when X"00000000" => MemProgData <= X"2001000A";
			when X"00000004" => MemProgData <= X"20220005";
			when X"00000008" => MemProgData <= X"20430019";
			when others => MemProgData <= X"00000000"; -- Resto de memoria vacía
		end case;
	end process LecturaMemProg;

end Simple;
