library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcd_counter100 is
  port (
    clk       : in  STD_LOGIC;
    reset     : in  STD_LOGIC;
    enable    : in  STD_LOGIC;  -- conta quando '0'
    load      : in  STD_LOGIC;
    D_unidade : in  STD_LOGIC_VECTOR(3 downto 0);
    D_dezena  : in  STD_LOGIC_VECTOR(3 downto 0);
    Q_unidade : out STD_LOGIC_VECTOR(3 downto 0);
    Q_dezena  : out STD_LOGIC_VECTOR(3 downto 0)
  );
end bcd_counter100;

architecture arch of bcd_counter100 is
  signal rco_unidade, rco_dezena : STD_LOGIC;
begin

  U_UNIT: entity work.bcd_counter10
    port map (
      clk    => clk,
      reset  => reset,
      enable => enable,
      rci    => '0',          -- sempre habilitado para unidade
      load   => load,
      D      => D_unidade,
      Q      => Q_unidade,
      rco    => rco_unidade
    );

  -- componente dezena, recebe rco_unidade como rci
  U_DEZ: entity work.bcd_counter10
    port map (
      clk    => clk,
      reset  => reset,
      enable => enable,
      rci    => rco_unidade,  -- cascata
      load   => load,
      D      => D_dezena,
      Q      => Q_dezena,
      rco    => rco_dezena
    );

end architecture arch;

