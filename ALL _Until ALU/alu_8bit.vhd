library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- 8-bit ALU (combinational, structural - built from the project's own
-- gates, mux2/mux4 and adder_8bit).
--
--   OP   Operation   RESULT
--   000  ADD         A + B
--   001  SUB         A - B          (A + NOT B + 1)
--   010  AND         A and B
--   011  OR          A or B
--   100  XOR         A xor B
--   101  NOT         not A
--   110  INC         A + 1
--   111  DEC         A - 1
--
-- Flags
--   FLAG_Z : RESULT = 00000000
--   FLAG_N : RESULT(7)
--   FLAG_C : carry out of the adder (arithmetic ops only, 0 for logic ops).
--            For SUB / DEC, C = 1 means "no borrow" (A >= B, A >= 1).
--   FLAG_V : signed overflow (arithmetic ops only, 0 for logic ops)

entity alu_8bit is
    Port ( A      : in  STD_LOGIC_VECTOR (7 downto 0);
           B      : in  STD_LOGIC_VECTOR (7 downto 0);
           OP     : in  STD_LOGIC_VECTOR (2 downto 0);
           RESULT : out STD_LOGIC_VECTOR (7 downto 0);
           FLAG_Z : out STD_LOGIC;
           FLAG_C : out STD_LOGIC;
           FLAG_N : out STD_LOGIC;
           FLAG_V : out STD_LOGIC);
end alu_8bit;

architecture Structural of alu_8bit is

    component alu_arith_unit
        Port ( A    : in  STD_LOGIC_VECTOR (7 downto 0);
               B    : in  STD_LOGIC_VECTOR (7 downto 0);
               MODE : in  STD_LOGIC_VECTOR (1 downto 0);
               SUM  : out STD_LOGIC_VECTOR (7 downto 0);
               COUT : out STD_LOGIC;
               OVF  : out STD_LOGIC);
    end component;

    component alu_logic_unit
        Port ( A       : in  STD_LOGIC_VECTOR (7 downto 0);
               B       : in  STD_LOGIC_VECTOR (7 downto 0);
               AND_OUT : out STD_LOGIC_VECTOR (7 downto 0);
               OR_OUT  : out STD_LOGIC_VECTOR (7 downto 0);
               XOR_OUT : out STD_LOGIC_VECTOR (7 downto 0);
               NOT_OUT : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    component mux4
        Port ( D0  : in  STD_LOGIC;
               D1  : in  STD_LOGIC;
               D2  : in  STD_LOGIC;
               D3  : in  STD_LOGIC;
               SEL : in  STD_LOGIC_VECTOR (1 downto 0);
               Y   : out STD_LOGIC);
    end component;

    component mux2
        Port ( D0  : in  STD_LOGIC;
               D1  : in  STD_LOGIC;
               SEL : in  STD_LOGIC;
               Y   : out STD_LOGIC);
    end component;

    component zero_detect_8
        Port ( D : in  STD_LOGIC_VECTOR (7 downto 0);
               Z : out STD_LOGIC);
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

    signal arith_res, and_res, or_res, xor_res, not_res : STD_LOGIC_VECTOR (7 downto 0);
    signal lo_res, hi_res, result_int                   : STD_LOGIC_VECTOR (7 downto 0);
    signal arith_cout, arith_ovf, is_arith              : STD_LOGIC;

begin

    ---------------------------------------------------------------
    -- Functional units (all compute in parallel)
    ---------------------------------------------------------------
    ARITH: alu_arith_unit
        port map ( A => A, B => B, MODE => OP(1 downto 0),
                   SUM => arith_res, COUT => arith_cout, OVF => arith_ovf );

    LOGIC: alu_logic_unit
        port map ( A => A, B => B,
                   AND_OUT => and_res, OR_OUT => or_res,
                   XOR_OUT => xor_res, NOT_OUT => not_res );

    ---------------------------------------------------------------
    -- Result select: 8:1 mux per bit = two mux4 + one mux2
    --   OP(2) = 0 : 000 ADD, 001 SUB, 010 AND, 011 OR
    --   OP(2) = 1 : 100 XOR, 101 NOT, 110 INC, 111 DEC
    ---------------------------------------------------------------
    GEN_RES: for i in 0 to 7 generate
        U_LO: mux4 port map ( D0 => arith_res(i), D1 => arith_res(i),
                              D2 => and_res(i),   D3 => or_res(i),
                              SEL => OP(1 downto 0), Y => lo_res(i) );

        U_HI: mux4 port map ( D0 => xor_res(i),   D1 => not_res(i),
                              D2 => arith_res(i), D3 => arith_res(i),
                              SEL => OP(1 downto 0), Y => hi_res(i) );

        U_SEL: mux2 port map ( D0 => lo_res(i), D1 => hi_res(i),
                               SEL => OP(2), Y => result_int(i) );
    end generate GEN_RES;

    RESULT <= result_int;

    ---------------------------------------------------------------
    -- Flags
    ---------------------------------------------------------------
    -- Arithmetic ops are OP = 000, 001, 110, 111  ->  OP(2) xnor OP(1)
    U_ISARITH: xnor_gate port map ( A => OP(2), B => OP(1), Y => is_arith );

    U_C: and_gate port map ( A => arith_cout, B => is_arith, Y => FLAG_C );
    U_V: and_gate port map ( A => arith_ovf,  B => is_arith, Y => FLAG_V );

    U_Z: zero_detect_8 port map ( D => result_int, Z => FLAG_Z );

    FLAG_N <= result_int(7);

end Structural;
