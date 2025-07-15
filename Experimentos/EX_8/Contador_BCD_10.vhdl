library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcd_counter10 is
  port (
    clk    : in  STD_LOGIC;
    reset  : in  STD_LOGIC;
    enable : in  STD_LOGIC;  
    rci    : in  STD_LOGIC;  -- ripple carry-in
    load   : in  STD_LOGIC;
    D      : in  STD_LOGIC_VECTOR(3 downto 0);
    Q      : out STD_LOGIC_VECTOR(3 downto 0);
    rco    : out STD_LOGIC      -- ripple carry-out: '0' em 9, '1' caso contrário
  );
end bcd_counter10;

architecture arch of bcd_counter10 is
  type state_type is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9);
  signal currentState, nextState, loadState : state_type;
begin

  -- define o estado de load a partir de D
  with D select
    loadState <=
      S0 when "0000",
      S1 when "0001",
      S2 when "0010",
      S3 when "0011",
      S4 when "0100",
      S5 when "0101",
      S6 when "0110",
      S7 when "0111",
      S8 when "1000",
      S9 when "1001",
      S0 when others;

  sync_proc: process(clk)
  begin
    if rising_edge(clk) then
      currentState <= nextState;
    end if;
  end process sync_proc;

  -- lógica de transição e saídas 
  comb_proc: process(currentState, reset, enable, rci, load, loadState)
  begin
    case currentState is
      when S0 => Q <= "0000"; rco <= '1';
      when S1 => Q <= "0001"; rco <= '1';
      when S2 => Q <= "0010"; rco <= '1';
      when S3 => Q <= "0011"; rco <= '1';
      when S4 => Q <= "0100"; rco <= '1';
      when S5 => Q <= "0101"; rco <= '1';
      when S6 => Q <= "0110"; rco <= '1';
      when S7 => Q <= "0111"; rco <= '1';
      when S8 => Q <= "1000"; rco <= '1';
      when S9 => Q <= "1001"; rco <= '0';
    end case;

    -- prioridade: reset > load > contagem > espera
    if reset = '1' then
      nextState <= S0;
    elsif load = '1' then
      nextState <= loadState;
    elsif (enable = '0') and (rci = '0') then
      case currentState is
        when S0 => nextState <= S1;
        when S1 => nextState <= S2;
        when S2 => nextState <= S3;
        when S3 => nextState <= S4;
        when S4 => nextState <= S5;
        when S5 => nextState <= S6;
        when S6 => nextState <= S7;
        when S7 => nextState <= S8;
        when S8 => nextState <= S9;
        when S9 => nextState <= S0;
      end case;
    else
      nextState <= currentState;
    end if;
  end process comb_proc;

end architecture arch;
