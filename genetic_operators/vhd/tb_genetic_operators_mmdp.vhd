-- Company : FAU
-- Author: Martin Letras
-- Test bench for mutation
--

use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_genetic_operators_mmdp is
end entity;

architecture arch of tb_genetic_operators_mmdp is

signal clk       : std_logic;
signal rst       : std_logic;
signal done      : std_logic;
signal valid     : std_logic;

signal north              : std_logic_vector(63 downto 0);
signal south              : std_logic_vector(63 downto 0);
signal west               : std_logic_vector(63 downto 0);
signal east               : std_logic_vector(63 downto 0);
signal front              : std_logic_vector(63 downto 0);
signal back               : std_logic_vector(63 downto 0);
signal c                  : std_logic_vector(63 downto 0);
signal random_number      : std_logic_vector(63 downto 0);
signal best_individual    : std_logic_vector(63 downto 0);
signal best_fitness       : std_logic_vector(15 downto 0);

 -- declare record type
    type test_vector is record
          north              : std_logic_vector(63 downto 0);
          south              : std_logic_vector(63 downto 0);
          west               : std_logic_vector(63 downto 0);
          east               : std_logic_vector(63 downto 0);
          front              : std_logic_vector(63 downto 0);
          back               : std_logic_vector(63 downto 0);
          c                  : std_logic_vector(63 downto 0);
          random_number      : std_logic_vector(63 downto 0);
    end record;

    type test_vector_array is array (natural range <>) of test_vector;

constant test_vectors : test_vector_array := (
        -- north, south, west, east, front, back, c, rn, 
        (x"1111111101234567", x"0123422222222560", x"3333333300000101", x"4444444489abcded", x"5555555589abcdff" ,x"66666666ab323567" ,x"7777777711111111" ,x"1111111122222222"),
        (x"11111111aaaaaabb", x"c22222222cccccc0", x"3333333300000000", x"44444444bbbbbbba", x"55555555dddddddc" ,x"6666666623462754" ,x"7777777722222222" ,x"1111111133333333"),
        (x"1111111100000007", x"2222222201234560", x"333333330000ffff", x"4444444489abcdef", x"5555555589abcdef" ,x"6666666698765865" ,x"7777777733333333" ,x"1111111144444444"),
        (x"1111111101234567", x"2222222201234560", x"333333330000aaaa", x"4444444489abcdef", x"5555555500000000" ,x"6666666625432789" ,x"7777777744444444" ,x"1111111155555555"),
        (x"1111111111111117", x"2222222201234560", x"333333330000bbbb", x"4444444489abcdef", x"5555555511111111" ,x"6666666645232222" ,x"7777777755555555" ,x"1111111166666666")
        );

begin
    inst_gen_operators: entity work.genetic_operators
        GENERIC MAP(
                N => 64, M => 16)
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
