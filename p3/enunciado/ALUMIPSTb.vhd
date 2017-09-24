----------------------------------------------------------------------
-- Fichero: ALUMIPSTb.vhd
-- Descripción: Testbench para la ALU del microprocesador MIPS
-- Fecha última modificación: 2016-02-29 

-- Autores: Alberto Sánchez (2010, 2012, 2013, 2016),
-- Fernando López Colino (2010),
-- Ángel de Castro (2009, 2014, 2015),
-- Sergio López-Buedo (2005), Juán González (2005)
-- Asignatura: E.C. 1º grado
-- Grupo de Prácticas:
-- Grupo de Teoría:
-- Práctica: 3
-- Ejercicio: 1
----------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ALUMIPSTb is
end ALUMIPSTb;

architecture Practica of ALUMIPSTb is

	component ALUMIPS
	port(
   		Op1 : in std_logic_vector (31 downto 0);
		Op2 : in std_logic_vector (31 downto 0);
		ALUControl : in std_logic_vector (2 downto 0);
		Res : out std_logic_vector (31 downto 0);
--		N : out std_logic;
--		V : out std_logic;
		Z : out std_logic
--		C : out std_logic
	);
	end component;

	signal op1 : std_logic_vector(31 downto 0);
	signal op2 : std_logic_vector(31 downto 0);
	signal ALUControl : std_logic_vector(2 downto 0);
	signal res : std_logic_vector(31 downto 0);
	--signal n : std_logic;
	--signal v : std_logic;
	signal z : std_logic;
	--signal c : std_logic;

	--
	-- tipos y constantes necesarios para guardar las matrices de casos de prueba
	-- estructura de datos

	-----------------------------------------------------------------------------
	-- Para hacer las pruebas, se definen una serie de casos de prueba. Es un
	-- registro que contiene los operadores y los resultados que se deberian
	-- obtener para diferentes operaciones y sus flags
	-----------------------------------------------------------------------------

	type CASOSPRUEBAt is record
		op1 : std_logic_vector(31 downto 0);
		op2 : std_logic_vector(31 downto 0);
		flagsAdd : std_logic_vector(3 downto 0);
		resAdd : std_logic_vector(31 downto 0);
		flagsAnd : std_logic_vector(3 downto 0);
		resAnd : std_logic_vector(31 downto 0);
		flagsOr : std_logic_vector(3 downto 0);
		resOr : std_logic_vector(31 downto 0);
		flagsXor : std_logic_vector(3 downto 0); 
		resXor :  std_logic_vector(31 downto 0);
		flagsSub : std_logic_vector(3 downto 0);
		resSub: std_logic_vector(31 downto 0);
		flagsNor : std_logic_vector(3 downto 0);
		resNor : std_logic_vector(31 downto 0);
		flagsSl : std_logic_vector(3 downto 0);
		resSl : std_logic_vector(31 downto 0); -- shift left
		flagsSrl : std_logic_vector(3 downto 0);
		resSrl : std_logic_vector(31 downto 0); -- shift right logic
		flagsSra : std_logic_vector(3 downto 0);
		resSra : std_logic_vector(31 downto 0); -- shift right arithmetic 
		resNand : std_logic_vector(31 downto 0);
		flagsNand : std_logic_vector (3 downto 0);
		resSlt : std_logic_vector(31 downto 0);
		flagsSlt : std_logic_vector(3 downto 0);
	end record;

	-- Cuidado con los desplazamientos: en ARC se desplaza Op1 y en MIPS se desplaza Op2.
	-- Este test-bench comprueba shift left según el criterio MIPS, pero los otros según ARC
	
	-- Número de casos de prueba
	constant NUMCASOSPRUEBA : integer := 20;

  -- matriz de casos de prueba
  type CASOSPRUEBAa is array (1 to NUMCASOSPRUEBA) of CASOSPRUEBAt;
  
  -- Orden de los datos a continuación:
  -- FLAGS: NZCV          
  -- OPERACIONES: add and or nor srl
	constant casosPrueba : CASOSPRUEBAa :=
	(
		-- 1
		(x"00000000",x"00000000","0100",x"00000000","0100",x"00000000","0100",x"00000000","0100",x"00000000","0100",x"00000000","1000",x"FFFFFFFF","0100",x"00000000","0100",x"00000000","0100",x"00000000",x"FFFFFFFF", "1000", x"00000000", "0100"),
		-- 2
		(x"FFFFFFFF",x"FFFFFFFF","1010",x"FFFFFFFE","1000",x"FFFFFFFF","1000",x"FFFFFFFF","0100",x"00000000","0100",x"00000000","0100",x"00000000","1000",x"80000000","0000",x"00000001","1000",x"FFFFFFFF", x"00000000", "0100", x"00000000", "0100"),
		-- 3
		(x"FFFFFFFF",x"00000000","1000",x"FFFFFFFF","0100",x"00000000","1000",x"FFFFFFFF","1000",x"FFFFFFFF","1000",x"FFFFFFFF","0100",x"00000000","0100",x"00000000","1000",x"FFFFFFFF","1000",x"FFFFFFFF", x"FFFFFFFF", "1000", x"00000001", "0000"),
		-- 4
		(x"00000000",x"FFFFFFFF","1000",x"FFFFFFFF","0100",x"00000000","1000",x"FFFFFFFF","1000",x"FFFFFFFF","0010",x"00000001","0100",x"00000000","1000",x"FFFFFFFF","0100",x"00000000","0100",x"00000000",x"FFFFFFFF", "1000", x"00000000", "0100"),
		-- 5
		(x"55555555",x"AAAAAAAA","1000",x"FFFFFFFF","0100",x"00000000","1000",x"FFFFFFFF","1000",x"FFFFFFFF","1011",x"AAAAAAAB","0100",x"00000000","0000",x"55400000","0000",x"00155555","0000",x"00155555", x"FFFFFFFF", "1000", x"00000000", "0100"),
		-- 6
		(x"AAAAAAAA",x"55555555","1000",x"FFFFFFFF","0100",x"00000000","1000",x"FFFFFFFF","1000",x"FFFFFFFF","0001",x"55555555","0100",x"00000000","0000",x"55555400","0000",x"00000555","1000",x"FFFFFD55", x"FFFFFFFF", "1000", x"00000001", "0000"),
		--7
		(x"FFFF0000",x"0000FFFF","1000",x"FFFFFFFF","0100",x"00000000","1000",x"FFFFFFFF","1000",x"FFFFFFFF","1000",x"FFFE0001","0100",x"00000000","0000",x"0000FFFF","0000",x"00000001","1000",x"FFFFFFFF", x"FFFFFFFF", "1000", x"00000001", "0000"),
		-- 8
		(x"0000FFFF",x"FFFF0000","1000",x"FFFFFFFF","0100",x"00000000","1000",x"FFFFFFFF","1000",x"FFFFFFFF","0010",x"0001FFFF","0100",x"00000000","0100",x"00000000","0000",x"0000FFFF","0000",x"0000FFFF",x"FFFFFFFF", "1000", x"00000000", "0100"),
		-- 9
		(x"0000FFFF",x"0000FFFF","0000",x"0001FFFE","0000",x"0000FFFF","0000",x"0000FFFF","0100",x"00000000","0100",x"00000000","1000",x"FFFF0000","1000",x"80000000","0100",x"00000000","0100",x"00000000", x"FFFF0000", "1000", x"00000000", "0100"),
		-- 10
		(x"FFFF0000",x"FFFF0000","1010",x"FFFE0000","1000",x"FFFF0000","1000",x"FFFF0000","0100",x"00000000","0100",x"00000000","0000",x"0000FFFF","1000",x"FFFF0000","1000",x"FFFF0000","1000",x"FFFF0000", x"0000FFFF", "0000", x"00000000", "0100"),
		-- Algunas pruebas para desbordamientos y acarreos--
		-- 11
		(x"7FFFFFFF",x"00000001","1001",x"80000000","0000",x"00000001","0000",x"7FFFFFFF","0000",x"7FFFFFFE","0000",x"7FFFFFFE","1000",x"80000000","1000",x"80000000","0000",x"3FFFFFFF","0000",x"3FFFFFFF", x"FFFFFFFE", "1000", x"00000000", "0100"),
		-- 12
		(x"00000001",x"7FFFFFFF","1001",x"80000000","0000",x"00000001","0000",x"7FFFFFFF","0000",x"7FFFFFFE","1010",x"80000002","1000",x"80000000","1000",x"FFFFFFFE","0100",x"00000000","0100",x"00000000", x"FFFFFFFE", "1000", x"00000001", "0000"),
		-- 13
		(x"80000000",x"FFFFFFFF","0011",x"7FFFFFFF","1000",x"80000000","1000",x"FFFFFFFF","0000",x"7FFFFFFF","1010",x"80000001","0100",x"00000000","1000",x"FFFFFFFF","0000",x"00000001","1000",x"FFFFFFFF", x"7FFFFFFF", "0000", x"00000001", "0000"),
		-- 14
		(x"FFFFFFFF",x"80000000","0011",x"7FFFFFFF","1000",x"80000000","1000",x"FFFFFFFF","0000",x"7FFFFFFF","0000",x"7FFFFFFF","0100",x"00000000","0100",x"00000000","1000",x"FFFFFFFF","1000",x"FFFFFFFF",x"7FFFFFFF", "0000", x"00000000", "0100"),
		-- 15
		(x"65F3B6AE",x"48F6DAC6","1001",x"AEEA9174","0000",x"40F29286","0000",x"6DF7FEEE","0000",x"2D056C68","0000",x"1CFCDBE8","1000",x"92080111","1000",x"B6B18000","0000",x"0197CEDA","0000",x"0197CEDA", x"BF0D6D79","1000", x"00000000", "0100"),
		-- 16
		(x"A8D93BA0",x"D575AF41","0011",x"7E4EEAE1","1000",x"80512B00","1000",x"FDFDBFE1","0000",x"7DAC94E1","1010",x"D3638C5F","0000",x"0202401E","1000",x"D575AF41","0000",x"546C9DD0","1000",x"D46C9DD0", x"7FAED4FF","0000", x"00000001", "0000"),
		-- 17
		(x"3A361FBD",x"27F5AA09","0000",x"622BC9C6","0000",x"22340A09","0000",x"3FF7BFBD","0000",x"1DC3B5B4","0000",x"124075B4","1000",x"C0084042","0000",x"20000000","0000",x"001D1B0F","0000",x"001D1B0F",x"DDCBF5F6","1000", x"00000000", "0100"),
		-- 18
		(x"E519AC0D",x"F27D71B6","1010",x"D7971DC3","1000",x"E0192004","1000",x"F77DFDBF","0000",x"1764DDBB","1010",x"F29C3A57","0000",x"08820240","1000",x"AE36C000","0000",x"00000394","1000",x"FFFFFF94",x"1FE6DFFB","0000", x"00000001", "0000"),
		-- Para terminar,un par de pruebas de desplazamientos--
		-- 19
		(x"12345678",x"00000010","0000",x"12345688","0000",x"00000010","0000",x"12345678","0000",x"12345668","0000",x"12345668","1000",x"EDCBA987","0000",x"10000000","0000",x"00001234","0000",x"00001234",x"FFFFFFEF","1000", x"00000000", "0100"),
		-- 20
		(x"FEDCBA98",x"00000008","1000",x"FEDCBAA0","0000",x"00000008","1000",x"FEDCBA98","1000",x"FEDCBA90","1000",x"FEDCBA90","0000",x"01234567","0000",x"08000000","0000",x"00FEDCBA","1000",x"FFFEDCBA", x"FFFFFFF7","1000", x"00000001", "0000")
	);
  
	-- Tiempo que vamos a esperar a que conteste la ALU  
	constant TDELAY : time := 25 ns;

	-- Se añaden flags de funcionamimento para cada operación individual
	signal addFlags : boolean := true;
	signal addRes : boolean := true;
	signal subFlags : boolean := true;
	signal subRes : boolean := true;
	signal orFlags : boolean := true;
	signal orRes : boolean := true;
	signal xorFlags : boolean := true;
	signal xorRes : boolean := true;
	signal sltRes : boolean := true;
	signal sltFlags : boolean := true;
	signal norFlags : boolean := true;
	signal norRes : boolean := true;

