----------------------------------------------------------------------------------
-- Company: INAOE
-- Engineer: Marty Letras
-- 
-- Create Date: 02/23/2019 06:56:03 PM
-- Design Name: Processor Array for Implementing 2D/3D Cellular Genetic Algorithm 
-- Module Name: basic_register - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      Basic register employed for pipelining
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

entity basic_register is
	generic (N: integer := 8);
    Port ( 
				CLK	 	    : IN  STD_LOGIC;
				RST 		: IN  STD_LOGIC;
				D 	 		: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
				Q 	 		: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0):=(OTHERS => '0')
			);
end basic_register;

architecture Behavioral of basic_register is
begin

	PROCESS(clk,rst)
	BEGIN
		IF(rst = '0') THEN
			q <= (OTHERS => '0');
		ELSIF (clk'event AND clk='1') THEN
			--IF EN_WR = '1' THEN
				q <= d;
			--END IF;
		END IF;
	END PROCESS;

end Behavioral;