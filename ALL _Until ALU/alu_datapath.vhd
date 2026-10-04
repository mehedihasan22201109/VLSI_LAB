library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ALU datapath: connects the ALU to the project's registers.
--
--            +-------+
--  DATA_IN ->| REG A |--+
--            +-------+  |   +---------+     +-------+
--            +-------+  +-->|         |---->| REG R |--> R_OUT
--  DATA_IN ->| REG B |----->| alu_8bit|     +-------+
--            +-------+      |  (OP)   |---->[Z C N V flag regs]
--                           +---------+
--
-- Usage (one clock edge per step):
--   1. LOAD_A = 1 with the first operand on DATA_IN
--   2. LOAD_B = 1 with the second operand on DATA_IN
--   3. Set OP, LOAD_R = 1  -> result and flags are captured on the next edge
-- RESET is synchronous, active-high, and clears every register.
-- (Give the design one clock edge with RESET = 1 before using it.)

entity alu_datapath is
    Port ( CLK     : in  STD_LOGIC;
           RESET   : in  STD_LOGIC;
           DATA_IN : in  STD_LOGIC_VECTOR (7 downto 0);
           LOAD_A  : in  STD_LOGIC;
           LOAD_B  : in  STD_LOGIC;
           LOAD_R  : in  STD_LOGIC;                       -- result + flags
           OP      : in  STD_LOGIC_VECTOR (2 downto 0);
           A_OUT   : out STD_LOGIC_VECTOR (7 downto 0);
           B_OUT   : out STD_LOGIC_VECTOR (7 downto 0);
           R_OUT   : out STD_LOGIC_VECTOR (7 downto 0);
           Z_OUT   : out STD_LOGIC;
           C_OUT   : out STD_LOGIC;
           N_OUT   : out STD_LOGIC;
           V_OUT   : out STD_LOGIC);
end alu_datapath;

architecture Structural of alu_datapath is

    component register_8bit
        Port ( CLK   : in  STD_LOGIC;
               RESET : in  STD_LOGIC;
               LOAD  : in  STD_LOGIC;
               D     : in  STD_LOGIC_VECTOR (7 downto 0);
               Q     : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    component register_1bit
        Port ( CLK   : in  STD_LOGIC;
               RESET : in  STD_LOGIC;
               LOAD  : in  STD_LOGIC;
               D     : in  STD_LOGIC;
               Q     : out STD_LOGIC);
    end component;

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

    signal a_q, b_q, alu_res : STD_LOGIC_VECTOR (7 downto 0);
    signal alu_z, alu_c, alu_n, alu_v : STD_LOGIC;

begin

    -- Operand registers
    REG_A: register_8bit port map ( CLK => CLK, RESET => RESET, LOAD => LOAD_A,
                                    D => DATA_IN, Q => a_q );
    REG_B: register_8bit port map ( CLK => CLK, RESET => RESET, LOAD => LOAD_B,
                                    D => DATA_IN, Q => b_q );

    -- ALU (combinational) between the operand and result registers
    U_ALU: alu_8bit port map ( A => a_q, B => b_q, OP => OP,
                               RESULT => alu_res,
                               FLAG_Z => alu_z, FLAG_C => alu_c,
                               FLAG_N => alu_n, FLAG_V => alu_v );

    -- Result register and flag registers, all loaded by LOAD_R
    REG_R: register_8bit port map ( CLK => CLK, RESET => RESET, LOAD => LOAD_R,
                                    D => alu_res, Q => R_OUT );

    REG_Z: register_1bit port map ( CLK => CLK, RESET => RESET, LOAD => LOAD_R,
                                    D => alu_z, Q => Z_OUT );
    REG_C: register_1bit port map ( CLK => CLK, RESET => RESET, LOAD => LOAD_R,
                                    D => alu_c, Q => C_OUT );
    REG_N: register_1bit port map ( CLK => CLK, RESET => RESET, LOAD => LOAD_R,
                                    D => alu_n, Q => N_OUT );
    REG_V: register_1bit port map ( CLK => CLK, RESET => RESET, LOAD => LOAD_R,
                                    D => alu_v, Q => V_OUT );

    A_OUT <= a_q;
    B_OUT <= b_q;

end Structural;
