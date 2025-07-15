LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_reg_bidirecional_4b IS
END tb_reg_bidirecional_4b;

ARCHITECTURE behavior OF tb_reg_bidirecional_4b IS

  COMPONENT REG_BIDIRECIONAL_4B
    PORT (
      CLOCK    : IN  STD_LOGIC;
      RESET    : IN  STD_LOGIC;
      LOAD     : IN  STD_LOGIC;
      DADOS    : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      DIRECAO  : IN  STD_LOGIC;
      DADO_ESQ : IN  STD_LOGIC;
      DADO_DIR : IN  STD_LOGIC;
      SAIDAS   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL CLOCK_s    : STD_LOGIC := '0';
  SIGNAL RESET_s    : STD_LOGIC := '0';
  SIGNAL LOAD_s     : STD_LOGIC := '0';
  SIGNAL DADOS_s    : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
  SIGNAL DIRECAO_s  : STD_LOGIC := '0';
  SIGNAL DADO_ESQ_s : STD_LOGIC := '0';
  SIGNAL DADO_DIR_s : STD_LOGIC := '0';
  SIGNAL SAIDAS_s   : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

  DUT: REG_BIDIRECIONAL_4B
    PORT MAP (
      CLOCK    => CLOCK_s,
      RESET    => RESET_s,
      LOAD     => LOAD_s,
      DADOS    => DADOS_s,
      DIRECAO  => DIRECAO_s,
      DADO_ESQ => DADO_ESQ_s,
      DADO_DIR => DADO_DIR_s,
      SAIDAS   => SAIDAS_s
    );

  clk_gen: PROCESS
  BEGIN
    LOOP
      CLOCK_s <= '0'; WAIT FOR 5 ns;
      CLOCK_s <= '1'; WAIT FOR 5 ns;
    END LOOP;
  END PROCESS clk_gen;

  stim_proc: PROCESS
  BEGIN
    RESET_s <= '1';
    WAIT UNTIL rising_edge(CLOCK_s);
    RESET_s <= '0';
    WAIT UNTIL rising_edge(CLOCK_s);
    WAIT FOR 1 ns; 
    DADOS_s <= "1010";   
    LOAD_s  <= '1';
    WAIT UNTIL rising_edge(CLOCK_s);
    LOAD_s  <= '0';
    WAIT UNTIL rising_edge(CLOCK_s);

    DIRECAO_s  <= '0';   
    DADO_ESQ_s <= '1';    
    WAIT UNTIL rising_edge(CLOCK_s);
    WAIT UNTIL rising_edge(CLOCK_s);

    DIRECAO_s  <= '1';   
    DADO_DIR_s <= '0';   
    WAIT UNTIL rising_edge(CLOCK_s);
    WAIT UNTIL rising_edge(CLOCK_s);

    DIRECAO_s  <= '0';
    DADO_ESQ_s <= '0';
    DADO_DIR_s <= '0';
    WAIT UNTIL rising_edge(CLOCK_s);
    WAIT UNTIL rising_edge(CLOCK_s);

    WAIT;
  END PROCESS stim_proc;

END behavior;
