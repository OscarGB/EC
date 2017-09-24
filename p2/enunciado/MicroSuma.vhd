----------------------------------------------------------------------
-- Fichero: MicroSuma.vhd
-- Descripción: 
-- Fecha última modificación: 

-- Autores: 
-- Asignatura: E.C. 1º grado
-- Grupo de Prácticas:
-- Grupo de Teoría:
-- Práctica: 2
-- Ejercicio: 2
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity MicroSuma is
	port (
		Clk : in std_logic; -- Reloj
		NRst : in std_logic; -- Reset activo a nivel bajo
		MemProgAddr : out std_logic_vector(31 downto 0); -- Dirección para la memoria de programa
		MemProgData : in std_logic_vector(31 downto 0) -- Código de operación
	);
end MicroSuma;

architecture Practica of MicroSuma is

	COMPONENT ALUSuma PORT(
		Op1 : in std_logic_vector(31 downto 0); -- Operando
		Op2 : in std_logic_vector(31 downto 0); -- Operando
		Res : out std_logic_vector(31 downto 0) -- Resultado
	);
	end COMPONENT;
	
	COMPONENT Regs PORT(
		Clk : in std_logic; -- Reloj
		NRst : in std_logic; -- Reset asíncrono a nivel bajo
		RtIn : in std_logic_vector(31 downto 0); -- Dato de entrada RT
		RtAddr : in std_logic_vector(4  downto 0); -- Dirección RT (escritura)
		RsAddr : in std_logic_vector(4 downto 0); -- Dirección RS (lectura)
		RsOut : out std_logic_vector(31 downto 0) -- Salida RS
	); 
	end COMPONENT;
	
	signal Op1, Op2, C: std_logic_vector(31 downto 0);
	signal AuxMemProgAddr: std_logic_vector(31 downto 0);

begin
	MSALU: ALUSuma PORT MAP(
		Op1 => Op1,
		Op2 => Op2,
		Res => C
		);
	MSRegs: Regs PORT MAP(
		RSOut => Op1,
		RtIn => C,
		RsAddr => MemProgData(25 downto 21),
		RtAddr => MemProgData(20 downto 16),
		Clk => Clk,
		NRst => NRst
		);
	
	Op2(31 downto 16) <= (others => MemProgData(15));
	Op2(15 downto 0) <= MemprogData(15 downto 0);
	MemProgAddr <= AuxMemProgAddr;
	
	process(Clk, NRst)
	begin
		if NRst = '0' then
			AuxMemProgAddr <= (others => '0');
		elsif rising_edge(Clk) then
			AuxMemProgAddr <= AuxMemProgAddr + 4;
		end if;
	end process;	

end Practica;

