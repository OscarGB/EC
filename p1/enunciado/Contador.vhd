----------------------------------------------------------------------
-- Fichero: Contador.vhd
-- Descripción: Contador de 8 bits con Chip Enable y selector de sentido de cuenta
-- Fecha última modificación: 2012-01-22

-- Autores: Alberto Sánchez (2012), Fernando López (2010) 
-- Asignatura: E.C. 1º grado
-- Grupo de Prácticas:
-- Grupo de Teoría:
-- Práctica: 1
-- Ejercicio: 4
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

-- Contador de 8 bits
entity Contador is
    Port (
		Clk : in  STD_LOGIC;
		Reset : in  STD_LOGIC;
		Ce : in  STD_LOGIC;
		Up : in  STD_LOGIC;
		Q : out  STD_LOGIC_VECTOR (7 downto 0)
	);
end Contador;

architecture Practica of Contador is

	-- Señal auxiliar que almacena el valor
	signal qTemp : std_logic_vector (7 downto 0);

	begin

	Q <= qTemp;

	process (Clk, Reset)
	begin
		if Reset = '1' then
			qTemp <= (OTHERS => '0');
		elsif rising_edge(Clk) then
			if Ce = '1' then
				if Up = '1' then
					qTemp <= qTemp + 1;
				else
					qTemp <= qTemp - 1;
				end if;
			end if;
		end if;

	end process;

end Practica;
