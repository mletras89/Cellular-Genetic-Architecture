----------------------------------------------------------------------------------
-- Company: INAOE
-- Engineer: Marty Letras
-- 
-- Create Date:    13:50:01 11/21/2014 
-- Design Name: Processor Array for Implementing 2D/3D Cellular Genetic Algorithm
-- Module Name:    banco_registros_fitness - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
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

entity register_bank_fitness is
	generic(individuals: POSITIVE:=4;    M : POSITIVE:= 6;   LDS : POSITIVE:=4;
			i			: integer :=7;	j : integer:=7; 	DIM : POSITIVE:=9;
			INC_ARRAY : POSITIVE :=3);
	port (  clk  : IN  STD_LOGIC;
            we   : IN  STD_LOGIC;                           -- write enable
            en   : IN  STD_LOGIC;                           -- enable
			ep	 : IN	STD_LOGIC;                          -- singnal that indicates to output the parallel data
            addr : IN  STD_LOGIC_VECTOR(LDS-1 DOWNTO 0);    -- writing address
            di   : IN  STD_LOGIC_VECTOR(M-1 DOWNTO 0);
			ip   : IN  ENTRADA_PAR_FIT;                     -- parallel input 
            da   : OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0)
			--dN   : OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0);
			--dS   : OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0);
			--dE   : OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0);
			--dW   : OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0)
			);
end register_bank_fitness;

architecture Behavioral of register_bank_fitness is
	SIGNAL RAM: ENTRADA_PAR_FIT;
	signal t_north,t_south,t_east,t_west,t_current : STD_LOGIC_VECTOR(M-1 DOWNTO 0);
	signal t_front,t_back						   : STD_LOGIC_VECTOR(M-1 DOWNTO 0);
	
begin
PROCESS (clk)
	variable con,ind_act,div_res : integer;
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF en = '1' THEN
				IF ep = '1' THEN
					ram <= ip;
				ELSIF we = '1' THEN
					ram(conv_integer(addr)) <= di;
            END IF;
            
				ind_act  		:= conv_integer(addr);
				t_current 		<= RAM(ind_act);

				IF i = 0 THEN
					con := ind_act+INC_ARRAY;
					IF con >= individuals THEN
						con := con mod individuals;
						--con := con - individuos;
					END IF;
					t_north 	<= ram(con);
					t_south   	<= ram(ind_act);
				ELSIF i = DIM-1 THEN
					con := conv_integer(addr)-INC_ARRAY;
					IF con < 0 THEN
						--con := con + individuos;
						con := con mod individuals;
					END IF;
					t_south	  	<= ram(con);
					t_north 	<= ram(ind_act);
				ELSE
					t_south   	<= ram(ind_act);
					t_north 	<= ram(ind_act);
				END IF;
				
				-- if J = 0 the output in the west is the element N + 1
				-- and in the output the current individual
				-- if J = DIM the output in the east is the element N + 1
				-- and the west output the current individual
				-- else, both east and west is the current individual
				div_res := (ind_act/INC_ARRAY);
				IF j = 0 THEN
					con := conv_integer(addr)+1;
					IF con >	(INC_ARRAY*(div_res+1)-1) THEN
						--con :=(INC_ARRAY*(div_res+1)-1) - INC_ARRAY;
						con :=(INC_ARRAY*(div_res+1)-1) mod INC_ARRAY;
					END IF;
					t_west  <= ram(con);
					t_east  <= ram(ind_act);
				ELSIF j = DIM-1 THEN
					con := conv_integer(addr)-1;
					IF con < INC_ARRAY*(div_res) THEN
						con :=INC_ARRAY*(div_res);
					END IF;
					t_east  <= ram(con);
					t_west  <= ram(ind_act);
				ELSE
					t_east   <= ram(ind_act);
					t_west  <= ram(ind_act);
				END IF;
				
			END IF;
			
       END IF;
			
    END PROCESS;

	 da <= t_current;
     --dn <= t_north;
	 --ds <= t_south;
	 --dw <= t_west;
	 --de <= t_east;
end Behavioral;
