library ieee;
use ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_sync_serial_multiplier is
end entity TB_sync_serial_multiplier;

architecture arch_TB_sync_serial_multiplier of TB_sync_serial_multiplier is

constant DATA_WIDTH : integer := 4;

component sync_serial_multiplier is 
generic (
         DATA_WIDTH : integer := 4
        );
port ( 
      clk : in std_logic;
      rst : in std_logic;
      start : in std_logic;
      A : in unsigned(DATA_WIDTH - 1 downto 0);
      B : in unsigned(DATA_WIDTH - 1 downto 0);
      p : out unsigned(2 * DATA_WIDTH - 1 downto 0);
      done : out std_logic
     );
end component sync_serial_multiplier;

signal clk : std_logic := '0';
signal rst : std_logic := '0';
signal start : std_logic;
signal A : unsigned(DATA_WIDTH - 1 downto 0);
signal B : unsigned(DATA_WIDTH - 1 downto 0);
signal p : unsigned(2 * DATA_WIDTH - 1 downto 0);
signal done : std_logic;

begin

U1 : sync_serial_multiplier
generic map (
      DATA_WIDTH => DATA_WIDTH     
            )
port map (
          clk => clk,
          rst => rst,
          start => start, 
          A => A,
          B => B,
          p => p,
          done => done
         );

clk <= not clk after 10 ns;

process
begin 
--reset
rst <= '1';
wait for 20 ns;

rst <= '0';
wait for 30 ns;

--case 1 : 4 * 5 = 20
start <= '1';
A <= "0100";
B <= "0101";
wait for 20 ns;
start <= '0';
wait until done = '1';
assert p = "00010100" report "case 1 Failed" severity error;

wait for 40 ns;

--case 2 : 7 * 3 = 21
start <= '1';
A <= "0111";
B <= "0011";
wait for 20 ns;
start <= '0';
wait until done = '1';
assert p = "00010101" report "case 2 Failed" severity error;

wait for 40 ns;

--case 3 : 15 * 15 = 225
start <= '1';
A <= "1111";
B <= "1111";
wait for 20 ns;
start <= '0';
wait until done = '1';
assert p = "11100001" report "case 3 Failed" severity error;

wait for 40 ns; 

--case 4 : 8 * 0 = 0
start <= '1';
A <= "1000";
B <= "0000";
wait for 20 ns;
start <= '0';
wait until done = '1';
assert p = "00000000" report "case 4 Failed" severity error;

wait for 40 ns;

--case 5 : 6 * 6 = 36;
start <= '1';
A <= "0110";
B <= "0110";
wait for 20 ns;
start <= '0';
wait until done = '1';
assert p = "00100100" report "case 5 Failed" severity error;

wait;
end process;
end architecture arch_TB_sync_serial_multiplier;




