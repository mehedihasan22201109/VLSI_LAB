library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_8bit_tb is
end alu_8bit_tb;

architecture Behavioral of alu_8bit_tb is

    component alu_8bit
        Port ( A      : in  STD_LOGIC_VECTOR (7 downto 0);
               B      : in  STD_LOGIC_VECTOR (7 downto 0);
               OP     : in  STD_LOGIC_VECTOR (2 downto 0);
               RESULT : out STD_LOGIC_VECTOR (7 downto 0);
               FLAG_Z : out STD_LOGIC;
               FLAG_C : out STD_LOGIC;
               FLAG_N : out STD_LOGIC;
               FLAG_V : out STD_LOGIC);
    end component;

    signal A_tb, B_tb, RES_tb : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal OP_tb              : STD_LOGIC_VECTOR (2 downto 0) := "000";
    signal Z_tb, C_tb, N_tb, V_tb : STD_LOGIC;

    -- Reference model (integer arithmetic, independent of the hardware).
    -- Returns  Z & C & N & V & RESULT  as an 12-bit vector (11 downto 0).
    function ref_alu (a, b : STD_LOGIC_VECTOR (7 downto 0);
                      op   : STD_LOGIC_VECTOR (2 downto 0))
        return STD_LOGIC_VECTOR is
        variable ia, ib, sa, sb : integer;
        variable full, sfull    : integer;
        variable r              : STD_LOGIC_VECTOR (7 downto 0);
        variable z, c, n, v     : STD_LOGIC;
        variable res12          : STD_LOGIC_VECTOR (11 downto 0);
    begin
        ia := to_integer(unsigned(a));
        ib := to_integer(unsigned(b));
        sa := to_integer(signed(a));
        sb := to_integer(signed(b));
        full := 0; sfull := 0; c := '0'; v := '0';

        case op is
            when "000"  => full := ia + ib; sfull := sa + sb;
            when "001"  => full := ia - ib; sfull := sa - sb;
            when "110"  => full := ia + 1;  sfull := sa + 1;
            when "111"  => full := ia - 1;  sfull := sa - 1;
            when others => null;
        end case;

        case op is
            when "000" | "001" | "110" | "111" =>
                r := std_logic_vector(to_unsigned(full mod 256, 8));
                if op = "000" or op = "110" then
                    if full > 255 then c := '1'; end if;   -- carry out
                else
                    if full >= 0 then c := '1'; end if;    -- no borrow
                end if;
                if sfull > 127 or sfull < -128 then v := '1'; end if;
            when "010"  => r := a and b;
            when "011"  => r := a or b;
            when "100"  => r := a xor b;
            when others => r := not a;                     -- "101"
        end case;

        n := r(7);
        if r = "00000000" then z := '1'; else z := '0'; end if;

        res12 := z & c & n & v & r;
        return res12;
    end function;

