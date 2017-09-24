library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity P1e1_tb is
end P1e1_tb;

architecture Test of P1e1_tb is
component P1e1
	port( A: in std_logic;
			B: in std_logic;
			C: in std_logic;
			Q: out std_logic);
end component;

--Entradas
signal A : std_logic := '0';
signal B : std_logic := '0';
signal C : std_logic := '0';

--Salidas
signal Q : std_logic;

constant ESPERA : time := 10 ns;

begin

uut:P1e1 port map(
	A => A,
	B => B,
	C => C,
	Q => Q);
	
--Proceso 
process
begin 
	A<='0';
	B<='0';
	C<='0';
	wait for ESPERA;
	assert Q = '0'
		report "Error en el caso"&std_logic'image(A) & std_logic'image(B) & std_logic'image(C)
		severity failure;
	
	A<='0';
	B<='0';
	C<='1';
	wait for ESPERA;
	assert Q = '0'
		report "Error en el caso"&std_logic'image(A) & std_logic'image(B) & std_logic'image(C)
		severity failure;
		
	A<='0';
	B<='1';
	C<='0';
	wait for ESPERA;
	assert Q = '0'
		report "Error en el caso"&std_logic'image(A) & std_logic'image(B) & std_logic'image(C)
		severity failure;
	A<='0';
	B<='1';
	C<='1';
	wait for ESPERA;
	assert Q = '1'
		report "Error en el caso"&std_logic'image(A) & std_logic'image(B) & std_logic'image(C)
		severity failure;
		
	A<='1';
	B<='0';
	C<='0';
	wait for ESPERA;
	assert Q = '0'
		report "Error en el caso"&std_logic'image(A) & std_logic'image(B) & std_logic'image(C)
		severity failure;
	
	A<='1';
	B<='0';
	C<='1';
	wait for ESPERA;
	assert Q = '1'
		report "Error en el caso"&std_logic'image(A) & std_logic'image(B) & std_logic'image(C)
		severity failure;
		
	A<='1';
	B<='1';
	C<='0';
	wait for ESPERA;
	assert Q = '0'
		report "Error en el caso"&std_logic'image(A) & std_logic'image(B) & std_logic'image(C)
		severity failure;
	A<='1';
	B<='1';
	C<='1';
	wait for ESPERA;
	assert Q = '1'
		report "Error en el caso"&std_logic'image(A) & std_logic'image(B) & std_logic'image(C)
		severity failure;
		
	--Fin simulacion
	report "OK";
	wait;
end process;
end Test;