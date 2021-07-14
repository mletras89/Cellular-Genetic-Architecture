-- Company : FAU
-- Author: Martin Letras
-- Test bench for mutation
--

use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_griewank is
end entity;

architecture arch of tb_griewank is

signal input1   : std_logic_vector(15 downto 0);
signal input2   : std_logic_vector(15 downto 0);
signal output   : std_logic_vector(15 downto 0);

 -- declare record type
    type test_vector is record
        input1   : std_logic_vector(15 downto 0);
        input2   : std_logic_vector(15 downto 0);
        output   : std_logic_vector(15 downto 0);
    end record;

    type test_vector_array is array (natural range <>) of test_vector;

constant test_vectors : test_vector_array := (
        (x"FFFF", x"eeee", x"0069"),
        (x"BBBB", x"cccc", x"05cf"),
        (x"CCCC", x"dddd", x"0335"),
        (x"0000", x"ffff", x"000d"),
        (x"00ff", x"0000", x"0043"),
        (x"0fff", x"1111", x"009f")
        );

begin
    inst_ratrigin: entity work.Rastrigin
  	PORT MAP
	(    In1 => input1,
             In3 => input2,
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

--            assert (output = test_vectors(i).output)

            -- image is used for string-representation of integer etc.
--            report  "test_vector, outputs are not correct!!!" severity error;
        end loop;

        -- End simulation.
        report "End testbench";

    wait;
    end process;

end architecture;
