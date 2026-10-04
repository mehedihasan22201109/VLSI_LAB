library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Arithmetic unit: one adder_8bit does all four arithmetic operations
-- by conditioning the B operand and the carry-in:
--
--   MODE  Operation   B fed to adder   CIN
--   00    A + B       B                0
--   01    A - B       NOT B            1     (two's complement)
--   10    A + 1       00000000         1
--   11    A - 1       11111111         0
--
-- CIN = MODE(0) xor MODE(1).
-- OVF is signed overflow: operands have the same sign (A(7) = B_fed(7))
-- but the sum has a different sign.

entity alu_arith_unit is
    Port ( A    : in  STD_LOGIC_VECTOR (7 downto 0);
           B    : in  STD_LOGIC_VECTOR (7 downto 0);
           MODE : in  STD_LOGIC_VECTOR (1 downto 0);
           SUM  : out STD_LOGIC_VECTOR (7 downto 0);
           COUT : out STD_LOGIC;
           OVF  : out STD_LOGIC);
end alu_arith_unit;

architecture Structural of alu_arith_unit is

    component adder_8bit
        Port ( A    : in  STD_LOGIC_VECTOR (7 downto 0);
               B    : in  STD_LOGIC_VECTOR (7 downto 0);
               CIN  : in  STD_LOGIC;
               SUM  : out STD_LOGIC_VECTOR (7 downto 0);
               COUT : out STD_LOGIC);
    end component;

    component mux4
        Port ( D0  : in  STD_LOGIC;
               D1  : in  STD_LOGIC;
               D2  : in  STD_LOGIC;
               D3  : in  STD_LOGIC;
               SEL : in  STD_LOGIC_VECTOR (1 downto 0);
               Y   : out STD_LOGIC);
    end component;

    component not_gate
        Port ( A : in  STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    component xor_gate
        Port ( A : in  STD_LOGIC;
               B : in  STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    component xnor_gate
        Port ( A : in  STD_LOGIC;
               B : in  STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    component and_gate
        Port ( A : in  STD_LOGIC;
               B : in  STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    signal b_inv     : STD_LOGIC_VECTOR (7 downto 0);   -- NOT B
    signal b_fed     : STD_LOGIC_VECTOR (7 downto 0);   -- conditioned B
    signal cin       : STD_LOGIC;
    signal sum_int   : STD_LOGIC_VECTOR (7 downto 0);
    signal same_sign : STD_LOGIC;
    signal sign_chg  : STD_LOGIC;

begin

    -- B operand conditioner: B / NOT B / 0 / 1 chosen per bit by MODE
    GEN_BSEL: for i in 0 to 7 generate
        U_INV: not_gate port map ( A => B(i), Y => b_inv(i) );
        U_MUX: mux4     port map ( D0 => B(i), D1 => b_inv(i),
                                   D2 => '0', D3 => '1',
                                   SEL => MODE, Y => b_fed(i) );
    end generate GEN_BSEL;

    -- Carry-in: 0, 1, 1, 0 for MODE = 00, 01, 10, 11
    U_CIN: xor_gate port map ( A => MODE(0), B => MODE(1), Y => cin );

    -- The existing 8-bit ripple adder does the work
    U_ADD: adder_8bit port map ( A => A, B => b_fed, CIN => cin,
                                 SUM => sum_int, COUT => COUT );

    SUM <= sum_int;

    -- Signed overflow detect
    U_SAME: xnor_gate port map ( A => A(7), B => b_fed(7),   Y => same_sign );
    U_CHG:  xor_gate  port map ( A => A(7), B => sum_int(7), Y => sign_chg  );
    U_OVF:  and_gate  port map ( A => same_sign, B => sign_chg, Y => OVF );

end Structural;
