----------------------------------------------------------------------
-- Fichero: Registro.vhd
-- Descripción: Registro de 1 bit con Chip Enable
-- Fecha última modificación: 2016-02-03

-- Autores: José Ignacio Gómez (2016), Óscar Gómez (2016) 
-- Asignatura: E.C. 1º grado
-- Grupo de Prácticas: 2101	
-- Grupo de Teoría: 210
-- Práctica: 1
-- Ejercicio: 2
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.ALL;


--Definición de la entidad
--El registro tiene una entrada de datos (D), entrada de Reset, CLK y CE
--Como salida tiene un sólo bit (Q)

entity Registro is
    port ( 
		D : in  std_logic;
		Reset : in  std_logic;
		Clk : in  std_logic;
		Ce : in  std_logic;
		Q : out  std_logic
	);
end Registro;

architecture Practica of Registro is
	
begin

	--El registro es sensible al Reset (asíncrono) y a la señal del reloj
	process (Reset, Clk)
	begin
		-- Si el reset está activo la salida vale 0
		if Reset = '1' then
			Q <= '0';
		-- Si hay un flanco de subida del reloj
		elsif rising_edge (Clk) then
			-- Si el chip enable está activo
			if Ce = '1' then
				Q <= D;
			end if;
		end if;
	end process;

end Practica;
