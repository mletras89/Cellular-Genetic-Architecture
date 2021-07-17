-- Company : FAU
-- Author: Martin Letras
-- Test bench for mutation
--

use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top_module_mmdp is
end entity;

architecture arch of tb_top_module_mmdp is

signal clk       : std_logic;
signal rst       : std_logic;
signal start_ev: std_logic;

signal salida              : std_logic_vector(63 downto 0);

 -- declare record type
    type test_vector is record
	  north       :  STD_LOGIC_VECTOR(31 DOWNTO 0);         
	  south       :  STD_LOGIC_VECTOR(31 DOWNTO 0);         
	  west        :  STD_LOGIC_VECTOR(31 DOWNTO 0);         
	  east        :  STD_LOGIC_VECTOR(31 DOWNTO 0);         
    end record;

    type test_vector_array is array (natural range <>) of test_vector;

constant test_vectors : test_vector_array := (
        -- north, south, west, east, front, back 
        (x"01234567", x"a1234567", x"aaaaaaaa",x"bbbbbbbb"),
        (x"aaaaaabb", x"b1234567", x"baaaaaaa",x"cbbbbbbb"),
        (x"00000007", x"c1234567", x"caaaaaaa",x"dbbbbbbb"),
        (x"01234567", x"d1234567", x"daaaaaaa",x"ebbbbbbb"),
        (x"11111117", x"e1234567", x"eaaaaaaa",x"fbbbbbbb")
        );

begin
    inst_pe: entity work.top_module_mmdp
    GENERIC MAP(N   =>64, M  => 16, resolucion =>6, individuos =>16,
            LDS =>4, LDF => 4, FIT=>9, GEN => 400, 
            DIM =>2, INC_ARRAY => 4)
        PORT MAP(
              clk      =>  clk,     
              rst      =>  rst,
              start_ev =>  start_ev,
              salida1  =>  salida);

    -- Main simulation process.
    process is
    begin

        report "Start test bench";
        start_ev <= '0';
        wait for 30 ns;
        
        rst <= '1';
        wait for 5 ns;
        rst <= '0';
        wait for 5 ns;
        start_ev <= '1';


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
