----------------------------------------------------------------------------------
-- Company: INAOE
-- Engineer: Martin Letras
-- 
-- Create Date:    18:00:41 08/26/2014 
-- Design Name:  Processor Array for Implementing 2D/3D Cellular Genetic Algorithm
-- Module Name:   anysotropic_selection - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--     Entitty that performs the anysotropic selection for a Genetic Algorithm
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_crossover is
end entity;

architecture arch of tb_crossover is

signal north             : std_logic_vector(63 downto 0);
signal south             : std_logic_vector(63 downto 0);
signal random_number     : std_logic_vector(63 downto 0);
signal east              : std_logic_vector(63 downto 0);
signal back              : std_logic_vector(63 downto 0);
signal front             : std_logic_vector(63 downto 0);
signal west              : std_logic_vector(63 downto 0);
signal sel_chromosome    : std_logic_vector(63 downto 0);

 -- declare record type
    type test_vector is record
        north         : std_logic_vector(63 downto 0);
        south         : std_logic_vector(63 downto 0);
        east          : std_logic_vector(63 downto 0);
        west          : std_logic_vector(63 downto 0);
        back          : std_logic_vector(63 downto 0);
        front         : std_logic_vector(63 downto 0);
        random_number : std_logic_vector(63 downto 0); 
    end record;

    type test_vector_array is array (natural range <>) of test_vector;
constant test_vectors : test_vector_array := (
        --ch_one, ch_two, rand_number, mut_c1, mut_c2   -- positional method is used below
        (x"0123456789abcdef", x"0122256789abcdef", x"0000000000000101", x"0123456744abcded", x"0111456789abccff", x"0cc3456789abcdff", x"00000000000000f0"),
        (x"aaaaaabbbbbbbbbb", x"cccccccddddddddd", x"0000000000000000", x"aaaccabbbbbbbbba", x"ccccaacddddddddc", x"012aa56789abcdff", x"0000000000000101"),
        (x"0000000789abcdef", x"0123456789abcdef", x"000000000000ffff", x"8000000789abcdef", x"812345678aaacdef", x"012345bb89abcdff", x"0000000000000118"),
        (x"0123456789abcdef", x"0123456700000000", x"000000000000aaaa", x"0123416ff9abcdef", x"0aa3416700000000", x"012345678ddbcdff", x"0000000000000334"),
        (x"1111111789abcdef", x"0123456711111111", x"000000000000bbbb", x"1911111789abcdef", x"0123056711111111", x"012345678aabcdff", x"000000000000044f")
        );

begin
    inst_mutatiobn: entity work.anisotropic_selection
        GENERIC MAP(
                N => 64)
        PORT MAP(
                random_number => random_number,
                north => north,
                south => south,
                east => east,
                west => west,
                back => back,
                front => front,
                sel_chromosome => sel_chromosome);

    -- Main simulation process.
    process is
    begin

        report "Start test bench";

        wait for 30 ns;
       for i in test_vectors'range loop
        --for i in 0 to 3 loop
            random_number   <= test_vectors(i).random_number;
            north           <= test_vectors(i).north;
            south           <= test_vectors(i).south;
            east            <= test_vectors(i).east;
            west            <= test_vectors(i).west;
            back            <= test_vectors(i).back;
            front           <= test_vectors(i).front;

            wait for 20 ns;

        end loop;

        -- End simulation.
        report "End testbench";

    wait;
    end process;

end architecture;

