-- Company : FAU
-- Author: Martin Letras
-- Test bench for mutation
--

use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top_module_mmdp8x8 is
end entity;

architecture arch of tb_top_module_mmdp8x8 is

signal clk       : std_logic;
signal rst       : std_logic;
signal start_ev: std_logic;

signal salida              : std_logic_vector(63 downto 0);


begin
    inst_pe: entity work.top_module_mmdp8x8
    GENERIC MAP(N   =>64, M  => 16, resolucion =>6, individuos =>1,
            LDS =>4, LDF => 4, FIT=>9, GEN => 400, 
            DIM =>8, INC_ARRAY => 4)
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
