----------------------------------------------------------------------------------
-- Company: FAU
-- Engineer: Martin Letras
-- 
-- Create Date:    12:48:38 07/03/2021
-- Design Name: Processor Array for Implementing 2D/3D Cellular Genetic Algorithm
-- Module Name:    crossover - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--      Implementation of crossover operation for Genetic Algorithms
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_crossover is
	port (
          chromosome_one    : in  STD_LOGIC_VECTOR(63 DOWNTO 0);
          chromosome_two    : in  STD_LOGIC_VECTOR(63 DOWNTO 0);
          offspring_one     : out STD_LOGIC_VECTOR(63 DOWNTO 0):=(OTHERS=>'0');
          offspring_two     : out STD_LOGIC_VECTOR(63 DOWNTO 0):=(OTHERS=>'0'));
end top_crossover;

architecture Behavioral of top_crossover is

component crossover is
generic(N		 : POSITIVE := 4);
	port (
          chromosome_one    : in  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
          chromosome_two    : in  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
          offspring_one     : out STD_LOGIC_VECTOR(N-1 DOWNTO 0):=(OTHERS=>'0');
          offspring_two     : out STD_LOGIC_VECTOR(N-1 DOWNTO 0):=(OTHERS=>'0'));
end component;

begin
top_02: crossover
	GENERIC MAP(
		N => 64)
	PORT MAP(
		chromosome_one => chromosome_one,
		chromosome_two => chromosome_two,
		offspring_one => offspring_one,
		offspring_two => offspring_two);

end architecture;
