----------------------------------------------------------------------------------
-- Company: INAOE
-- Engineer: Martin Letras
-- 
-- Create Date:    12:48:38 09/08/2014 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity crossover is
generic(N		 : POSITIVE := 4);
	port( 
          chromosome_one    : in  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
          chromosome_two    : in  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
          offspring_one     : out STD_LOGIC_VECTOR(N-1 DOWNTO 0):=(OTHERS=>'0');
          offspring_two     : out STD_LOGIC_VECTOR(N-1 DOWNTO 0):=(OTHERS=>'0'));
end crossover;

architecture Behavioral of crossover is
	SIGNAL s0      : STD_LOGIC_VECTOR(N-1 DOWNTO 0):=(OTHERS=>'0');
	SIGNAL s1      : STD_LOGIC_VECTOR(N-1 DOWNTO 0):=(OTHERS=>'0');
	SIGNAL s2      : STD_LOGIC_VECTOR(N-1 DOWNTO 0):=(OTHERS=>'0');
	SIGNAL s3      : STD_LOGIC_VECTOR(N-1 DOWNTO 0):=(OTHERS=>'0');
	SIGNAL s4      : STD_LOGIC_VECTOR(N-1 DOWNTO 0):=(OTHERS=>'0');

begin

	process(chromosome_one,chromosome_two)
	begin
                -- implementing fix crossver
                FOR i IN N-1 DOWNTO 0 LOOP
                        IF i < N/2 THEN
                                s0(i) <= '1';
                        ElSE
                                s0(i) <= '0';
                        END IF;
                END LOOP;
	
	end process;

	s1 <= chromosome_one AND s0;
	s2 <= chromosome_two AND s0;
	s3 <= chromosome_one AND (NOT s0);
	s4 <= chromosome_two AND (NOT s0);

	offspring_one <=  s1 OR s4;
	offspring_two <=  s2 OR s3;

end Behavioral;