begin

	-- Instanciar la ALU
	UUT : ALUMIPS
	port map (
		OP1 => OP1,
		OP2 => OP2,
		RES => RES,
		ALUControl => ALUControl,
--		N => n,
--		V => v,
		Z => z
--		C => c
	);


  -----------------------------------------------------------------------------
  -- Proceso principal de prueba
  -----------------------------------------------------------------------------
	Test : process
		variable nota : integer := 0;
	begin

		-- Repetir para todos los casos de prueba
		for i in 1 to NUMCASOSPRUEBA loop

			-- Introducir los operandos
			OP1 <= casosPrueba(i).op1;
			OP2 <= casosPrueba(i).op2;

			------------------------------------------------------------------------
			-- Prueba de la SUMA
			------------------------------------------------------------------------
			ALUControl <= "010";

			-- Esperar respuesta
			wait for TDELAY;

			-- comprobar que los flags son correctos
			assert casosPrueba(i).flagsAdd(2)=Z 
			report "Fallo en los flags para la suma en el caso " & integer'image(i) 		
			severity note;

			if (casosPrueba(i).flagsAdd(2)/=Z ) then
				addFlags <= false;
			end if;

			-- Comprobar que el resultado es correcto
			assert casosPrueba(i).resAdd=res 
			report "Fallo en el resultado de la suma en el caso " & integer'image(i) 
			severity note;

			if (casosPrueba(i).resAdd/=res) then
				addRes <= false;
			end if;

		 
			-------------------------------------------------------------------------
			-- Prueba de la RESTA
			-------------------------------------------------------------------------
			ALUControl <="110";
			-- Esperar respuesta
			wait for TDELAY; 
			
			-- comprobar que los flags son correctos
			assert casosPrueba(i).flagsSub(2)=Z 
			report "Fallo en los flags para la resta en el caso " & integer'image(i) 		
			severity note;
			
			if (casosPrueba(i).flagsSub(2)/=Z ) then
				subFlags <= false;
			end if;
			
			-- Comprobar que el resultado es correcto
			assert casosPrueba(i).resSub=res 
			report "Fallo en el resultado de la resta en el caso " & integer'image(i) 
			severity note;
			
			if (casosPrueba(i).resSub/=res) then
				subRes <= false;
			end if;

			-------------------------------------------------------------------------
			-- Prueba de la operacion AND
			-------------------------------------------------------------------------
			ALUControl <= "000";

			-- Esperar respuesta
			wait for TDELAY;

			-- Comprobar los flags
			assert casosPrueba(i).flagsAnd(2)=Z 
			report "Fallo en los flags para la or en el caso " & integer'image(i) 
			severity note;

			if (casosPrueba(i).flagsAnd(2)/=Z ) then
				orFlags <= false;
			end if;

			-- Comprobar el resultado
			assert casosPrueba(i).resAnd = res 
			report "Fallo en el resultado de la or en el caso " & integer'image(i) 
			severity note;
			
			if (casosPrueba(i).resAnd/=res) then
				orRes <= false;
			end if;

			-------------------------------------------------------------------------
			-- Prueba de la operacion XOR
			-------------------------------------------------------------------------

			ALUControl <= "011";

			-- Esperar respuesta
			wait for TDELAY;

			-- Comprobar los flags
			assert casosPrueba(i).flagsXor(2)=Z 
			report "Fallo en los flags para la xor en el caso " & integer'image(i) 
			severity note;
			
			if (casosPrueba(i).flagsXor(2)/=Z ) then
				xorFlags <= false;
			end if;

			-- Comprobar el resultado
			assert casosPrueba(i).resXor=res 
			report "fallo en el resultado de la xor en el caso " & integer'image(i) 
			severity note;
			
			if (casosPrueba(i).resXor/=res) then
				xorRes <= false;
			end if;

			
			-------------------------------------------------------------------------
			-- Prueba de la operacion SLT
			-------------------------------------------------------------------------
			ALUControl <= "111";

			-- Esperar respuesta
			wait for TDELAY;

			assert casosPrueba(i).flagsSlt(2)=Z 
			report "Fallo en los flags para slt en el caso " & integer'image(i) 
			severity note;
			
			if (casosPrueba(i).flagsSlt(2)/=Z ) then
				sltFlags <= false;
			end if;

			-- Comprobar los flags
			assert casosPrueba(i).resSlt=res 
			report "Fallo en el resultado del slt en el caso " & integer'image(i) 
			severity note;  
			
			if (casosPrueba(i).resSlt/=res) then
				sltRes <= false;
			end if;
			
			-------------------------------------------------------------------------
			-- Prueba de la operacion NOR
			-------------------------------------------------------------------------
			ALUControl <= "101";

			-- Esperar respuesta
			wait for TDELAY;

			assert casosPrueba(i).flagsNor(2)=Z 
			report "Fallo en los flags para nor en el caso " & integer'image(i) 
			severity note;
			
			if (casosPrueba(i).flagsNor(2)/=Z ) then
				norFlags <= false;
			end if;

			-- Comprobar los flags
			assert casosPrueba(i).resNor=res 
			report "Fallo en el resultado del nor en el caso " & integer'image(i) 
			severity note;  
			
			if (casosPrueba(i).resNor/=res) then
				norRes <= false;
			end if;

		end loop;


		

		-- Llegado este punto, la simulacion ha finalizado
		report "Simulación finalizada. Compruebe si previamente se han generado errores" severity note;

		wait;
	end process test;  

end PRACTICA;
                                               
