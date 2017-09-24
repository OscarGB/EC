----------------------------------------------------------------------
-- Fichero: MicroMIPS.vhd
-- Descripción: Microprocesador MIPS completo
-- Fecha última modificación: 2016-04-06

-- Autores: Óscar Gómez (2016), José Ignacio Gómez (2016)
-- Asignatura: E.C. 1º grado
-- Grupo de Prácticas: 2101
-- Grupo de Teoría: 210
-- Práctica: 5
-- Ejercicio: 3
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity MicroMIPS is
port(
	Clk : in std_logic; -- Reloj
	NRst : in std_logic; -- Reset activo a nivel bajo
	MemProgAddr : out std_logic_vector(31 downto 0); -- Dirección para la memoria de programa
	MemProgData : in std_logic_vector(31 downto 0); -- Código de operación
	MemDataAddr : out std_logic_vector(31 downto 0); -- Dirección para la memoria de datos
	MemDataDataRead : in std_logic_vector(31 downto 0); -- Dato a leer en la memoria de datos
	MemDataDataWrite : out std_logic_vector(31 downto 0); -- Dato a guardar en la memoria de datos
	MemDataWE : out std_logic);
end MicroMIPS;

architecture ejercicio of MicroMIPS is
	component UnidadControl
	port(
        OPCode: in std_logic_vector(5 downto 0);
        Funct: in std_logic_vector(5 downto 0);
        MemToReg: out std_logic;
        MemWrite: out std_logic;
        Branch: out std_logic;
        ALUControl: out std_logic_vector(2 downto 0);
        ALUSrc: out std_logic;
        RegDest: out std_logic;
        RegWrite: out std_logic;
        RegToPC: out std_logic;
        ExtCero: out std_logic;
        Jump: out std_logic;
        PCToReg: out std_logic
        );
	end component;
	
	component ALUMIPS
    port(
        Op1 : in std_logic_vector (31 downto 0); --Operador 1
        Op2 : in std_logic_vector (31 downto 0); --Operador 2
        ALUControl : in std_logic_vector (2 downto 0);  --Señal de control
        Res : out std_logic_vector (31 downto 0); --Resultado
        Z : out std_logic --Señal se activa si son todo 0
        );
	end component;
	
	component RegsMIPS
    port (
        Clk : in std_logic; -- Reloj
        NRst : in std_logic; -- Reset asíncrono a nivel bajo
        Wd3 : in std_logic_vector(31 downto 0); -- Dato de entrada RT
        A3 : in std_logic_vector(4  downto 0); -- Dirección RT (escritura)
        A2 : in std_logic_vector(4 downto 0); -- Dirección RS (lectura 2)
        A1 : in std_logic_vector(4 downto 0); -- Dirección RS (lectura 1)
        Rd1 : out std_logic_vector(31 downto 0); -- Salida RS1
        Rd2 : out std_logic_vector(31 downto 0); -- Salida RS2
        We3 : in std_logic --write enable
    );
	end component;

	 signal MemToReg: std_logic;
	 signal Branch: std_logic;
	 signal ALUControl: std_logic_vector (2 downto 0);
	 signal ALUSrc: std_logic;
	 signal RegDest: std_logic;
	 signal RegWrite: std_logic;
	 signal RegToPC: std_logic;
	 signal ExtCero: std_logic;
	 signal Jump: std_logic;
	 signal PCToReg: std_logic;
	 signal Wd3: std_logic_vector (31 downto 0);
	 signal A3: std_logic_vector (4 downto 0);
	 signal Rd1: std_logic_vector (31 downto 0);
	 signal Rd2: std_logic_vector (31 downto 0);
	 signal Op2: std_logic_vector (31 downto 0);
	 signal Res: std_logic_vector (31 downto 0);
	 signal Z: std_logic;
	 signal PC4: std_logic_vector (31 downto 0); -- salida PC + 4
	 signal PC: std_logic_vector (31 downto 0);
	 signal ExtSigno: std_logic_vector (31 downto 0);
	 signal PCSrc: std_logic;
	 signal PCIn: std_logic_vector (31 downto 0);
	 signal BTA: std_logic_vector (31 downto 0);
	 signal JTA: std_logic_vector (31 downto 0);
	 signal ExtSigno4: std_logic_vector (31 downto 0);
