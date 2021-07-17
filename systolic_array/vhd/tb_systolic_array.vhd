-- Company : FAU
-- Author: Martin Letras
-- Test bench for mutation
--

use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_systolic_array is
end entity;

architecture arch of tb_systolic_array is

signal clk       : std_logic;
signal rst       : std_logic;

signal in_sys              : std_logic_vector(31 downto 0);
signal out_sys             : std_logic_vector(31 downto 0);

 -- declare record type
    type test_vector is record
          in_sys              : std_logic_vector(31 downto 0);
          out_sys             : std_logic_vector(31 downto 0);
    end record;

    type test_vector_array is array (natural range <>) of test_vector;

constant test_vectors : test_vector_array := (
        -- north, south, west, east, front, back, c, rn, 
        (x"01234567", x"01234567"),
        (x"aaaaaabb", x"01234567"),
        (x"00000007", x"01234567"),
        (x"01234567", x"01234567"),
        (x"11111117", x"01234567")
        );

begin
    inst_sys: entity work.systolic_array
        GENERIC MAP(N => 32)
        PORT MAP(
                  clk      =>  clk,     
                  rst      =>  rst,
                  in_sys   =>  in_sys,
                  out_sys  =>  out_sys);

    -- Main simulation process.
    process is
    begin

        report "Start test bench";

        wait for 30 ns;

        rst <= '1';
        wait for 5 ns;
        rst <= '0';

        for i in test_vectors'range loop
            in_sys    <= test_vectors(i).in_sys;  
            wait for 20 ns;
 
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