begin

    UUT: alu_8bit port map ( A => A_tb, B => B_tb, OP => OP_tb,
                             RESULT => RES_tb,
                             FLAG_Z => Z_tb, FLAG_C => C_tb,
                             FLAG_N => N_tb, FLAG_V => V_tb );

    stim_proc: process
        variable errors : integer := 0;
        variable exp12  : STD_LOGIC_VECTOR (11 downto 0);
        variable a_v, b_v : STD_LOGIC_VECTOR (7 downto 0);
        variable op_v   : STD_LOGIC_VECTOR (2 downto 0);

        -- Directed check with hand-computed expected result and flags
        procedure check (a, b   : in STD_LOGIC_VECTOR (7 downto 0);
                         op     : in STD_LOGIC_VECTOR (2 downto 0);
                         e_res  : in STD_LOGIC_VECTOR (7 downto 0);
                         e_z, e_c, e_n, e_v : in STD_LOGIC;
                         name   : in string) is
        begin
            A_tb <= a; B_tb <= b; OP_tb <= op;
            wait for 10 ns;
            if not (RES_tb = e_res and Z_tb = e_z and C_tb = e_c and
                    N_tb = e_n and V_tb = e_v) then
                report "FAIL: " & name severity error;
                errors := errors + 1;
            end if;
        end procedure;

    begin
        wait for 10 ns;

        ------------------------------------------------------------
        -- ADD (000)                        res   Z   C   N   V
        ------------------------------------------------------------
        check(x"00", x"00", "000", x"00", '1', '0', '0', '0', "ADD 00+00");
        check(x"0F", x"01", "000", x"10", '0', '0', '0', '0', "ADD 0F+01");
        check(x"FF", x"01", "000", x"00", '1', '1', '0', '0', "ADD FF+01 (carry)");
        check(x"7F", x"01", "000", x"80", '0', '0', '1', '1', "ADD 7F+01 (signed ovf)");
        check(x"80", x"80", "000", x"00", '1', '1', '0', '1', "ADD 80+80 (carry+ovf)");

        ------------------------------------------------------------
        -- SUB (001)    C = 1 means no borrow
        ------------------------------------------------------------
        check(x"05", x"03", "001", x"02", '0', '1', '0', '0', "SUB 05-03");
        check(x"05", x"05", "001", x"00", '1', '1', '0', '0', "SUB 05-05 (zero)");
        check(x"03", x"05", "001", x"FE", '0', '0', '1', '0', "SUB 03-05 (borrow)");
        check(x"80", x"01", "001", x"7F", '0', '1', '0', '1', "SUB 80-01 (signed ovf)");
        check(x"7F", x"FF", "001", x"80", '0', '0', '1', '1', "SUB 7F-FF");

        ------------------------------------------------------------
        -- AND (010) / OR (011) / XOR (100)  - C and V must be 0
        ------------------------------------------------------------
        check(x"F0", x"3C", "010", x"30", '0', '0', '0', '0', "AND F0&3C");
        check(x"AA", x"55", "010", x"00", '1', '0', '0', '0', "AND AA&55 (zero)");
        check(x"F0", x"0F", "011", x"FF", '0', '0', '1', '0', "OR  F0|0F");
        check(x"00", x"00", "011", x"00", '1', '0', '0', '0', "OR  00|00");
        check(x"AA", x"55", "100", x"FF", '0', '0', '1', '0', "XOR AA^55");
        check(x"FF", x"FF", "100", x"00", '1', '0', '0', '0', "XOR FF^FF (zero)");

        ------------------------------------------------------------
        -- NOT A (101)  - B is ignored
        ------------------------------------------------------------
        check(x"0F", x"AA", "101", x"F0", '0', '0', '1', '0', "NOT 0F");
        check(x"FF", x"00", "101", x"00", '1', '0', '0', '0', "NOT FF (zero)");

        ------------------------------------------------------------
        -- INC (110)  - B is ignored
        ------------------------------------------------------------
        check(x"41", x"FF", "110", x"42", '0', '0', '0', '0', "INC 41");
        check(x"FF", x"00", "110", x"00", '1', '1', '0', '0', "INC FF (wrap)");
        check(x"7F", x"00", "110", x"80", '0', '0', '1', '1', "INC 7F (signed ovf)");

        ------------------------------------------------------------
        -- DEC (111)  - B is ignored;  C = 1 means no borrow
        ------------------------------------------------------------
        check(x"42", x"FF", "111", x"41", '0', '1', '0', '0', "DEC 42");
        check(x"01", x"00", "111", x"00", '1', '1', '0', '0', "DEC 01 (zero)");
        check(x"00", x"00", "111", x"FF", '0', '0', '1', '0', "DEC 00 (wrap)");
        check(x"80", x"00", "111", x"7F", '0', '1', '0', '1', "DEC 80 (signed ovf)");

        ------------------------------------------------------------
        -- Sweep: every operation x 256 A values, compared with the
        -- reference model (fast 100 ps steps so the run fits in 1000 ns)
        ------------------------------------------------------------
        for op_i in 0 to 7 loop
            op_v := std_logic_vector(to_unsigned(op_i, 3));
            for k in 0 to 255 loop
                a_v := std_logic_vector(to_unsigned(k, 8));
                b_v := std_logic_vector(to_unsigned((k * 37 + 91 * op_i + 13) mod 256, 8));
                A_tb <= a_v; B_tb <= b_v; OP_tb <= op_v;
                wait for 100 ps;
                exp12 := ref_alu(a_v, b_v, op_v);
                if not (RES_tb = exp12(7 downto 0) and Z_tb = exp12(11) and
                        C_tb = exp12(10) and N_tb = exp12(9) and V_tb = exp12(8)) then
                    report "FAIL: sweep op=" & integer'image(op_i) &
                           " a=" & integer'image(k) severity error;
                    errors := errors + 1;
                end if;
            end loop;
        end loop;

        ------------------------------------------------------------
        if errors = 0 then
            report "PASS: alu_8bit testbench completed" severity note;
        else
            report "FAIL: alu_8bit testbench, errors = " & integer'image(errors)
                   severity error;
        end if;
        wait;
    end process;

end Behavioral;
