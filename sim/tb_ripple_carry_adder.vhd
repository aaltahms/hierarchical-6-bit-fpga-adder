library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ripple_carry_adder is
end entity tb_ripple_carry_adder;

architecture test of tb_ripple_carry_adder is
    constant width : positive := 6;
    signal a       : std_logic_vector(width - 1 downto 0) := (others => '0');
    signal b       : std_logic_vector(width - 1 downto 0) := (others => '0');
    signal cin     : std_logic := '0';
    signal sum     : std_logic_vector(width - 1 downto 0);
    signal cout    : std_logic;
begin
    dut : entity work.ripple_carry_adder
        generic map (
            n => width
        )
        port map (
            a    => a,
            b    => b,
            cin  => cin,
            sum  => sum,
            cout => cout
        );

    stimulus : process
        variable expected : unsigned(width downto 0);
        variable observed : unsigned(width downto 0);
    begin
        for left_operand in 0 to (2 ** width) - 1 loop
            for right_operand in 0 to (2 ** width) - 1 loop
                a   <= std_logic_vector(to_unsigned(left_operand, width));
                b   <= std_logic_vector(to_unsigned(right_operand, width));
                cin <= '0';
                wait for 1 ns;

                expected := to_unsigned(left_operand + right_operand, width + 1);
                observed := unsigned(cout & sum);

                assert observed = expected
                    report "Mismatch for A=" & integer'image(left_operand) &
                           ", B=" & integer'image(right_operand)
                    severity failure;
            end loop;
        end loop;

        cin <= '1';
        for left_operand in 0 to 63 loop
            for right_operand in 0 to 63 loop
                a <= std_logic_vector(to_unsigned(left_operand, width));
                b <= std_logic_vector(to_unsigned(right_operand, width));
                wait for 1 ns;
                assert unsigned(cout & sum) = to_unsigned(left_operand + right_operand + 1, width + 1)
                    report "Carry-in mismatch" severity failure;
            end loop;
        end loop;
        report "PASS: all 8192 six-bit input combinations including both carry-in values" severity note;
        wait;
    end process;
end architecture test;
