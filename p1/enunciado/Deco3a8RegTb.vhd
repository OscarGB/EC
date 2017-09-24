----------------------------------------------------------------------
-- Fichero: Deco3a8RegTb.vhd
-- Descripción: Testbench para un decodificador 3 a 8 registrado
-- Fecha última modificación: 2012-01-22

-- Autores: Alberto Sánchez (2012), Fernando López (2010) 
-- Asignatura: E.C. 1º grado
-- Grupo de Prácticas:
-- Grupo de Teoría:
-- Práctica: 1
-- Ejercicio: 3
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity Deco3a8RegTb is
end Deco3a8RegTb;

architecture Simulacion of Deco3a8RegTb is

	-- Declaración del componente Deco3a8Reg

	component Deco3a8Reg
	port(
		D : IN  std_logic_vector(2 downto 0);
		Ce : IN  std_logic;
		Clk : IN  std_logic;
		Reset : IN  std_logic;
		Q : OUT  std_logic_vector(7 downto 0)
	);
	end component;


	-- Entradas del componente a comprobar
	signal d : std_logic_vector(2 downto 0) := (others => '0');
	signal ce : std_logic := '0';
	signal clk : std_logic := '0';
	signal reset : std_logic := '0';

	-- Salidas del componente a comprobar
	signal q : std_logic_vector(7 downto 0);

	-- Constantes del testbench
	constant CLKPERIOD : time := 10 ns;
	constant ESPERA : time := 1 ns;
	constant NINPUT: integer := 3;

begin

	-- Instanciación del componente Deco3a8Reg
	uut: Deco3a8Reg port map (
		D => d,
		Ce => ce,
		Clk => clk,
		Reset => reset,
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

	-- Proceso de estímulos
	stim_proc: process
	begin
		-- Inicialización
		d <= "000";
		ce <= '0';
		reset <= '1';

		wait for ESPERA;
		Assert q = x"00" 
			report "Error de reset"
			severity failure;

		-- Chip enable conectado
		reset <= '0';
		ce <= '1';

		for i in 0 to 7 loop
			d <= conv_std_logic_vector (i,NINPUT);
			wait until clk = '1';
			wait for ESPERA;
			assert conv_integer(q)=(2**i)
				report "Fallo con valor i = "  & integer'image(i)
				severity failure;
		end loop;

		-- Chip enable desconectado
		ce <= '0';

		for i in 0 to 7 loop
			d <= conv_std_logic_vector (i,NINPUT);
			wait until clk = '1';
			wait for ESPERA;
			assert conv_integer(q)=(2**7)
				report "Fallo con valor i = "  & integer'image(i)
				severity failure;
		end loop;

		report "Simulación correcta";
		wait;
	end process;

end Simulacion;
