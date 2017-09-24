----------------------------------------------------------------------
-- Fichero: Regs.vhd
-- Descripción: Registro
-- Fecha última modificación: 2016-02-17

-- Autores: José Ignacio Gómez (2016), Óscar Gómez (2016)
-- Asignatura: E.C. 1º grado
-- Grupo de Prácticas: 2101
-- Grupo de Teoría: 210
-- Práctica: 2
-- Ejercicio: 1
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity Regs is
	port (
		Clk : in std_logic; -- Reloj
		NRst : in std_logic; -- Reset asíncrono a nivel bajo
		RtIn : in std_logic_vector(31 downto 0); -- Dato de entrada RT
		RtAddr : in std_logic_vector(4  downto 0); -- Dirección RT (escritura)
		RsAddr : in std_logic_vector(4 downto 0); -- Dirección RS (lectura)
		RsOut : out std_logic_vector(31 downto 0) -- Salida RS
	); 
end Regs;

architecture Practica of Regs is

	-- Tipo para almacenar los registros
	type regs_t is array (0 to 31) of std_logic_vector(31 downto 0);

	-- Esta es la señal que contiene los registros. El acceso es de la
	-- siguiente manera: regs(i) acceso al registro i, donde i es
	-- un entero. Para convertir del tipo std_logic_vector a entero se
	-- hace de la siguiente manera: conv_integer(slv), donde
	-- slv es un elemento de tipo std_logic_vector

	-- Registros inicializados a '0' 
	-- NOTA: no cambie el nombre de esta señal.
	signal regs : regs_t;

begin  -- PRACTICA

	------------------------------------------------------
	-- Escritura del registro RT
	------------------------------------------------------
	ESCRITURA: process(Clk, NRst)
	begin
		if NRst ='0' then
			for i in 0 to 31 loop
				regs(i) <= (OTHERS => '0');
			end loop;
		elsif rising_edge(Clk) then
			case conv_integer(RtAddr) is
				when (0) =>
					regs(0) <= conv_std_logic_vector (0, 32);
				when OTHERS =>
					regs(conv_integer(RtAddr)) <= RtIn;
			end case;
		end if;			
	end process ESCRITURA;

	------------------------------------------------------
	-- Lectura del registro RS
	------------------------------------------------------
	
	RsOut <= regs(conv_integer(RsAddr));
	
end Practica;

