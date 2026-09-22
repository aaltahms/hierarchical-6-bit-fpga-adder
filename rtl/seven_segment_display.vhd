library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_segment_display is
    port (
        clk   : in  std_logic;
        value : in  std_logic_vector(6 downto 0);
        seg   : out std_logic_vector(6 downto 0);
        an    : out std_logic_vector(7 downto 0)
    );
end entity seven_segment_display;

architecture rtl of seven_segment_display is
    signal refresh_counter : unsigned(19 downto 0) := (others => '0');
    signal digit_select    : std_logic_vector(1 downto 0);
    signal value_integer   : integer range 0 to 127;
    signal hundreds        : integer range 0 to 9;
    signal tens            : integer range 0 to 9;
    signal ones            : integer range 0 to 9;
    signal current_digit   : integer range 0 to 9;
begin
    value_integer <= to_integer(unsigned(value));
    hundreds      <= value_integer / 100;
    tens          <= (value_integer mod 100) / 10;
    ones          <= value_integer mod 10;

    process (clk)
    begin
        if rising_edge(clk) then
            refresh_counter <= refresh_counter + 1;
        end if;
    end process;

    digit_select <= std_logic_vector(refresh_counter(19 downto 18));

    process (digit_select, hundreds, tens, ones)
    begin
        an            <= (others => '1');
        current_digit <= 0;

        case digit_select is
            when "00" =>
                an(0)         <= '0';
                current_digit <= ones;
            when "01" =>
                an(1)         <= '0';
                current_digit <= tens;
            when "10" =>
                an(2)         <= '0';
                current_digit <= hundreds;
            when others =>
                null;
        end case;
    end process;

    process (current_digit)
    begin
        case current_digit is
            when 0      => seg <= "1000000";
            when 1      => seg <= "1111001";
            when 2      => seg <= "0100100";
            when 3      => seg <= "0110000";
            when 4      => seg <= "0011001";
            when 5      => seg <= "0010010";
            when 6      => seg <= "0000010";
            when 7      => seg <= "1111000";
            when 8      => seg <= "0000000";
            when 9      => seg <= "0010000";
            when others => seg <= "1111111";
        end case;
    end process;
end architecture rtl;
