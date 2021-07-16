-- Company : FAU
-- Author: Martin Letras
-- Test bench for mutation
--

use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_maxOnes is
end entity;

architecture arch of tb_maxOnes is

signal chromosome    : std_logic_vector(31 downto 0);
signal fit_val       : std_logic_vector(15 downto 0);

 -- declare record type
    type test_vector is record
        ch          : std_logic_vector(31 downto 0);
        fit_val     : std_logic_vector(15 downto 0);
    end record;

    type test_vector_array is array (natural range <>) of test_vector;

constant test_vectors : test_vector_array := (
        --ch_one, ch_two, rand_number, mut_c1, mut_c2   -- positional method is used below
        (x"0000000a",  x"0002"),
        (x"0000000b",  x"0003"),
        (x"0000000c",  x"0002"),
        (x"0000000d",  x"0003"),
        (x"ffffffff",  x"0020"),
        (x"00000003",  x"0002")
        --(x"1111111789abcdef", x"0123456711111111", x"000000000000bbbb", x"1911111789abcdef", x"0123056711111100")
        );

begin
    inst_maxOnes: entity work.evaluator
        GENERIC MAP(
                N => 32,
                M => 16)
        PORT MAP(
                chromosome => chromosome,
                fitness => fit_val);

    -- Main simulation process.
    process is
    begin

        report "Start test bench";

        wait for 30 ns;


        for i in test_vectors'range loop
        --for i in 0 to 3 loop
            chromosome <= test_vectors(i).ch;

            wait for 20 ns;
            assert (fit_val = test_vectors(i).fit_val)
            report  "test_vector, outputs are not correct!!!" severity error;
        end loop;

        -- End simulation.
        report "End testbench";

    wait;
    end process;

end architecture;
