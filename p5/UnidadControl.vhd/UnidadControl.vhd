----------------------------------------------------------------------
-- Fichero: UnidadControl.vhd
-- Descripción: Unidad de control del microprocesador
-- Fecha última modificación: 2016-03-30

-- Autores: Óscar Gómez (2016), José Ignacio Gómez (2016) 
-- Asignatura: E.C. 1º grado
-- Grupo de Prácticas: 2101
-- Grupo de Teoría: 210
-- Práctica: 5
-- Ejercicio: 2
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity UnidadControl is
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
end UnidadControl;

architecture arch of UnidadControl is

begin
	MemoryToReg: process(OPCode)
	begin 
		case OPCode is
			when "100011" =>
				MemToReg <= '1';
			when others =>
				MemToReg <= '0';
		end case;
	end process MemoryToReg;
	
	MemoryWrite: process(OPCode)
	begin 
		case OPCode is
			when "101011" =>
				MemWrite <= '1';
			when others =>
				MemWrite <= '0';
		end case;
	end process MemoryWrite;
	
	Branchprc: process(OPCode)
	begin 
		case OPCode is
			when "000100" =>
				Branch <= '1';
			when others =>
				Branch <= '0';
		end case;
	end process Branchprc;
	
	
	RegisterDest: process(OPCode)
	begin 
		case OPCode is
			when "000000" =>
				RegDest <= '1';
			when others =>
				RegDest <= '0';
		end case;
	end process RegisterDest;
	
	PCToRegister: process(OPCode)
	begin 
		case OPCode is
			when "000011" =>
				PCToReg <= '1';
			when others =>
				PCToReg <= '0';
		end case;
	end process PCToRegister;
	
	RegisterToPC: process(OPCode, funct)
	begin 
		case OPCode is
			when "000000" =>
				if(funct = "001000") then
					RegToPC <= '1';				--si es un jr, RegToPC vale '1'
				else
					RegToPC <= '0';
				end if;
			when others =>
				RegToPC <= '0';
		end case;
	end process RegisterToPC;
	
	RegisterWrite: process(OPCode)
	begin 
		case OPCode is
			when "000010" => --when j
				RegWrite <= '0';
			when "000100" => --when beq
				RegWrite <= '0';
			when "101011" => --when sw
				RegWrite <= '0';
			when others =>
				RegWrite <= '1';
		end case;
	end process RegisterWrite;
	
	Jumpprc: process(OPCode)
	begin 
		case OPCode is
			when "000010" => --when j
				Jump <= '1';
			when "000011" => --when jal
				Jump <= '1';
			when others =>
				Jump <= '0';
		end case;
	end process Jumpprc;
	
	ALUSource: process(OPCode)
	begin 
		case OPCode is
			when "000000" => --when R TYPE
				ALUSrc <= '0';
			when "000100" => --when beq
				ALUSrc <= '0';
			when others =>
				ALUSrc <= '1';
		end case;
	end process ALUSource;
	
	ALUCtrl: process(OPCode, funct)
	begin
		if (OPCode = "000000") then
			case funct is
				when "100100" => --when and
					ALUControl <= "000";
				when "100000" => --when add
					ALUControl <= "010";
				when "100010" => --when sub
					ALUControl <= "110";
				when "100111" => --when nor
					ALUControl <= "101";
				when "100110" => --when xor
					ALUControl <= "011";
				when "101010" => --when slt
					ALUControl <= "111";
				when others => --when jr
					ALUControl <= "000";
			end case;
		else
			case OPCode is
				when "100011" => --when lw
					ALUControl <= "010";
				when "101011" => --when sw
					ALUControl <= "010";
				when "000100" => --when beq
					ALUControl <= "110";
				when "001000" => --when addi
					ALUControl <= "010";
				when "001100" => --when andi
					ALUControl <= "000";
				when "001110" => --when xori
					ALUControl <= "011";
				when "001010" => --when slti
					ALUControl <= "111";
				when others =>
					ALUControl <= "000"; --incluye j y jal
			end case;
		end if;
	end process ALUCtrl;
	
	ExtCero <= OPCode(2) and OPCode(3); --La salida ExtCero vale 1 en los casos de lógica inmediata andi y xori, 
													--cuyos tercer y cuarto bits del OPCode valen '1' 
end arch;