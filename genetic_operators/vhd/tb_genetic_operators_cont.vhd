-- Company : FAU
-- Author: Martin Letras
-- Test bench for mutation
--

use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_genetic_operators_cont is
end entity;

architecture arch of tb_genetic_operators_cont is

signal clk       : std_logic;
signal rst       : std_logic;
signal done      : std_logic;
signal valid     : std_logic;

signal north              : std_logic_vector(31 downto 0);
signal south              : std_logic_vector(31 downto 0);
signal west               : std_logic_vector(31 downto 0);
signal east               : std_logic_vector(31 downto 0);
signal front              : std_logic_vector(31 downto 0);
signal back               : std_logic_vector(31 downto 0);
signal c                  : std_logic_vector(31 downto 0);
signal random_number      : std_logic_vector(31 downto 0);
signal best_individual    : std_logic_vector(31 downto 0);
signal best_fitness       : std_logic_vector(15 downto 0);

 -- declare record type
    type test_vector is record
          north              : std_logic_vector(31 downto 0);
          south              : std_logic_vector(31 downto 0);
          west               : std_logic_vector(31 downto 0);
          east               : std_logic_vector(31 downto 0);
          front              : std_logic_vector(31 downto 0);
          back               : std_logic_vector(31 downto 0);
          c                  : std_logic_vector(31 downto 0);
          random_number      : std_logic_vector(31 downto 0);
    end record;

    type test_vector_array is array (natural range <>) of test_vector;

constant test_vectors : test_vector_array := (
        -- north, south, west, east, front, back, c, rn, 
        (x"01234567", x"01234560", x"00000101", x"89abcded", x"89abcdff" ,x"ab323567" ,x"11111111" ,x"22222222"),
        (x"aaaaaabb", x"ccccccc0", x"00000000", x"bbbbbbba", x"dddddddc" ,x"23462754" ,x"22222222" ,x"33333333"),
        (x"00000007", x"01234560", x"0000ffff", x"89abcdef", x"89abcdef" ,x"98765865" ,x"33333333" ,x"44444444"),
        (x"01234567", x"01234560", x"0000aaaa", x"89abcdef", x"00000000" ,x"25432789" ,x"44444444" ,x"55555555"),
        (x"11111117", x"01234560", x"0000bbbb", x"89abcdef", x"11111111" ,x"45232222" ,x"55555555" ,x"66666666")
        );

begin
    inst_gen_operators: entity work.genetic_operators_cont
        GENERIC MAP(
                N => 32, M => 16)
        PORT MAP(
                  clk      =>  clk,     
                  rst      =>  rst,
                  done     =>  done,
                  valid    =>  valid,
                  north           => north,         
                  south           => south,
                  west            => west,
                  east            => east,
                  front           => front,
                  back            => back,
                  c               => c,
                  random_number   => random_number,
                  best_individual => best_individual,
                  best_fitness    => best_fitness);

    -- Main simulation process.
    process is
    begin

        report "Start test bench";

        wait for 30 ns;


        for i in test_vectors'range loop
        --for i in 0 to 3 loop
            north            <= test_vectors(i).north;  
            south            <= test_vectors(i).south;  
            west             <= test_vectors(i).west;    
            east             <= test_vectors(i).east;    
            front            <= test_vectors(i).front;  
            back             <= test_vectors(i).back;  
            c                <= test_vectors(i).c;  
            random_number    <= test_vectors(i).random_number;
            valid           <= '1';
            wait for 5 ns;
            
            rst <= '1';
            

            wait for 5 ns;
            rst <= '0';
            
            wait for 10 ns;
            valid <= '0';
            
            wait for 200 ns;

--            assert ( 
--                        (mutated_chrom_one = test_vectors(i).mut_c1) and 
--                        (mutated_chrom_two = test_vectors(i).mut_c2) 
--                    )
--            report  "test_vector, outputs are not correct!!!" severity error;
        end loop;

        -- End simulation.
        report "End testbench";

    wait;
    end process;
    
   clk_process :process
   begin
                clk <= '0';
                wait for 5 ns;
                clk <= '1';
                wait for 5 ns;
   end process;

end architecture;
