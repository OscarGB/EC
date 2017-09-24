library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;
entity P1e1 is
	port( A: in std_logic;
			B: in std_logic;
			C: in std_logic;
			Q: out std_logic);
end P1e1;

architecture comport of P1e1 is
	signal S : std_logic;
begin
	S <= A or B;
	Q <= S and C;
end comport;