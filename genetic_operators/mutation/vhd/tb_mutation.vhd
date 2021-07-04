-- Company : FAU
-- Author: Martin Letras
-- Test bench for mutation
--

use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_crossover is
end entity;

architecture arch of tb_crossover is

signal chromosome_one    : std_logic_vector(63 downto 0);
signal chromosome_two    : std_logic_vector(63 downto 0);
signal random_number     : std_logic_vector(63 downto 0);
signal mutated_chrom_one : std_logic_vector(63 downto 0);
signal mutated_chrom_two : std_logic_vector(63 downto 0);

 -- declare record type
    type test_vector is record
        ch_one      : std_logic_vector(63 downto 0);
        ch_two      : std_logic_vector(63 downto 0);
        rand_number : std_logic_vector(63 downto 0);
        mut_c1 : std_logic_vector(63 downto 0);
        mut_c2 : std_logic_vector(63 downto 0);
    end record;

    type test_vector_array is array (natural range <>) of test_vector;

constant test_vectors : test_vector_array := (
        --ch_one, ch_two, rand_number, mut_c1, mut_c2   -- positional method is used below
        (x"0123456789abcdef", x"0123456789abcdef", x"0000000000000101", x"0123456789abcded", x"0123456789abcdff"),
        (x"aaaaaabbbbbbbbbb", x"cccccccddddddddd", x"0000000000000000", x"aaaaaabbbbbbbbba", x"cccccccddddddddc"),
        (x"0000000789abcdef", x"0123456789abcdef", x"000000000000ffff", x"8000000789abcdef", x"8123456789abcdef"),
        (x"0123456789abcdef", x"0123456700000000", x"000000000000aaaa", x"0123416789abcdef", x"0123416700000000"),
        (x"1111111789abcdef", x"0123456711111111", x"000000000000bbbb", x"1911111789abcdef", x"0123056711111111")
        --(x"1111111789abcdef", x"0123456711111111", x"000000000000bbbb", x"1911111789abcdef", x"0123056711111100")
        );

begin
    inst_mutatiobn: entity work.mutation
        GENERIC MAP(
                N => 64)
        PORT MAP(
                chromosome_one => chromosome_one,
                chromosome_two => chromosome_two,
                random_number  => random_number,
                NewChrom_1 => mutated_chrom_one,
                NewChrom_2 => mutated_chrom_two);

    -- Main simulation process.
    process is
    begin

        report "Start test bench";

        wait for 30 ns;


        for i in test_vectors'range loop
        --for i in 0 to 3 loop
            chromosome_one <= test_vectors(i).ch_one;
            chromosome_two <= test_vectors(i).ch_two;
            random_number  <= test_vectors(i).rand_number;
            wait for 20 ns;

            assert ( 
                        (mutated_chrom_one = test_vectors(i).mut_c1) and 
                        (mutated_chrom_two = test_vectors(i).mut_c2) 
                    )

            -- image is used for string-representation of integer etc.
            report  "test_vector, outputs are not correct!!!" severity error;
        end loop;

        -- End simulation.
        report "End testbench";

    wait;
    end process;

end architecture;
