LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY SISTEMA2 IS
    PORT (
        A, B, C, D, E, F, G : IN STD_LOGIC;
        Z : OUT STD_LOGIC
    );
END SISTEMA2;

ARCHITECTURE SISTEMA2_ARCH OF SISTEMA2 IS

COMPONENT DECODER4X16 IS
        PORT (
            A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            Y : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

COMPONENT MUX8X1 IS
        PORT (
            S : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            D : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            Y : OUT STD_LOGIC
        );
    END COMPONENT;

SIGNAL DECO_IN     : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL DECO_OUT    : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL MUX_IN      : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL SEL         : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL Z_MUX       : STD_LOGIC;
SIGNAL FG          : STD_LOGIC;

BEGIN

DECO_IN <= A & B & C & D;
SEL <= E & F & G;
DEC : DECODER4X16 PORT MAP (
        A => DECO_IN,
        Y => DECO_OUT
    );

MUX_IN(0) <= '0';  
MUX_IN(1) <= DECO_OUT(0) or DECO_OUT(15);
MUX_IN(2) <= DECO_OUT(7);
MUX_IN(3) <= '0';
MUX_IN(4) <= DECO_OUT(12) or DECO_OUT(15);  
MUX_IN(5) <= '0';
MUX_IN(6) <= DECO_OUT(12) or DECO_OUT(13);
MUX_IN(7) <= '0';

MUX : MUX8X1 PORT MAP (
        S => SEL,
        D => MUX_IN,
        Y => Z_MUX
    );

FG <= F AND G;
Z <= FG OR Z_MUX;

END SISTEMA2_ARCH;
