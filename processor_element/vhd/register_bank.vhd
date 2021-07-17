----------------------------------------------------------------------------------
-- Company: INAOE
-- Engineer: Marty Letras
-- 
-- Create Date:    01:02:34 09/20/2014 
-- Design Name: Processor Array for Implementing 2D/3D Cellular Genetic Algorithm
-- Module Name: banco_registros - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--      Register bank that stores the current individuals in a processor Element
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.datatypes.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- N is the chromosome size
-- M  is the bus size for the fitness function, usually is smaller than N
-- LDS is the size of the input buses for addresses in the register bank for chromosomes
-- I J are indices, where I is the row and J is the column
-- INDIVIDUALS coresspond to the number of individuals in each processor element
-- DIM is the dimension of the processor array DIM X DIM


entity register_bank is
	generic(individuals: POSITIVE:=4;   N : POSITIVE:= 64;  LDS : POSITIVE:=4;
			i			: integer :=7;	j : integer:=7; 	DIM : POSITIVE:=9;
			INC_ARRAY : POSITIVE :=3);
	port (  clk  : IN  STD_LOGIC;
            we   : IN  STD_LOGIC;                           -- write enable
            en   : IN  STD_LOGIC;                           -- enable
			ep	 : IN	STD_LOGIC;                          -- when this signal is activated all the data in the bank is sended to the outputs
            addr : IN  STD_LOGIC_VECTOR(LDS-1 DOWNTO 0);    -- writing address
            di   : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);      -- input data
			ip   : IN  ENTRADA_PAR;                         -- parallel input 
            da   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			dN   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			dS   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			dE   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			dW   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			dB   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
            dF   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
			);
end register_bank;

architecture Behavioral of register_bank is
	SIGNAL RAM                                         : ENTRADA_PAR;
	signal t_norte,t_sur,t_este,t_oeste,t_actual       : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	signal t_front,t_back							   : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	
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
				t_actual 		<= RAM(ind_act);
                
                t_back          <=  ram((conv_integer(addr)+INC_ARRAY) mod individuals);
                t_front         <=  ram((conv_integer(addr)-INC_ARRAY) mod individuals);
                
				IF i = 0 THEN
					con := conv_integer(addr)+INC_ARRAY;
					IF con >= individuals THEN
						con := con mod individuals;
					END IF;
					t_norte 	<= ram(con);
					t_sur   	<= ram(ind_act);
				ELSIF i = DIM-1 THEN
					con := conv_integer(addr)-INC_ARRAY;
					IF con < 0 THEN
						con := con mod individuals;
					END IF;
					t_sur	  	<= ram(con);
					t_norte 	<= ram(ind_act);
				ELSE
					t_sur   	<= ram(ind_act);
					t_norte 	<= ram(ind_act);
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
					t_oeste  <= ram(con);
					t_este  <= ram(ind_act);
				ELSIF j = DIM-1 THEN
					con := conv_integer(addr)-1;
					IF con < INC_ARRAY*(div_res) THEN
						con :=INC_ARRAY*(div_res);
					END IF;
					t_este  <= ram(con);
					t_oeste  <= ram(ind_act);
				ELSE
					t_este   <= ram(ind_act);
					t_oeste  <= ram(ind_act);
				END IF;
				
			END IF;
			
       END IF;
			
    END PROCESS;
	
	 da<=t_actual;
	 dn<=t_norte;
	 ds<=t_sur;
	 dw<=t_oeste;
	 de<=t_este;
	 db<=t_back;
	 df<=t_front;
end Behavioral;