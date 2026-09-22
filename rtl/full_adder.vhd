library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
    port (
        a    : in  std_logic;
        b    : in  std_logic;
        cin  : in  std_logic;
        sum  : out std_logic;
        cout : out std_logic
    );
end entity full_adder;

architecture structural of full_adder is
    signal first_sum   : std_logic;
    signal first_carry : std_logic;
    signal second_carry: std_logic;
begin
    first_half : entity work.half_adder
        port map (
            a     => a,
            b     => b,
            sum   => first_sum,
            carry => first_carry
        );

    second_half : entity work.half_adder
        port map (
            a     => first_sum,
            b     => cin,
            sum   => sum,
            carry => second_carry
        );

    cout <= first_carry or second_carry;
end architecture structural;
