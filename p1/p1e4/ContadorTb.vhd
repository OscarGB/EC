----------------------------------------------------------------------
-- Fichero: ContadorTb.vhd
-- Descripci�n: Testbench para un contador 8 bits U/D
-- Fecha �ltima modificaci�n: 2016-02-10

-- Autores: Jos� Ignacio G�mez Garc�a (2016), �scar G�mez Borzdynski (2016) 
-- Asignatura: E.C. 1� doble grado
-- Grupo de Pr�cticas: 2101
-- Grupo de Teor�a: 210
-- Pr�ctica: 1
-- Ejercicio: 4
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity ContadorTb is
end ContadorTb;

architecture Simulation of ContadorTb is
		--Declaraci�n del componente
		component Contador
		port(
		Clk : in  STD_LOGIC;
		Reset : in  STD_LOGIC;
		Ce : in  STD_LOGIC;
		Up : in  STD_LOGIC;
		Q : out  STD_LOGIC_VECTOR (7 downto 0)
	);
	end component;
	
		--Entradas del componente
		signal clk : std_logic := '0';
		signal ce : std_logic := '0';
		signal reset : std_logic := '0';
		signal up : std_logic := '0';
		
		--Salidas del componente
		signal q : std_logic_vector (7 downto 0);
		
		--Constantes del tb
		constant CLKPERIOD : time := 10 ns;
		constant ESPERA : time := 1 ns;
		
	begin
		--Instanciacion del componente
		uut: Contador port map (
		Ce => ce,
		Clk => clk,
		Reset => reset,
		Up => up,
		Q => q
	);
	
		-- Proceso que genera el reloj
		CLKPROCESS :process
		begin
			clk <= '0';
			wait for CLKPERIOD/2;
			clk <= '1';
			wait for CLKPERIOD/2;
		end process;
		
		--Proceso de est�mulos
		stim_proc: process
		begin
			--Inicializacion	
			ce <= '0';
			reset <= '1';
			up <= '1';
			
			wait for ESPERA;
			Assert q = x"00" 
				report "Error de reset"
				severity failure;
				
			ce <= '0';
			reset <= '1';
			up <= '0';
			
			wait for ESPERA;
			Assert q = x"00" 
				report "Error de reset"
				severity failure;
				
			--up = 1
			ce <= '1';
			reset <= '0';
			up <= '1';
			
			for i in 1 to 255 loop
				wait until clk = '1';
				wait for ESPERA;
				assert conv_integer(q)=(i)
					report "Fallo con valor i = "  & integer'image(i)
					severity failure;
			end loop;
			
			wait until clk = '1';
			wait for ESPERA;
			assert conv_integer(q)=(0)
					report "Fallo con desbordamiento superior"
					severity failure;
	
			
			--up = 0
			ce <= '1';
			reset <= '0';
			up <= '0';
			
			for i in 255 downto 0 loop
				wait until clk = '1';
				wait for ESPERA;
				assert conv_integer(q)=(i)
					report "Fallo con valor i = "  & integer'image(i)
					severity failure;
			end loop;
			
			wait until clk = '1';
			wait for ESPERA;
			assert conv_integer(q)=(255)
					report "Fallo con desbordamiento inferior"
					severity failure;
					
			--chip enable
			ce <= '0';
			reset <= '0';
			up <= '1';
			
			wait until clk = '1';
			wait for ESPERA;
			assert conv_integer(q)=(255)
					report "Fallo del chip enable"
					severity failure;
					
		report "Simulacion Finalizada";
		wait;
		end process;
	end Simulation;
	
			

			