begin
	
	UniControl: UnidadControl
	port map(
		OPCode => MemProgData (31 downto 26),
		Funct => MemProgData (5 downto 0),
		MemToReg => MemToReg,
		MemWrite => MemDataWe,
		Branch => Branch,
		ALUControl => ALUControl,
		ALUSrc => ALUSrc,
		RegDest => RegDest,
		RegWrite => RegWrite,
		RegToPC => RegToPC,
		ExtCero => ExtCero,
		Jump => Jump,
		PCToReg => PCToReg		
	);
	
	RegMIPS: RegsMIPS
	port map(
		Clk => Clk,
		Nrst => NRST,
		Wd3 => Wd3,
		A3 => A3,
		A2 => MemProgData (20 downto 16),
		A1 => MemProgData (25 downto 21),
		Rd1 => Rd1,
		Rd2 => Rd2,
		We3 => RegWrite
	);
	
	ALUMIPSP: ALUMIPS
	port map(
		Op1 => Rd1,
		Op2 => Op2,
		ALUControl => ALUControl,
		Res => Res,
		Z => Z
	);
	
	MuxDcha: process (MemToReg, PCToReg, MemDataDataRead, Res, PC4)
	begin
		if (PCToReg = '1') then
			Wd3 <= PC4;
		else
			if(MemToReg = '1') then
				Wd3 <= MemDataDataRead;
			else
				Wd3 <= Res;
			end if;
		end if;
	end process MuxDcha;
	
	MuxCentro: process (PCToReg, RegDest, MemProgData)
	begin
		if(PCToReg = '1') then
			A3 <= "11111";
		else
			if(RegDest = '1') then
				A3 <= MemProgData (15 downto 11);
			else
				A3 <= MemProgData (20 downto 16);
			end if;
		end if;
	end process MuxCentro;
	
	Op2ALU: process (ExtCero, ALUSrc, MemProgData, Rd2, ExtSigno)
	begin
		if (ALUSrc = '0') then
			OP2 <= Rd2;
		else
			if(ExtCero ='1') then
				Op2 (31 downto 16) <= (others => '0');
				Op2 (15 downto 0) <= MemProgData (15 downto 0);
			else
				Op2 <= ExtSigno;
			end if;
		end if;
	end process Op2ALU;
	
	PcD: process (Clk, Nrst)
	begin
		if(Nrst = '0') then
			PC <= (others => '0');
		else
			if (rising_edge(Clk)) then
				PC <= PCIn;
			end if;
		end if;
	end process PcD;
	
	MuxIzquda: process(RegToPC, Jump, PCSrc, BTA, PC4, RD1, JTA)
	begin
		if(RegToPC = '1') then
			PCIn <= Rd1;
		else
			if(Jump = '1') then
				PCIn <= JTA;
			else
				if(PCSrc = '0') then
					PCIn <= PC4;
				else
					PCIn <= BTA;
				end if;
			end if;
		end if;
	end process MuxIzquda;
	
	ExtSigno (31 downto 16) <= (others => MemProgData(15));	
	ExtSigno (15 downto 0) <= MemProgData (15 downto 0);
	
	PCSrc <= Z and Branch;
	
	PC4 <= PC +4;
	
	MemProgAddr <= PC;
	
	ExtSigno4 <= ExtSigno(29 downto 0) & "00"; --Multiplicación por 2^2
	
	BTA <= ExtSigno4 + PC4;
	
	JTA <= PC4(31 downto 28) & MemProgData(25 downto 0) & "00"; 

	MemDataAddr <= Res;
	
	MemDataDataWrite <= Rd2;
	
end ejercicio;
	