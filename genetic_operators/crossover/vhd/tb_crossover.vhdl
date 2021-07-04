--
-- Test bench for PRNG "xoshiro128++".
--

use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_crossover is
end entity;

architecture arch of tb_crossover is

signal chromosome_one : std_logic_vector(63 downto 0);
signal chromosome_two : std_logic_vector(63 downto 0);
signal offspring_one : std_logic_vector(63 downto 0);
signal offspring_two : std_logic_vector(63 downto 0);

 -- declare record type
    type test_vector is record
        ch_one : std_logic_vector(63 downto 0);
        ch_two : std_logic_vector(63 downto 0);
    end record; 

    type test_vector_array is array (natural range <>) of test_vector;

constant test_vectors : test_vector_array := (
        --ch_one, ch_two   -- positional method is used below
        (x"0123456789abcdef", x"0123456789abcdef"),
        (x"aaaaaabbbbbbbbbb", x"cccccccddddddddd"),
        (x"0000000789abcdef", x"0123456789abcdef"),
        (x"0123456789abcdef", x"0123456700000000"),
        (x"1111111789abcdef", x"0123456711111111")
        );

begin
    inst_crossover: entity work.crossover
        GENERIC MAP(
                N => 64)
        PORT MAP(
                chromosome_one => chromosome_one,
                chromosome_two => chromosome_two,
                offspring_one => offspring_one,
                offspring_two => offspring_two);

    -- Main simulation process.
    process is
    begin

        report "Start test bench";

        wait for 30 ns;


        for i in test_vectors'range loop
        --for i in 0 to 3 loop
            chromosome_one <= test_vectors(i).ch_one; 
            chromosome_two <= test_vectors(i).ch_two;

            wait for 20 ns;
        end loop;

        -- End simulation.
        report "End testbench";

    wait;
    end process;

end architecture;

