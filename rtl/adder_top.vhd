library ieee;
use ieee.std_logic_1164.all;

entity adder_top is
    port (
        clk : in  std_logic;
        sw  : in  std_logic_vector(15 downto 0);
        led : out std_logic_vector(15 downto 0);
        seg : out std_logic_vector(6 downto 0);
        an  : out std_logic_vector(7 downto 0)
    );
end entity adder_top;

architecture structural of adder_top is
    signal operand_a : std_logic_vector(5 downto 0);
    signal operand_b : std_logic_vector(5 downto 0);
    signal sum       : std_logic_vector(5 downto 0);
    signal cout      : std_logic;
    signal result    : std_logic_vector(6 downto 0);
begin
    operand_a <= sw(5 downto 0);
    operand_b <= sw(11 downto 6);

    led             <= (15 downto 12 => '0') & sw(11 downto 0);
    result          <= cout & sum;

    adder : entity work.ripple_carry_adder
        generic map (
            n => 6
        )
        port map (
            a    => operand_a,
            b    => operand_b,
            cin  => '0',
            sum  => sum,
            cout => cout
        );

    display : entity work.seven_segment_display
        port map (
            clk   => clk,
            value => result,
            seg   => seg,
            an    => an
        );
end architecture structural;
