----------------------------------------------------------------------
-- Fichero: ALUSuma.vhd
-- Descripci�n: ALU para microprocesador simplificado
-- Fecha �ltima modificaci�n: 2016-02-17

-- Autores: Jos� Ignacio G�mez (2016), �scar G�mez (2016) 
-- Asignatura: E.C. 1� grado
-- Grupo de Pr�cticas: 2101
-- Grupo de Teor�a: 210
-- Pr�ctica: 2
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

