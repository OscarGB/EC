----------------------------------------------------------------------
-- Fichero: Deco3a8Reg.vhd
-- Descripci�n: Decodificador 3 a 8 con registro
-- Fecha �ltima modificaci�n: 2016-02-03

-- Autores: Jos� Ignacio G�mez (2016), �scar G�mez (2016) 
-- Asignatura: E.C. 1� grado
-- Grupo de Pr�cticas: 2101
-- Grupo de Teor�a: 210
-- Pr�ctica: 1
-- Ejercicio: 3
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity Deco3a8Reg is
 port (
		D : in std_logic_vector (2 downto 0);
		CE : in std_logic;
		Clk : in std_logic;
		Reset : in std_logic;
		Q : out std_logic_vector (7 downto 0)
 );
end Deco3a8Reg;

 / architecture comport of Deco3a8Reg is
	
	signal s : std_logic_vector (7 downto 0);
	
	begin
		--Proceso del decodificador 3-8
		process (D)
		begin
			case D is
				when "000" => 
					s <= "00000001";
				when "001" => 
					s <= "00000010";
				when "010" => 
					s <= "00000100";
				when "011" => 
					s <= "00001000";
				when "100" => 
					s <= "00010000";
				when "101" => 
					s <= "00100000";
				when "110" => 
					s <= "01000000";
				when others => 
					s <= "10000000";
			end case;
		end process;
	
	--Proceso del registro
	--El registro es sensible al Reset (as�ncrono) y a la se�al del reloj
		process (Reset, Clk)
		begin
			-- Si el reset est� activo la salida vale 0
			if Reset = '1' then
				Q <= "00000000";
			-- Si hay un flanco de subida del reloj
			elsif rising_edge (Clk) then
				-- Si el chip enable est� activo
				if Ce = '1' then
					Q <= s;
				end if;
			end if;
		end process;
	end comport;

	