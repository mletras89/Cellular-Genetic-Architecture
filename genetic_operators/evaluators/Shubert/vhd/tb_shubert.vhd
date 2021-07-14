-- Company : FAU
-- Author: Martin Letras
-- Test bench for mutation
--

use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_shubert is
end entity;

architecture arch of tb_shubert is

signal input1   : std_logic_vector(15 downto 0);
signal input2   : std_logic_vector(15 downto 0);
signal output   : std_logic_vector(31 downto 0);

 -- declare record type
    type test_vector is record
        input1   : std_logic_vector(15 downto 0);
        input2   : std_logic_vector(15 downto 0);
        output   : std_logic_vector(31 downto 0);
    end record;

    type test_vector_array is array (natural range <>) of test_vector;

constant test_vectors : test_vector_array := (
        (x"FFFF", x"eeee", x"ffe3f85a"),
        (x"BBBB", x"cccc", x"0000a251"),
        (x"CCCC", x"dddd", x"0003a8e1"),
        (x"0000", x"ffff", x"00187ea8"),
        (x"00ff", x"0000", x"001094d4"),
        (x"0fff", x"1111", x"0007c2c0")
        );

begin
    inst_shubert: entity work.Approximation
  	PORT MAP
	(    In1 => input1,
             In2 => input2,
	     Out1 => output 
        );

    -- Main simulation process.
    process is
    begin
        report "Start test bench";
        wait for 30 ns;

        for i in test_vectors'range loop
        --for i in 0 to 3 loop
            input1 <= test_vectors(i).input1;
            input2 <= test_vectors(i).input2;

            wait for 20 ns;

            --assert (output = test_vectors(i).output)

            -- image is used for string-representation of integer etc.
            --report  "test_vector, outputs are not correct!!!" severity error;
        end loop;

        -- End simulation.
        report "End testbench";

    wait;
    end process;

end architecture;
