library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Bitwise logic unit: computes all four logic results in parallel.
-- The ALU output mux picks the one it needs.

entity alu_logic_unit is
    Port ( A       : in  STD_LOGIC_VECTOR (7 downto 0);
           B       : in  STD_LOGIC_VECTOR (7 downto 0);
           AND_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           OR_OUT  : out STD_LOGIC_VECTOR (7 downto 0);
           XOR_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           NOT_OUT : out STD_LOGIC_VECTOR (7 downto 0));   -- NOT A
end alu_logic_unit;

architecture Structural of alu_logic_unit is

    component and_gate
        Port ( A : in  STD_LOGIC;
               B : in  STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    component or_gate
        Port ( A : in  STD_LOGIC;
               B : in  STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    component xor_gate
        Port ( A : in  STD_LOGIC;
               B : in  STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    component not_gate
        Port ( A : in  STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

begin

    GEN_LOGIC: for i in 0 to 7 generate
        U_AND: and_gate port map ( A => A(i), B => B(i), Y => AND_OUT(i) );
        U_OR:  or_gate  port map ( A => A(i), B => B(i), Y => OR_OUT(i)  );
        U_XOR: xor_gate port map ( A => A(i), B => B(i), Y => XOR_OUT(i) );
        U_NOT: not_gate port map ( A => A(i),            Y => NOT_OUT(i) );
    end generate GEN_LOGIC;

end Structural;
