LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY TB_BCD_COUNTER10 IS
END ENTITY TB_BCD_COUNTER10;

ARCHITECTURE BEHAVIOR OF TB_BCD_COUNTER10 IS

  -- Component Declaration
  COMPONENT BCD_COUNTER10
    PORT (
      CLK    : IN  STD_LOGIC;
      RESET  : IN  STD_LOGIC;
      ENABLE : IN  STD_LOGIC;
      RCI    : IN  STD_LOGIC;
      LOAD   : IN  STD_LOGIC;
      D      : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      Q      : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      RCO    : OUT STD_LOGIC
    );
  END COMPONENT;

  -- Signals
  SIGNAL CLK_TB    : STD_LOGIC := '0';
  SIGNAL RESET_TB  : STD_LOGIC := '0';
  SIGNAL ENABLE_TB : STD_LOGIC := '1';  -- INIBE CONTAGEM
  SIGNAL RCI_TB    : STD_LOGIC := '1';  -- INIBE RIPPLE IN
  SIGNAL LOAD_TB   : STD_LOGIC := '0';
  SIGNAL D_TB      : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL Q_TB      : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL RCO_TB    : STD_LOGIC;

  CONSTANT CLK_PERIOD : TIME := 10 NS;

BEGIN

  -- Instância do UUT
  UUT: BCD_COUNTER10
    PORT MAP (
      CLK    => CLK_TB,
      RESET  => RESET_TB,
      ENABLE => ENABLE_TB,
      RCI    => RCI_TB,
      LOAD   => LOAD_TB,
      D      => D_TB,
      Q      => Q_TB,
      RCO    => RCO_TB
    );

  -- Geração de Clock
  CLK_PROC: PROCESS
  BEGIN
    LOOP
      CLK_TB <= '0';
      WAIT FOR CLK_PERIOD/2;
      CLK_TB <= '1';
      WAIT FOR CLK_PERIOD/2;
    END LOOP;
  END PROCESS CLK_PROC;

  -- Stimulus
  STIM_PROC: PROCESS
  BEGIN
    D_TB    <= "0000";
    LOAD_TB <= '1';
    WAIT FOR CLK_PERIOD;
    LOAD_TB <= '0';
    WAIT FOR CLK_PERIOD;

    -- Reset Síncrono
    RESET_TB <= '1';
    WAIT FOR CLK_PERIOD;
    RESET_TB <= '0';
    WAIT FOR CLK_PERIOD;

    -- Teste de Load Paralelo
    D_TB    <= "0000";  -- CARREGA 0
    LOAD_TB <= '1';
    WAIT FOR CLK_PERIOD;
    LOAD_TB <= '0';
    WAIT FOR CLK_PERIOD;

    -- Habilita Contagem
    ENABLE_TB <= '0';   -- ATIVA CONTAGEM
    RCI_TB    <= '0';   -- HABILITA RIPPLE

    -- Conta 16 ciclos
    FOR I IN 0 TO 15 LOOP
      WAIT FOR CLK_PERIOD;
    END LOOP;

    -- Desabilita Contagem
    ENABLE_TB <= '1';
    RCI_TB    <= '1';

    WAIT FOR 5 * CLK_PERIOD;
    WAIT;  -- Fim da simulação
  END PROCESS STIM_PROC;

END ARCHITECTURE BEHAVIOR; 
