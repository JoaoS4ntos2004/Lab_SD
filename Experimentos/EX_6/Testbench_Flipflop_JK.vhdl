
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_flipflop_jk IS
END tb_flipflop_jk;

ARCHITECTURE behavior OF tb_flipflop_jk IS
  
  COMPONENT FLIPFLOP_JK
    PORT(
      PRESET : IN  STD_LOGIC;
      CLEAR  : IN  STD_LOGIC;
      CLOCK  : IN  STD_LOGIC;
      J      : IN  STD_LOGIC;
      K      : IN  STD_LOGIC;
      SAIDA  : OUT STD_LOGIC
    );
  END COMPONENT;

  
  SIGNAL PRESET_s, CLEAR_s, CLOCK_s, J_s, K_s : STD_LOGIC := '0';
  SIGNAL SAIDA_s                             : STD_LOGIC;
BEGIN

  
  DUT: FLIPFLOP_JK
    PORT MAP (
      PRESET => PRESET_s,
      CLEAR  => CLEAR_s,
      CLOCK  => CLOCK_s,
      J      => J_s,
      K      => K_s,
      SAIDA  => SAIDA_s
    );

  
  clk_gen: PROCESS
  BEGIN
    CLOCK_s <= '0';  
    WAIT FOR 5 ns;
    CLOCK_s <= '1';  
    WAIT FOR 5 ns;
  END PROCESS clk_gen;

  
  stim_proc: PROCESS
  BEGIN
    PRESET_s <= '0';
    CLEAR_s  <= '1';
    J_s      <= '0';
    K_s      <= '0';
    WAIT FOR 20 ns;        
    CLEAR_s <= '0';
    WAIT FOR 10 ns;
    WAIT UNTIL rising_edge(CLOCK_s);
    J_s <= '1'; K_s <= '0';
    WAIT UNTIL rising_edge(CLOCK_s);
    J_s <= '0'; K_s <= '1';

    WAIT UNTIL rising_edge(CLOCK_s);
    J_s <= '1'; K_s <= '1';

    WAIT UNTIL rising_edge(CLOCK_s);
    J_s <= '0'; K_s <= '0';

    PRESET_s <= '1';
    WAIT FOR 20 ns;
    PRESET_s <= '0';

    WAIT; 
  END PROCESS stim_proc;

END behavior;
