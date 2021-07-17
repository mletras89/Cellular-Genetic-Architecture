-- Company : FAU
-- Author: Martin Letras
-- Test bench for mutation
--

use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_processor_element_mmdp is
end entity;

architecture arch of tb_processor_element_mmdp is

signal clk       : std_logic;
signal rst       : std_logic;
signal start_ev: std_logic;
signal in_sys              : std_logic_vector(63 downto 0);
signal out_sys             : std_logic_vector(63 downto 0);
-- input signals for the closest neighbours
signal north       :  STD_LOGIC_VECTOR(63 DOWNTO 0);         
signal south       :  STD_LOGIC_VECTOR(63 DOWNTO 0);         
signal west        :  STD_LOGIC_VECTOR(63 DOWNTO 0);         
signal east        :  STD_LOGIC_VECTOR(63 DOWNTO 0);         
signal front       :  STD_LOGIC_VECTOR(63 DOWNTO 0);         
signal back        :  STD_LOGIC_VECTOR(63 DOWNTO 0);         
signal Onorth      :  STD_LOGIC_VECTOR(63 DOWNTO 0);         
signal Osouth      :  STD_LOGIC_VECTOR(63 DOWNTO 0);         
signal Owest       :  STD_LOGIC_VECTOR(63 DOWNTO 0);         
signal Oeast       :  STD_LOGIC_VECTOR(63 DOWNTO 0);         
signal Ofront      :  STD_LOGIC_VECTOR(63 DOWNTO 0);         
signal Oback       :  STD_LOGIC_VECTOR(63 DOWNTO 0);         

 -- declare record type
    type test_vector is record
	  north       :  STD_LOGIC_VECTOR(63 DOWNTO 0);         
	  south       :  STD_LOGIC_VECTOR(63 DOWNTO 0);         
	  west        :  STD_LOGIC_VECTOR(63 DOWNTO 0);         
	  east        :  STD_LOGIC_VECTOR(63 DOWNTO 0);         
	  front       :  STD_LOGIC_VECTOR(63 DOWNTO 0);         
	  back        :  STD_LOGIC_VECTOR(63 DOWNTO 0);         
    end record;

    type test_vector_array is array (natural range <>) of test_vector;

constant test_vectors : test_vector_array := (
        -- north, south, west, east, front, back 
        (x"0123456711111111", x"a123456722222222", x"aaaaaaaa33333333",x"bbbbbbbb44444444",x"cccccccc55555555",x"dddddddd66666666"),
        (x"aaaaaabb11111111", x"b123456722222222", x"baaaaaaa33333333",x"cbbbbbbb44444444",x"dccccccc55555555",x"eddddddd66666666"),
        (x"0000000711111111", x"c123456722222222", x"caaaaaaa33333333",x"dbbbbbbb44444444",x"eccccccc55555555",x"fddddddd66666666"),
        (x"0123456711111111", x"d123456722222222", x"daaaaaaa33333333",x"ebbbbbbb44444444",x"fccccccc55555555",x"1ddddddd66666666"),
        (x"1111111711111111", x"e123456722222222", x"eaaaaaaa33333333",x"fbbbbbbb44444444",x"0ccccccc55555555",x"2ddddddd66666666")
        );

begin
    inst_pe: entity work.processor_element_mmdp
    GENERIC MAP(N   =>64, M  => 16, resolution =>6, individuals =>16,
            LDS =>4, LDF => 4, i=> 0, j=>0, FIT=>9, GEN => 400, 
            DIM =>2, INC_ARRAY => 4)
        PORT MAP(
              clk      =>  clk,     
              rst      =>  rst,
              start_ev =>  start_ev,
              in_sys   =>  in_sys,
              out_sys  =>  out_sys,
              
		      north    =>  north, 
	          south    =>  south, 
	          west     =>  west, 
	          east     =>  east, 
	          front    =>  front, 
	          back     =>  back, 
	          Onorth   =>  Onorth,    
	          Osouth   =>  Osouth,
	          Owest    =>  Owest,
	          Oeast    =>  Oeast,
	          Ofront   =>  Ofront,
	          Oback    =>  Oback);

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

        for i in test_vectors'range loop
            north    <= test_vectors(i).north;  
            south    <= test_vectors(i).south;  
            west     <= test_vectors(i).west;  
            east     <= test_vectors(i).east;             
            front    <= test_vectors(i).front;  
            back     <= test_vectors(i).back;             
            in_sys   <= x"FFFFAAAAFFFFAAAA";
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
