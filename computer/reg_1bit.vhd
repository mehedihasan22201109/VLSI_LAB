library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- 1-bit register: rising-edge D flip-flop with synchronous reset and load enable.
-- Written as a clocked process, so synthesis infers a real flip-flop
-- (no D latches, no combinatorial loops).
--
--   RESET = 1          -> Q <= 0      (synchronous, active-high, wins over LOAD)
--   RESET = 0, LOAD=1  -> Q <= D
--   RESET = 0, LOAD=0  -> Q holds

entity register_1bit is
    Port (
        CLK   : in  STD_LOGIC;
        RESET : in  STD_LOGIC;   -- synchronous, active-high
        LOAD  : in  STD_LOGIC;   -- load enable
        D     : in  STD_LOGIC;
        Q     : out STD_LOGIC
    );
end register_1bit;

architecture Behavioral of register_1bit is
begin

    process (CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                Q <= '0';
            elsif LOAD = '1' then
                Q <= D;
            end if;
        end if;
    end process;

end Behavioral;
