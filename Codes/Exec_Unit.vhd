library ieee;
use ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Exec_Unit is 
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
end entity Exec_Unit;

architecture arch_Exec_Unit of Exec_Unit is
constant RADIX_WIDTH : integer := 4; --RADIX 16 --> 4 bit
constant NUM_DIGITS : integer := DATA_WIDTH / RADIX_WIDTH; 

--register signals
signal A_reg : unsigned(DATA_WIDTH - 1 downto 0);
signal B_reg : unsigned(DATA_WIDTH - 1 downto 0);
signal ACC_reg : unsigned(2 * DATA_WIDTH - 1 downto 0);
signal digit : integer range 0 to NUM_DIGITS;
signal finish_reg : std_logic;
signal P_reg : unsigned(2 * DATA_WIDTH - 1 downto 0);


--Partial Product signals
signal A_ext : unsigned(DATA_WIDTH + RADIX_WIDTH - 1 downto 0);
signal pp0, pp1, pp2, pp3 : unsigned(DATA_WIDTH + RADIX_WIDTH - 1 downto 0);
signal pp : unsigned(DATA_WIDTH + RADIX_WIDTH - 1 downto 0);

begin 
A_ext <= (DATA_WIDTH + RADIX_WIDTH - 1 downto DATA_WIDTH => '0') & A_reg;

pp0 <= A_ext when B_reg(0) = '1' else (others => '0');
pp1 <= (A_ext sll 1) when B_reg(1) = '1' else (others => '0');
pp2 <= (A_ext sll 2) when B_reg(2) = '1' else (others => '0');
pp3 <= (A_ext sll 3) when B_reg(3) = '1' else (others => '0');

pp <= pp0 + pp1 + pp2 + pp3;

process(clk, rst)
begin

if rst = '1' then
A_reg <= (others => '0');
B_reg <= (others => '0');
digit <= 0;
finish_reg <= '0';

elsif rising_edge(clk) then
finish_reg <= '0';
if load_clear = '1' then
ACC_reg <= (others => '0');
digit <= 0;
A_reg <= A;
B_reg <= B;
 
elsif shift_enable = '1' then
if digit < NUM_DIGITS then
ACC_reg <= ACC_reg + (pp sll (digit * RADIX_WIDTH));
B_reg <= B_reg srl RADIX_WIDTH;
digit <= digit + 1;

if digit + 1 = NUM_DIGITS then
finish_reg <= '1';
P_reg <= ACC_reg + (pp sll (digit * RADIX_WIDTH));
end if;
end if;
end if; 
end if;
end process;

finish <= finish_reg;
p <= p_reg;

end architecture arch_Exec_Unit;


