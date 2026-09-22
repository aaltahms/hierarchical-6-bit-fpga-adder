library ieee;
use ieee.std_logic_1164.all;

entity ripple_carry_adder is
    generic (
        n : positive := 6
    );
    port (
        a    : in  std_logic_vector(n - 1 downto 0);
        b    : in  std_logic_vector(n - 1 downto 0);
        cin  : in  std_logic;
        sum  : out std_logic_vector(n - 1 downto 0);
        cout : out std_logic
    );
end entity ripple_carry_adder;

architecture structural of ripple_carry_adder is
    signal carry : std_logic_vector(n downto 0);
begin
    carry(0) <= cin;

    generated_adders : for i in 0 to n - 1 generate
        bit_adder : entity work.full_adder
            port map (
                a    => a(i),
                b    => b(i),
                cin  => carry(i),
                sum  => sum(i),
                cout => carry(i + 1)
            );
    end generate generated_adders;

    cout <= carry(n);
end architecture structural;
