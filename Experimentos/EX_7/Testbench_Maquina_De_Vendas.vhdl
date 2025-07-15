LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_maquina_vendas IS
END ENTITY;

ARCHITECTURE behavior OF tb_maquina_vendas IS

  COMPONENT MAQUINA_VENDAS
    PORT(
      CLK            : IN  STD_LOGIC;
      ENTRADA        : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      LIBERA_PRODUTO : OUT STD_LOGIC;
      DEVOLVE_25     : OUT STD_LOGIC;
      DEVOLVE_50     : OUT STD_LOGIC
    );
  END COMPONENT;

  SIGNAL clk_tb            : STD_LOGIC := '0';
  SIGNAL entrada_tb        : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL libera_produto_tb : STD_LOGIC;
  SIGNAL devolve_25_tb     : STD_LOGIC;
  SIGNAL devolve_50_tb     : STD_LOGIC;

  CONSTANT CLK_PERIOD : TIME := 20 NS;

BEGIN

  uut: MAQUINA_VENDAS
    PORT MAP (
      CLK            => clk_tb,
      ENTRADA        => entrada_tb,
      LIBERA_PRODUTO => libera_produto_tb,
      DEVOLVE_25     => devolve_25_tb,
      DEVOLVE_50     => devolve_50_tb
    );

  -- clock generator
  clk_process: PROCESS
  BEGIN
    LOOP
      clk_tb <= '0';
      WAIT FOR CLK_PERIOD/2;
      clk_tb <= '1';
      WAIT FOR CLK_PERIOD/2;
    END LOOP;
  END PROCESS;

  stim_proc: PROCESS
  BEGIN
    WAIT FOR 2 * CLK_PERIOD;

    -- 1) venda até 1,00
    entrada_tb <= "01";  WAIT FOR CLK_PERIOD;  -- 0,25
    entrada_tb <= "10";  WAIT FOR CLK_PERIOD;  -- 0,75
    entrada_tb <= "01";  WAIT FOR CLK_PERIOD;  -- chega a 1,00

    -- espera liberação
    WAIT UNTIL libera_produto_tb = '1';
    ASSERT libera_produto_tb = '1'
      REPORT "Falha: produto nao liberado quando total = 1,00" SEVERITY ERROR;

    -- 1a) troco extra 25¢
    entrada_tb <= "01";
    WAIT UNTIL devolve_25_tb = '1';
    ASSERT devolve_25_tb = '1'
      REPORT "Falha: troco 25¢ nao devolvido" SEVERITY ERROR;

    -- 2) cancelamento em 25¢
    entrada_tb <= "01";  WAIT FOR CLK_PERIOD;   -- vai a VINTE_CINCO
    entrada_tb <= "11";
    WAIT UNTIL devolve_25_tb = '1';
    ASSERT devolve_25_tb = '1'
      REPORT "Falha: troco 25¢ nao devolvido no cancelamento" SEVERITY ERROR;

    -- 3) cancelamento em 50¢
    entrada_tb <= "10";  WAIT FOR CLK_PERIOD;   -- vai a CINQUENTA
    entrada_tb <= "11";
    WAIT UNTIL devolve_50_tb = '1';
    ASSERT devolve_50_tb = '1'
      REPORT "Falha: troco 50¢ nao devolvido no cancelamento" SEVERITY ERROR;

    -- 4) venda com 50 + 50
    entrada_tb <= "10";  WAIT FOR CLK_PERIOD;   -- 0,50
    entrada_tb <= "10";  WAIT FOR CLK_PERIOD;   -- 1,00

    -- espera liberação
    WAIT UNTIL libera_produto_tb = '1';
    ASSERT libera_produto_tb = '1'
      REPORT "Falha: produto nao liberado apos 50+50" SEVERITY ERROR;

    -- espera troco 50¢
    WAIT UNTIL devolve_50_tb = '1';
    ASSERT devolve_50_tb = '1'
      REPORT "Falha: troco 50¢ nao devolvido apos liberacao" SEVERITY ERROR;

    -- final
    entrada_tb <= "00";
    WAIT FOR 2*CLK_PERIOD;
    REPORT "Fim do Testbench: Todos os testes completados." SEVERITY NOTE;
    WAIT;
  END PROCESS;

END ARCHITECTURE;

