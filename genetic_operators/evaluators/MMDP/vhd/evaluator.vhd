----------------------------------------------------------------------------------
-- Company: INAOE
-- Engineer: Marty Letras
-- 
-- Create Date:    17:08:17 09/15/2014 
-- Design Name:    Processor Array for Implementing 2D/3D Cellular Genetic Algorithm
-- Module Name:    MMDP - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Implementation of the MMDP combinatorial problema according to the
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
-- Unitation   Subfunction Value
------------------------------------------------
-- 0          10000 = 
-- 1          00000 = 
-- 2          00110 =
-- 3          01010 =
-- 4          10000 =
-- 5          00000 =
-- 6          00110 =     
------------------------------------------------

entity evaluator is
generic (N: positive := 64; M : positive := 16);  
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
	VARIABLE counter :integer;
	VARIABLE inter   : STD_LOGIC_VECTOR(M - 1 DOWNTO 0):=(OTHERS=>'0');
	BEGIN
		inter :=(OTHERS=>'0');
		
		-- function ISO2 that increments when xx is 11
		FOR I IN 1 TO 10 LOOP
		  counter := 0;
		  FOR J IN 1 to 6 LOOP
		      IF chromosome(6*(i-1)+(j-1)) = '1' THEN
		          counter := counter + 1;    
		      END IF;
		  END LOOP;
		  IF counter = 0 or counter = 6 THEN
		      --inter := "00010000" + inter;
		      inter := "10000" + inter;
		  END IF;
		  
		  IF counter = 2 OR  counter = 4 THEN
		      --inter:= "00000110" + inter;
		      inter:= "110" + inter;
		  END IF;
		  
		  IF counter = 3 THEN
		      --inter:= "00001010" + inter;
		      inter:= "1010" + inter;
		  END IF;
		END LOOP;
		
		--fit <= conv_std_logic_vector(inter,M);
		fit <= inter;
		
	END PROCESS;
	fitness <= fit;

end Behavioral;

