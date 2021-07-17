----------------------------------------------------------------------------------
-- Company: INAOE 
-- Engineer: Marty Letras
-- 
-- Create Date:    13:48:06 11/21/2014 
-- Design Name: Processor Array for Implementing 2D/3D Cellular Genetic Algorithm
-- Module Name:    banco_registros_temporal_fitness - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--      Temporal register bank for storing a set of fitnesss values
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.datatypes_mmdp.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register_bank_temporal_fitness is
	generic(individuals: POSITIVE:=4; M : POSITIVE:= 6; LDS : POSITIVE:=4);
	port (  clk  : IN  STD_LOGIC;
            we   : IN  STD_LOGIC;-- write enable
            en   : IN  STD_LOGIC;-- enable
			addr : IN  STD_LOGIC_VECTOR(LDS-1 DOWNTO 0); --writing address
            di   : IN  STD_LOGIC_VECTOR(M-1 DOWNTO 0);
            do   : OUT ENTRADA_PAR_FIT
			);
end register_bank_temporal_fitness;

architecture Behavioral of register_bank_temporal_fitness is
	SIGNAL RAM: ENTRADA_PAR_FIT;
begin
	PROCESS (clk)
   BEGIN
		IF clk'event AND clk = '1' THEN
			IF en = '1' THEN
				IF we = '1' THEN
					ram(conv_integer(addr)) <= di;
            END IF;
            
				--IF we = '0' AND sp = '1' THEN
					do <= ram;
				--END IF;
			
			END IF;
       END IF;
    END PROCESS;

end Behavioral;

