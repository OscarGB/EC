----------------------------------------------------------------------
-- Fichero: ALUMIPS.vhd
-- Descripción: ALU completa
-- Fecha última modificación: 2016-03-02

-- Autores: José Ignacio Gómez (2016), Óscar Gómez (2016)
-- Asignatura: E.C. 1º grado
-- Grupo de Prácticas: 2101
-- Grupo de Teoría: 210
-- Práctica: 3
-- Ejercicio: 1
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_signed.ALL;

entity ALUMIPS is
	port(
		Op1 : in std_logic_vector (31 downto 0); --Operador 1
		Op2 : in std_logic_vector (31 downto 0); --Operador 2
		ALUControl : in std_logic_vector (2 downto 0);	--Señal de control
		Res : out std_logic_vector (31 downto 0); --Resultado
		Z : out std_logic --Señal se activa si son todo 0
		);
end ALUMIPS;

architecture Practica of ALUMIPS is
	signal Resta : std_logic_vector (31 downto 0); --señal que tomamos para realizar la resta
begin

	Resta <= Op1 - Op2;

	process (ALUControl)
	variable ResAux : std_logic_vector (31 downto 0); --Utilizamos una variable para poder modificar su valor dentro del process
	begin
		case ALUControl is
			when "010" => --caso suma
				ResAux := Op1 + Op2;
			when "110"  => --caso resta
				ResAux := Resta;
			when "000" => --caso and
				ResAux := Op1 and Op2; 
			when "011" =>--caso xor
				ResAux := Op1 xor Op2; 
			when "101" => --caso nor
				ResAux := Op1 nor Op2;
			
			when others => --decidimos que todas las operaciones no definidas realicen un SLT
				
			
					if Op1(31) = Op2(31) then --Si ambos números tienen el mismo signo
						ResAux(0) := Resta(31); --El signo de la resta coincide (en complemento a2) con el resultado que queremos obtener
						ResAux (31 downto 1) := (others => '0'); --Extendemos con '0' el resto del bus
					else 
						Resaux (0) := Op1(31); --Si tienen distinto signo
						ResAux (31 downto 1) := (others => '0'); --Basta comprobar su signo, el negativo será menor
					end if;
				
			end case;
			
			if ResAux = conv_std_logic_vector(0, 32) then --Comprobamos que la salida no sea 0 para darle valores a z
				Z <= '1';
			else
				Z <= '0';
			end if;
						
			Res <= ResAux;
			
		end process;
		
		
end Practica;