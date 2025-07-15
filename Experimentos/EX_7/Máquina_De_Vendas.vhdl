LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MAQUINA_VENDAS IS
  PORT(
    CLK            : IN  STD_LOGIC;
    ENTRADA        : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);  -- "01"=25¢, "10"=50¢, "11"=cancelar, "00"=sem ação
    LIBERA_PRODUTO : OUT STD_LOGIC;                     -- '1' = libera produto
    DEVOLVE_25     : OUT STD_LOGIC;                     -- '1' = devolve 25 centavos
    DEVOLVE_50     : OUT STD_LOGIC                      -- '1' = devolve 50 centavos
  );
END MAQUINA_VENDAS;

ARCHITECTURE MAQUINA_VENDAS_ARCH OF MAQUINA_VENDAS IS

  TYPE ESTADO_TYPE IS (
    ZERO,           -- R$ 0,00
    VINTE_CINCO,    -- R$ 0,25
    CINQUENTA,      -- R$ 0,50
    SETENTA_CINCO,  -- R$ 0,75
    CEM,            -- ≥ R$ 1,00 (libera produto)
    TROCO25,        -- devolver 25¢
    TROCO50         -- devolver 50¢
  );
  SIGNAL ATUAL, PROXIMO : ESTADO_TYPE;

BEGIN

  PROCESS(CLK)
  BEGIN
    IF rising_edge(CLK) THEN
      ATUAL <= PROXIMO;
    END IF;
  END PROCESS;

  PROCESS(ATUAL, ENTRADA)
  BEGIN
    LIBERA_PRODUTO <= '0';
    DEVOLVE_25     <= '0';
    DEVOLVE_50     <= '0';
    PROXIMO        <= ATUAL;

    CASE ATUAL IS

      WHEN ZERO =>
        CASE ENTRADA IS
          WHEN "01" => PROXIMO <= VINTE_CINCO;
          WHEN "10" => PROXIMO <= CINQUENTA;
          WHEN "11" => PROXIMO <= ZERO;         -- cancelamento sem crédito
          WHEN OTHERS => PROXIMO <= ZERO;
        END CASE;

      WHEN VINTE_CINCO =>
        CASE ENTRADA IS
          WHEN "01" => PROXIMO <= CINQUENTA;    -- 0,25 + 0,25
          WHEN "10" => PROXIMO <= SETENTA_CINCO;-- 0,25 + 0,50
          WHEN "11" => PROXIMO <= TROCO25;      -- cancelar: devolve 25¢
          WHEN OTHERS => PROXIMO <= VINTE_CINCO;
        END CASE;

      WHEN CINQUENTA =>
        CASE ENTRADA IS
          WHEN "01" => PROXIMO <= SETENTA_CINCO;-- 0,50 + 0,25
          WHEN "10" => PROXIMO <= CEM;          -- 0,50 + 0,50 ≥1,00
          WHEN "11" => PROXIMO <= TROCO50;      -- cancelar: devolve 50¢
          WHEN OTHERS => PROXIMO <= CINQUENTA;
        END CASE;

      WHEN SETENTA_CINCO =>
        CASE ENTRADA IS
          WHEN "01" => PROXIMO <= CEM;          -- 0,75 + 0,25 =1,00
          WHEN "10" => PROXIMO <= CEM;          -- 0,75 + 0,50 =1,25
          WHEN "11" => PROXIMO <= TROCO50;      -- cancelar: devolve 50¢ (seguido de devolução de 25¢ em ciclo seguinte)
          WHEN OTHERS => PROXIMO <= SETENTA_CINCO;
        END CASE;

      WHEN CEM =>
        LIBERA_PRODUTO <= '1';                  -- libera produto
        CASE ENTRADA IS
          WHEN "10" => PROXIMO <= TROCO50;      -- troco 50¢
          WHEN "01" => PROXIMO <= TROCO25;      -- troco 25¢
          WHEN OTHERS => PROXIMO <= ZERO;       -- ou sem nova moeda, volta ao início
        END CASE;

      WHEN TROCO25 =>
        DEVOLVE_25 <= '1';                      -- devolve 25¢
        PROXIMO    <= ZERO;

      WHEN TROCO50 =>
        DEVOLVE_50 <= '1';                      -- devolve 50¢
        PROXIMO    <= ZERO;

    END CASE;
  END PROCESS;

END MAQUINA_VENDAS_ARCH;
