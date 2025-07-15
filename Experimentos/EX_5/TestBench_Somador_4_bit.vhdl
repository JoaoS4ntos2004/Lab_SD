LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;  

ENTITY TB_SOMADOR4BIT IS
END ENTITY TB_SOMADOR4BIT;

ARCHITECTURE TB_SOMADOR4BIT_ARCH OF TB_SOMADOR4BIT IS
  SIGNAL A, B : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL S    : STD_LOGIC_VECTOR(4 DOWNTO 0);
BEGIN
  UUT: ENTITY work.SOMADOR4BIT
    PORT MAP (
      A => A,
      B => B,
      S => S
    );

  stim_proc: PROCESS
    VARIABLE Ai, Bi       : INTEGER;
    VARIABLE S_int, exp_int : INTEGER;
  BEGIN
    FOR Ai IN 0 TO 15 LOOP
      FOR Bi IN 0 TO 15 LOOP
        A <= std_logic_vector(to_unsigned(Ai, 4));
        B <= std_logic_vector(to_unsigned(Bi, 4));
        WAIT FOR 500 ns;

        S_int   := to_integer(unsigned(S));
        exp_int := Ai + Bi;

        ASSERT S_int = exp_int
          REPORT "Erro em A=" & INTEGER'IMAGE(Ai) &
                 " B=" & INTEGER'IMAGE(Bi) &
                 " : S=" & INTEGER'IMAGE(S_int) &
                 " esperado=" & INTEGER'IMAGE(exp_int)
          SEVERITY ERROR;
      END LOOP;
    END LOOP;

    REPORT "Teste concluído sem erros." SEVERITY NOTE;
    WAIT;  
  END PROCESS stim_proc;

END ARCHITECTURE TB_SOMADOR4BIT_ARCH;
