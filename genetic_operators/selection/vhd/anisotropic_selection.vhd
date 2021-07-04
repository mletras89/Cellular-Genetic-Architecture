----------------------------------------------------------------------------------
-- Company: INAOE
-- Engineer: Martin Letras
-- 
-- Create Date:    18:00:41 08/26/2014 
-- Design Name:  Processor Array for Implementing 2D/3D Cellular Genetic Algorithm
-- Module Name:   anysotropic_selection - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--     Entitty that performs the anysotropic selection for a Genetic Algorithm
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
-- anysotropic does not need the fitness value for evaluation
entity anisotropic_selection is
	
	generic (N: POSITIVE := 64);

	port (
			random_number    : in  STD_LOGIC_VECTOR(N-1 downto 0);   -- random number used which encodes alpha, P_sel, and P_ind
			north            : in  STD_LOGIC_VECTOR(N-1 downto 0);   -- north input chromosome
			south            : in  STD_LOGIC_VECTOR(N-1 downto 0);   -- south input chromosome
			east             : in  STD_LOGIC_VECTOR(N-1 downto 0);   -- east input chromosome
			back             : in  STD_LOGIC_VECTOR(N-1 downto 0);   -- south input chromosome
			front             : in  STD_LOGIC_VECTOR(N-1 downto 0);   -- east input chromosome
			west             : in  STD_LOGIC_VECTOR(N-1 downto 0);   -- west input chromosome
			sel_chromosome   : out STD_LOGIC_VECTOR(N-1 downto 0));  -- output chromosome
			
end anisotropic_selection;

architecture Behavioral of anisotropic_selection is

    subtype lutin   is std_logic_vector (3 downto 0);
    subtype lutout  is std_logic_vector (4 downto 0);
    type lut is array (natural range 0 to 15) of lutout;
    constant LUT_PNSF:   lut := (
                "01010",                  -- 0.5
                "01001",                  -- 0.45
                "01000",                  -- 0.4
                "00111",                  -- 0.35
                "00110",                  -- 0.3
                "00101",                  -- 0.25
                "00100",                  -- 0.2
                "00011",                  -- 0.15
                "00010",                  -- 0.1
                "00001",                  -- 0.05
                "00000",                  -- 0
                "00000",                  -- 0
                "00000",                  -- 0
                "00000",                  -- 0
                "00000",                  -- 0
                "00000"                   -- 0
        );
     
    constant LUT_PEWB:   lut := (
                "01010",                  -- 0.5 
                "01011",                 -- 0.55
                "01100",                 -- 0.6
                "01101",                 -- 0.65
                "01110",                 -- 0.7
                "01111",                 -- 0.75
                "10000",                 -- 0.8
                "10001",                 -- 0.85
                "10010",                 -- 0.9
                "10011",                 -- 0.95
                "10100",                 -- 1
                "10100",                 -- 1
                "10100",                 -- 1
                "10100",                 -- 1
                "10100",                 -- 1
                "10100"                 -- 1
        );

	signal alpha    : STD_LOGIC_VECTOR(3 downto 0);
	signal Psel     : STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL Pind     : STD_LOGIC_VECTOR(1 downto 0);
	signal PNSF     : STD_LOGIC_VECTOR(4 downto 0); 
	signal PEWB     : STD_LOGIC_VECTOR(4 downto 0); 

begin
	alpha <= random_number(3 downto 0);
	Psel  <= random_number(8 downto 4);
	Pind  <= random_number(10 downto 9);

	PNSF <= LUT_PNSF(conv_integer(alpha));
	PEWB <= LUT_PEWB(conv_integer(alpha));

	
	sel_chromosome <= east  when ("00000"<Psel and Psel<=PEWB) and (Pind = "00") else 
			  west  when ("00000"<Psel and Psel<=PEWB) and (Pind = "01") else
			  back  when ("00000"<Psel and Psel<=PEWB) and (Pind >= "10") else
			  north when (("10101"-PNSF)<Psel and Psel<="10101") and (Pind = "00")  else
			  south when (("10101"-PNSF)<Psel and Psel<="10101") and (Pind = "01") else
		          front;

end Behavioral;

