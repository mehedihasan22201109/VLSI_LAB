library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Z = '1' when all 8 input bits are '0'  (8-input NOR as an OR tree + NOT)

entity zero_detect_8 is
    Port ( D : in  STD_LOGIC_VECTOR (7 downto 0);
           Z : out STD_LOGIC);
end zero_detect_8;

architecture Structural of zero_detect_8 is

    component or_gate
        Port ( A : in  STD_LOGIC;
               B : in  STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    component not_gate
        Port ( A : in  STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    signal l1     : STD_LOGIC_VECTOR (3 downto 0);   -- pair ORs
    signal l2     : STD_LOGIC_VECTOR (1 downto 0);   -- nibble ORs
    signal any_one : STD_LOGIC;

begin

    GEN_L1: for i in 0 to 3 generate
        U1: or_gate port map ( A => D(2*i), B => D(2*i+1), Y => l1(i) );
    end generate GEN_L1;

    U2A: or_gate port map ( A => l1(0), B => l1(1), Y => l2(0) );
    U2B: or_gate port map ( A => l1(2), B => l1(3), Y => l2(1) );

    U3:  or_gate  port map ( A => l2(0), B => l2(1), Y => any_one );
    U4:  not_gate port map ( A => any_one, Y => Z );

end Structural;
