library ieee;
use ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity sync_serial_multiplier is 
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
end entity sync_serial_multiplier;

architecture arch_sync_serial_multiplier of sync_serial_multiplier is

component Control_Unit is 
port (
      rst : in std_logic;
      clk : std_logic;
      start : in std_logic;
      finish : in std_logic;
      load_clear : out std_logic;
      shift_enable : out std_logic;
      Control_Done : out std_logic
      );
end component Control_Unit;

component Exec_Unit is 
generic (
         DATA_WIDTH : integer := 4
        );

port (
     clk : in std_logic;
     rst : in std_logic;
     load_clear : in std_logic;
     shift_enable : in std_logic;
     A : in unsigned(DATA_WIDTH - 1 downto 0);
     B : in unsigned(DATA_WIDTH - 1 downto 0);
     finish : out std_logic;
     p : out unsigned(2 * DATA_WIDTH - 1 downto 0)
     );
end component Exec_Unit;

signal load_clear : std_logic;
signal shift_enable : std_logic;
signal finish : std_logic;

begin

U1 : Control_Unit
port map ( 
          rst => rst,
          clk => clk,
          start => start,
          finish => finish, 
          load_clear => load_clear,
          shift_enable => shift_enable,
          Control_Done => done
          );

U2 : Exec_Unit
generic map (
      DATA_WIDTH => DATA_WIDTH     
            )

port map (
          rst => rst,
          clk => clk,
          shift_enable => shift_enable,
          load_clear => load_clear,
          finish => finish,
          A => A,
          B => B,
          p => p
          );
end architecture arch_sync_serial_multiplier;       
  
























 
