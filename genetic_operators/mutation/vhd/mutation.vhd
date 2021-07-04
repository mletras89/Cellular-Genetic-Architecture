--------------------------------------------------------------------------------
-- Company: INAOE
-- Engineer: Martin Letras
-- 
-- Create Date:    13:01:29 09/08/2014 
-- Design Name:  Processor Array for Implementing 2D/3D Cellular Genetic Algorithm
-- Module Name:    mutation - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--     Module that perfomrs the mutation operation in a Genetic Algorithm
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
--use IEEE.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- combinatorial module implements the mutation operator
-- it receives two chromosomes as inputs 
-- and a random number that indicates the indices to flip in the chromosomes

-- N is the chromosome size
-- resolution is the size of bits con count from 0  - N (for 64 M=6) 

entity mutation is
	generic (N: POSITIVE := 64; resolution:POSITIVE := 6);
	port (
              chromosome_one	   : in  STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0');      -- input chromosome
	      chromosome_two	   : in  STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0');      -- input chromosome
	      random_number        : in  STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0');      -- input random number
	      NewChrom_1	   : out STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0');      -- new chromosome one
	      NewChrom_2	   : out STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0')       -- new chromosome two
			);
end mutation;

architecture Behavioral of mutation is

  signal out_01	           : STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0');
  signal out_02	           : STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0'); 
  signal bit_one           : STD_LOGIC_VECTOR(resolution-1 downto 0);
  signal bit_two           : STD_LOGIC_VECTOR(resolution-1 downto 0); 

begin
  --S_01 <= tab_mutation(conv_integer(random_number(resolution-1 downto 0)));
  --S_02 <= tab_mutation(conv_integer(random_number(resolution*2-1 downto resolution)));
  --S_01 <= tab_mutation(0);
  --S_02 <= tab_mutation(10);
  process (chromosome_one, chromosome_two, random_number)
  variable S_01	           : STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0');
  variable S_02	           : STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0'); 
  begin
	S_01 := chromosome_one;
	S_02 := chromosome_two;
	S_01(conv_integer(random_number(resolution-1 downto 0)))            := not S_01(conv_integer(random_number(resolution-1 downto 0)));
	S_02(conv_integer(random_number(resolution*2-1 downto resolution))) := not S_02(conv_integer(random_number(resolution*2-1 downto resolution)));
	out_01 <= S_01;
	out_02 <= S_02;
	bit_one <= random_number(resolution-1 downto 0);
	bit_two <= random_number(resolution*2-1 downto resolution);
  end process;

        
NewChrom_1 <= out_01;
NewChrom_2 <= out_02;

end Behavioral;
