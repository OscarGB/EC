----------------------------------------------------------------------
-- Fichero: ALUSuma.vhd
-- Descripción: ALU para microprocesador simplificado
-- Fecha última modificación: 2016-02-17

-- Autores: José Ignacio Gómez (2016), Óscar Gómez (2016) 
-- Asignatura: E.C. 1º grado
-- Grupo de Prácticas: 2101
-- Grupo de Teoría: 210
-- Práctica: 2
-- Ejercicio: 2
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity ALUSuma is
	port (
		Op1 : in std_logic_vector(31 downto 0); -- Operando
		Op2 : in std_logic_vector(31 downto 0); -- Operando
		Res : out std_logic_vector(31 downto 0) -- Resultado
	);
end ALUSuma;

architecture Simple of ALUSuma is

begin
	Res <= Op1 + Op2;
end Simple;

