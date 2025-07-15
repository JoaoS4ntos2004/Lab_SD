LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY SOMADOR4BIT IS
  PORT (
    A   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    B   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    S   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE SOMADOR4BIT_ARCH OF SOMADOR4BIT  IS
  COMPONENT SOMADOR_COMPLETO
    PORT (
      A, B   : IN  STD_LOGIC;
      Cin    : IN  STD_LOGIC;
      S, Cout: OUT STD_LOGIC
    );
  END COMPONENT;

  SIGNAL C1, C2, C3, C4 : STD_LOGIC;
BEGIN
  U0: somador_completo PORT MAP(A => A(0), B => B(0), Cin => '0',  S => S(0), Cout => C1);
  U1: somador_completo PORT MAP(A => A(1), B => B(1), Cin => C1, S => S(1), Cout => C2);
  U2: somador_completo PORT MAP(A => A(2), B => B(2), Cin => C2, S => S(2), Cout => C3);
  U3: somador_completo PORT MAP(A => A(3), B => B(3), Cin => C3, S => S(3), Cout => C4);
S(4) <= C4;
END ARCHITECTURE;
