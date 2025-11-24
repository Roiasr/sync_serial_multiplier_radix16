library ieee;
use ieee.std_logic_1164.ALL;

entity Control_Unit is
port (
      rst : in std_logic;
      clk : std_logic;
      start : in std_logic;
      finish : in std_logic;
      load_clear : out std_logic;
      shift_enable : out std_logic;
      Control_Done : out std_logic
      );
end entity Control_Unit;

architecture arch_Control_Unit of Control_Unit is 
type state is (IDLE, LOAD, EXEC, DONE);
signal present_state, next_state : state;

begin 

state_reg : process(clk, rst)
begin 

if rst = '1' then
present_state <= IDLE;
elsif rising_edge(clk) then
present_state <= next_state;

end if;
end process state_reg; 

Control_Logic : process(present_state, start, finish)
begin

-- default values
load_clear <= '0';
shift_enable<= '0';
Control_Done <= '0';
next_state <= present_state;

case present_state is

when IDLE =>
if start = '1' then
load_clear <= '1';
next_state <= LOAD;
end if;

when LOAD => 
shift_enable <= '1';
next_state <= EXEC;

when EXEC =>
shift_enable <= '1';
if finish = '1' then
Control_Done <= '1';
next_state <= DONE;
else
next_state <= EXEC;
end if;

when DONE =>
Control_Done <= '0';
next_state <= IDLE;

end case;
end process Control_Logic;
end architecture arch_Control_Unit;

