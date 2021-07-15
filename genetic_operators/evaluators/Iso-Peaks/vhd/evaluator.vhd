----------------------------------------------------------------------------------
-- Company: INAOE
-- Engineer: Marty Letras
-- 
-- Create Date:    17:08:17 09/15/2014 
-- Design Name:    Processor Array for Implementing 2D/3D Cellular Genetic Algorithm
-- Module Name:    ISO_PEAK - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Implementation of the ISO_PEAK combinatorial problema according to the
-- E. Alba et al. book about Cellular Genetic Algorithms
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

------------------------------------------------
-- X    00    01    10    11
------------------------------------------------
--Iso1  m     0     0     m-a
--Iso2  0     0     0     m
------------------------------------------------

entity evaluator is
generic (N: positive := 18; M : positive := 9);  
	--N is the size of the chromosomes buffer
	--M is the size of fitness value buffer
	port (
		chromosome			: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		fitness				: OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0)
		);
end evaluator;

architecture Behavioral of evaluator is
	SIGNAL FIT : STD_LOGIC_VECTOR(M - 1 DOWNTO 0):=(OTHERS=>'0');
begin

	PROCESS(chromosome)
	VARIABLE inter          : INTEGER:=0;
	BEGIN
		inter := 0;
		
		-- function ISO2 that increments when xx is 11
		IF chromosome(1 DOWNTO 0) = "11" THEN
			inter := inter + 2;
		END IF;

		-- Run the cycle over the chromosome
		FOR I IN 2 TO N/2 LOOP
			IF chromosome(2*i-1 DOWNTO 2*i-2) = "00" THEN
				inter := inter+2;
			ELSIF chromosome(2*i-1 DOWNTO 2*i-2) = "11" THEN
				inter := inter+1;
			END IF;
		END LOOP;
		
		fit <= conv_std_logic_vector(inter,M);
		
	END PROCESS;
	fitness <= fit;

end Behavioral;

