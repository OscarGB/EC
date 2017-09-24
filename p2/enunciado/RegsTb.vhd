----------------------------------------------------------------------
-- Fichero: RegsTb.vhd
-- Descripción: Banco de pruebas del banco de registros del microprocesador MIPS Simplificado
-- Fecha última modificación: 2012-01-16

-- Autores: Alberto Sánchez (2012) Ángel de Castro (2011), Alberto Sánchez (2010), Miguel Ángel García (2009), Sergio López-Buedo (2005), Juán González Gómez (2005)
-- Asignatura: E.C. 1º grado
-- Grupo de Prácticas:
-- Grupo de Teoría:
-- Práctica: 2
-- Ejercicio: 1
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RegsTb is
end RegsTb;

architecture Practica of RegsTb is

component Regs
	port (
		Clk      : in std_logic; -- Reloj
		NRst     : in std_logic; -- Reset asíncrono a nivel bajo
		RtIn    : in  std_logic_vector(31 downto 0); -- Dato de entrada
		RtAddr  : in  std_logic_vector(4  downto 0); -- Dirección RT
		RsAddr  : in  std_logic_vector(4 downto 0); -- Dirección RS1
		RsOut   : out std_logic_vector(31 downto 0)); -- Salida RS1
end component;

-- Constantes
constant TAMANO   : integer := 32;
constant INSTANTE : time := 10 ns;
constant PERIOD   : time := 50 ns; -- Periodo de la senal de reloj

-- Senales
signal RsOut, RTIn : std_logic_vector(31 downto 0):=(others=>'0');
signal RtAddr, RsAddr : std_logic_vector(4 downto 0):="00000";
signal Clk, NRst : std_logic;
signal endSim : boolean := false; -- Senal para parar el reloj

begin

	-- Instanciar el banco de registros
	uut: Regs 
	PORT MAP(
		Clk => clk,
		NRst => nRst,
		RTIn => rtIn,
		RtAddr => rtAddr,
		RsAddr => rsAddr,
		RsOut => rsOut
	);

	-- Proceso de reloj. Se para cuando la senal endSim se pone a TRUE
	process
	begin  -- process
		while not endSim loop
			clk<='0';
			wait for PERIOD/2;
			clk<='1';
			wait for PERIOD/2;
		end loop;  -- i
		wait;
	end process;

	-----------------------------------------------------------------------------
	-- Proceso principal de pruebas
	-----------------------------------------------------------------------------
	MAIN: process
	begin
		-- Poner todas las senales a '0' inicialmente
		rtAddr <= (others=>'0');
		rsAddr <= (others => '0');
		rtIn <= (others => '0');
		nRst <= '0';
		wait for INSTANTE;
		nRst <= '1';

		---------------------------------------------------------------------------
		-- Prueba de reset
		-- Todos los registros deben tener el valor de 0
		---------------------------------------------------------------------------
		for i in 0 to TAMANO-1 loop
			rsAddr <= std_logic_vector(to_unsigned(i,5));
			wait for INSTANTE;
			-- Comprobar la salida de RS1
			assert rsOut = x"00000000"
			report "Error en el reset"
			severity FAILURE;
		end loop;

		---------------------------------------------------------------------------
		-- Prueba de escritura
		-- En cada registro se escribe el valor de su direccion + 16
		---------------------------------------------------------------------------
		for i in TAMANO-1 downto 0 loop

			-- Colocar dato a guardar
			rtIn <= std_logic_vector(to_unsigned(i+16,32));

			-- Colocar direccion destino
			rtAddr <= std_logic_vector(to_unsigned(i,5));

			-- Esperar un flanco de subida de reloj, que es donde se hace la
			-- escritura
			wait until rising_edge(clk);
         
			-- Comprobar que se esta usando solo el flanco de subida cambiando el
			-- dato antes del de bajada:
			rtIn <= x"FFFFFFFF";
			wait until falling_edge(clk);

		end loop;  -- i

		---------------------------------------------------------------------------
		-- Pruebas de lectura.
		---------------------------------------------------------------------------
		wait for INSTANTE;

		for i in 1 to TAMANO-1 loop
			-- En RS1 se colocan las direcciones "ascendentes"
			rsAddr <= std_logic_vector(to_unsigned(i,5));
			wait for INSTANTE;

			-- Comprobar la salida de RS
			assert rsOut = std_logic_vector(to_unsigned(i+16,32))
			report "Error en la lectura de RS1 (" & integer'image (to_integer(signed(rsOut))) & ")"
			severity FAILURE;

			-- Comprobar que del registro 0 se lee '0'
			rsAddr <= (others=>'0');
			wait for INSTANTE;

			-- Comprobar registro RS
			assert rsOut = std_logic_vector(to_unsigned(0,32))
			  report "Error. Al leer registro 0 por RS1 no se obtiene 0"
			  severity FAILURE;
		end loop;

		-- Comprueba que cambie RsOut cuando cambia
		-- el valor del registro manteniéndose la misma dirección
		for i in 1 to TAMANO-1 loop

			rsAddr <= std_logic_vector(to_unsigned(i,5));
			rtAddr <= std_logic_vector(to_unsigned(i,5));

			wait for INSTANTE;

			-- Cambia el valor del registro sin cambiar la dirección

			rTIn <= x"0f0f0f0f";
			wait until rising_edge(clk);
			wait for INSTANTE;

			assert rsOut = x"0f0f0f0f" 
			report "Error. Salida RS1_OUT no cambia cuando varía contenido de registro pero no su dirección."
			severity FAILURE;  

		end loop;

		report "Si no ha habido mensajes de error anteriores... ¡SIMULACIÓN CORRECTA!";
		endSim <= TRUE;
		wait;
		end process MAIN;

end PRACTICA;

