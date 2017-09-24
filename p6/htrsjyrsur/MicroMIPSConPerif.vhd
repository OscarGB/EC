----------------------------------------------------------------------
-- Fichero: MicroMIPSConPerif.vhd
-- Descripci�n: MIPS uniciclo con perif�rico. Esta entidad debe instanciar el micro MIPS, 
-- memoria de datos, memoria de programa y el perif�rico. Esta entidad, por tanto, sirve de
-- uni�n de todos los elementos. Por encima habr� un testbench para generar est�mulos a los puertos de entrada/salida del perif�rico, y para generar el reloj y reset.
-- Fecha �ltima modificaci�n: 2013-04-16

-- Autores: Alberto S�nchez (2013), Alberto S�nchez (2012), �ngel de Castro (2010) 
-- Asignatura: E.C. 1� grado
-- Grupo de Pr�cticas:
-- Grupo de Teor�a:
-- Pr�ctica: 6
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
 
