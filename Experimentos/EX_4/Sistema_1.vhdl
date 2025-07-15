
LIBARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY SISTEMA IS
PORT (
        A, B, C : IN STD_LOGIC;
        X, Y    : OUT STD_LOGIC
    );
END SISTEMA;

ARCHITECTURE SISTEMA_ARCH OF SISTEMA IS

COMPONENT PORTA_INV IS
PORT (
            A : IN STD_LOGIC;
            Y : OUT STD_LOGIC
        );
    END COMPONENT;

COMPONENT MUX4X1 IS
PORT (
            S : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            D : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            Y : OUT STD_LOGIC);
 END COMPONENT;

SIGNAL A_NOT, B_NOT, C_NOT : STD_LOGIC;
SIGNAL muxX_in, muxY_in : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL SIG: STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN

INV_A: PORTA_INV PORT MAP (A=>A, Y=>A_NOT);
INV_B: PORTA_INV PORT MAP (A=>B, Y=>B_NOT);
INV_C: PORTA_INV PORT MAP (A=>C, Y=>C_NOT);

SIG <= A & B;

MUXX_IN(0) <= '0';
    MUXX_IN(1) <= C;                    
    MUXX_IN(2) <= C_NOT;            
    MUXX_IN(3) <='1';                  

    MUXX: MUX4X1 PORT MAP (
        S => SIG,
        D => MUXX_IN,
        Y => X
    );

MUXY_IN(0) <= '1';                
    MUXY_IN(1) <= C_NOT;            
    MUXY_IN(2) <= '0';  
    MUXY_IN(3) <= C;              

    MUXY: MUX4X1 PORT MAP (
        S => SIG,
        D => MUXY_IN,
        Y => Y
    );

END SISTEMA_ARCH;
