----------------------------------------------------------------------
-- Fichero: MicroMIPSConPerif.vhd
-- Descripción: MIPS uniciclo con periférico. Esta entidad debe instanciar el micro MIPS, 
-- memoria de datos, memoria de programa y el periférico. Esta entidad, por tanto, sirve de
-- unión de todos los elementos. Por encima habrá un testbench para generar estímulos a los puertos de entrada/salida del periférico, y para generar el reloj y reset.
-- Fecha última modificación: 2013-04-16

-- Autores: Alberto Sánchez (2013), Alberto Sánchez (2012), Ángel de Castro (2010) 
-- Asignatura: E.C. 1º grado
-- Grupo de Prácticas:
-- Grupo de Teoría:
-- Práctica: 6
-- Ejercicio: 1
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity MicroMIPSConPerif is
port (
  nRST : in std_logic; -- Activo a nivel bajo
  Clk : in std_logic; -- Reloj
  Pin : in std_logic_vector(31 downto 0); -- Puerto entrada
  Pout : out std_logic_vector(31 downto 0)
  ); -- Puerto salida
end MicroMIPSConPerif;
 
