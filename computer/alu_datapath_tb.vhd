library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_datapath_tb is
end alu_datapath_tb;

architecture Behavioral of alu_datapath_tb is

    component alu_datapath
        Port ( CLK     : in  STD_LOGIC;
               RESET   : in  STD_LOGIC;
               DATA_IN : in  STD_LOGIC_VECTOR (7 downto 0);
               LOAD_A  : in  STD_LOGIC;
               LOAD_B  : in  STD_LOGIC;
               LOAD_R  : in  STD_LOGIC;
               OP      : in  STD_LOGIC_VECTOR (2 downto 0);
               A_OUT   : out STD_LOGIC_VECTOR (7 downto 0);
               B_OUT   : out STD_LOGIC_VECTOR (7 downto 0);
               R_OUT   : out STD_LOGIC_VECTOR (7 downto 0);
               Z_OUT   : out STD_LOGIC;
               C_OUT   : out STD_LOGIC;
               N_OUT   : out STD_LOGIC;
               V_OUT   : out STD_LOGIC);
    end component;

    signal CLK_tb    : STD_LOGIC := '0';
    signal RESET_tb  : STD_LOGIC := '0';
    signal DATA_tb   : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal LOAD_A_tb : STD_LOGIC := '0';
    signal LOAD_B_tb : STD_LOGIC := '0';
    signal LOAD_R_tb : STD_LOGIC := '0';
    signal OP_tb     : STD_LOGIC_VECTOR (2 downto 0) := "000";
    signal A_tb, B_tb, R_tb : STD_LOGIC_VECTOR (7 downto 0);
    signal Z_tb, C_tb, N_tb, V_tb : STD_LOGIC;

begin

    UUT: alu_datapath port map ( CLK => CLK_tb, RESET => RESET_tb,
                                 DATA_IN => DATA_tb,
                                 LOAD_A => LOAD_A_tb, LOAD_B => LOAD_B_tb,
                                 LOAD_R => LOAD_R_tb, OP => OP_tb,
                                 A_OUT => A_tb, B_OUT => B_tb, R_OUT => R_tb,
                                 Z_OUT => Z_tb, C_OUT => C_tb,
                                 N_OUT => N_tb, V_OUT => V_tb );

    clk_proc: process
    begin
        CLK_tb <= '0'; wait for 10 ns;
        CLK_tb <= '1'; wait for 10 ns;
    end process;

    stim_proc: process
        variable errors : integer := 0;
        variable prev_r : STD_LOGIC_VECTOR (7 downto 0);

        -- Load A, load B, execute OP, then check the registered outputs.
        -- Three clock edges per call.
        procedure run_op (a, b  : in STD_LOGIC_VECTOR (7 downto 0);
                          op    : in STD_LOGIC_VECTOR (2 downto 0);
                          e_res : in STD_LOGIC_VECTOR (7 downto 0);
                          e_z, e_c, e_n, e_v : in STD_LOGIC;
                          name  : in string) is
        begin
            prev_r := R_tb;

            -- Edge 1: load operand A
            DATA_tb <= a; LOAD_A_tb <= '1'; LOAD_B_tb <= '0'; LOAD_R_tb <= '0';
            wait until rising_edge(CLK_tb); wait for 2 ns;
            if A_tb /= a then
                report "FAIL: A not loaded, " & name severity error;
                errors := errors + 1;
            end if;

            -- Edge 2: load operand B
            DATA_tb <= b; LOAD_A_tb <= '0'; LOAD_B_tb <= '1';
            wait until rising_edge(CLK_tb); wait for 2 ns;
            if B_tb /= b or A_tb /= a then
                report "FAIL: B not loaded / A disturbed, " & name severity error;
                errors := errors + 1;
            end if;
            if R_tb /= prev_r then
                report "FAIL: R changed while LOAD_R=0, " & name severity error;
                errors := errors + 1;
            end if;

            -- Edge 3: execute, capture result + flags
            LOAD_B_tb <= '0'; OP_tb <= op; LOAD_R_tb <= '1';
            wait until rising_edge(CLK_tb); wait for 2 ns;
            LOAD_R_tb <= '0';
            if not (R_tb = e_res and Z_tb = e_z and C_tb = e_c and
                    N_tb = e_n and V_tb = e_v) then
                report "FAIL: result/flags, " & name severity error;
                errors := errors + 1;
            end if;
        end procedure;

    begin
        -- Reset everything
        RESET_tb <= '1';
        wait until rising_edge(CLK_tb); wait for 2 ns;
        wait until rising_edge(CLK_tb); wait for 2 ns;
        RESET_tb <= '0';
        if not (A_tb = x"00" and B_tb = x"00" and R_tb = x"00") then
            report "FAIL: reset did not clear registers" severity error;
            errors := errors + 1;
        end if;

        --      A        B       OP      R      Z    C    N    V
        run_op(x"7F", x"01", "000", x"80", '0', '0', '1', '1', "ADD 7F+01");
        run_op(x"05", x"05", "001", x"00", '1', '1', '0', '0', "SUB 05-05");
        run_op(x"03", x"05", "001", x"FE", '0', '0', '1', '0', "SUB 03-05");
        run_op(x"F0", x"3C", "010", x"30", '0', '0', '0', '0', "AND F0&3C");
        run_op(x"F0", x"0F", "011", x"FF", '0', '0', '1', '0', "OR  F0|0F");
        run_op(x"AA", x"55", "100", x"FF", '0', '0', '1', '0', "XOR AA^55");
        run_op(x"0F", x"00", "101", x"F0", '0', '0', '1', '0', "NOT 0F");
        run_op(x"FF", x"00", "110", x"00", '1', '1', '0', '0', "INC FF");
        run_op(x"00", x"00", "111", x"FF", '0', '0', '1', '0', "DEC 00");

        -- Reset overrides everything, flags included
        RESET_tb <= '1';
        wait until rising_edge(CLK_tb); wait for 2 ns;
        RESET_tb <= '0';
        if not (A_tb = x"00" and B_tb = x"00" and R_tb = x"00" and
                Z_tb = '0' and C_tb = '0' and N_tb = '0' and V_tb = '0') then
            report "FAIL: final reset did not clear registers/flags" severity error;
            errors := errors + 1;
        end if;

        if errors = 0 then
            report "PASS: alu_datapath testbench completed" severity note;
        else
            report "FAIL: alu_datapath testbench, errors = " & integer'image(errors)
                   severity error;
        end if;
        wait;
    end process;

end Behavioral;
