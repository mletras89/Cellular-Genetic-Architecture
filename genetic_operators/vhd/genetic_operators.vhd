----------------------------------------------------------------------------------
-- Company: INAOE
-- Engineer: Marty Letras
-- 
-- Create Date:    17:38:41 09/15/2014 
-- Design Name: Processor Array for Implementing 2D/3D Cellular Genetic Algorithm 
-- Module Name:    genetic_operators - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--      Block that contains selection, crossover and mutation operators.
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

entity genetic_operators is
GENERIC(N  : POSITIVE:=64; M  : POSITIVE :=9; resolution : POSITIVE :=6 );
			
	 PORT(
			CLK	 			: IN  STD_LOGIC;
			RST 		    : IN  STD_LOGIC;
			north    		: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- signal for the selection entity
			south    		: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- signal for the selection entity
			west     		: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- signal for the selection entity
			east     		: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- signal for the selection entity
			
			cromosoma  		: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- signal for the selection entity
			fitnessCro 		: IN  STD_LOGIC_VECTOR(M-1 DOWNTO 0);		-- signal for the selection entity
			
			random_number : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			
			best_individual	: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			best_fitness	: OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0));
end genetic_operators;

architecture Behavioral of genetic_operators is
	    
	    component basic_register is
        generic (N: integer := 8);
        Port ( 
                    CLK	 	    : IN  STD_LOGIC;
                    RST 		: IN  STD_LOGIC;
                    D 	 		: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
                    Q 	 		: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0):=(OTHERS => '0')
                );
        end component;
		
		-- component that generates random numbers for the crossover component
		component generate_crossover_vector is
	    generic( N		 : POSITIVE := 64; resolution : POSITIVE := 6);
	    port(      random_number  : in  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		  	       output         : out STD_LOGIC_VECTOR(N-1 DOWNTO 0)
			     );
        end component;

		-- anysotropic selection component
		component anysotropic_selection is
	    generic (N: POSITIVE := 4;m: POSITIVE := 3);
        port (
                alpha            : in  STD_LOGIC_VECTOR(31 downto 0);    -- alpha value that determines the selection
                north            : in  STD_LOGIC_VECTOR(N-1 downto 0);   -- north input chromosome
                south            : in  STD_LOGIC_VECTOR(N-1 downto 0);   -- south input chromosome
                east             : in  STD_LOGIC_VECTOR(N-1 downto 0);   -- east input chromosome
                west             : in  STD_LOGIC_VECTOR(N-1 downto 0);   -- west input chromosome
                chromosome_one   : out STD_LOGIC_VECTOR(N-1 downto 0);   -- output chromosome one
                chromosme_two    : out STD_LOGIC_VECTOR(N-1 downto 0));  -- output chromosome two
        end component;
		
		-- crossover component
		component crossover is
        generic(N		 : POSITIVE := 4);
            port (operator  : in  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
                  chromosome_one    : in  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
                  chromosome_two    : in  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
                  offspring_one     : out STD_LOGIC_VECTOR(N-1 DOWNTO 0):=(OTHERS=>'0');
                  offspring_two     : out STD_LOGIC_VECTOR(N-1 DOWNTO 0):=(OTHERS=>'0')
                    );
        end component;
		
		-- mutation component
		component mutation is
        generic (N: POSITIVE := 4; resolution:POSITIVE := 2);
        port (chromosome_one	   : in  STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0');      -- input chromosome
              chromosome_two	   : in  STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0');      -- input chromosome
              random_number        : in  STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0');      -- input random number
              NewChrom_1 		   : out STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0');      -- new chromosome one
              NewChrom_2 		   : out STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0')       -- new chromosome two
                );
        end component;
		
		component evaluator is
        generic (N: positive := 18; M : positive := 9);  
        --N el tam del buffer del cromosoma
        --M el tam del buffer del fitness
        port (
                current_individual			: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
                current_fitness  			: IN  STD_LOGIC_VECTOR(M-1 DOWNTO 0);
                offspring_1					: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
                offspring_2					: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
                best_individual  			: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
                fitness						: OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0)
                );
        end component;

-- SEALES DE CONTROL		
	SIGNAL neighbour_chromose_one		: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL neighbour_chromose_two		: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	--SIGNAL fitness_neighbour			: STD_LOGIC_VECTOR(M-1 DOWNTO 0);

	SIGNAL offspring_1				 	: STD_LOGIC_VECTOR(N-1 downto 0);
	SIGNAL offspring_2				 	: STD_LOGIC_VECTOR(N-1 downto 0);
	SIGNAL offspring_mutate_1		 	: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL offspring_mutate_2		 	: STD_LOGIC_VECTOR(N-1 DOWNTO 0);

	SIGNAL output_chromosome			: STD_LOGIC_VECTOR(N-1 downto 0);
	SIGNAL output_fitness				: STD_LOGIC_VECTOR(M-1 DOWNTO 0);
	
	SIGNAL output_gen_crossover			: STD_LOGIC_VECTOR(N-1 downto 0);
	
	SIGNAL output_PIPE_01				: STD_LOGIC_VECTOR(N-1 downto 0);
	SIGNAL output_PIPE_02				: STD_LOGIC_VECTOR(N-1 downto 0);
	SIGNAL output_PIPE_03				: STD_LOGIC_VECTOR(N-1 downto 0);
	SIGNAL output_PIPE_04				: STD_LOGIC_VECTOR(M-1 downto 0);
begin
    -- register that stores the first offspring
	register01 : basic_register
	GENERIC MAP(N=>N)
	PORT MAP(CLK=>CLK,RST=>RST,D=>offspring_mutate_1,Q=>output_PIPE_01);
	
	--register that stores the second offspring
	register02 : basic_register
	GENERIC MAP(N=>N)
	PORT MAP(CLK=>CLK,RST=>RST,D=>offspring_mutate_2,Q=>output_PIPE_02);
	
	--register that stores the current individual
	register03 : basic_register
	GENERIC MAP(N=>N)
	PORT MAP(CLK=>CLK,RST=>RST,D=>cromosoma,Q=>output_PIPE_03);
	  		
	--register that stores the fitness value of the current individual
	registe04 : basic_register
	GENERIC MAP(N=>M)
	PORT MAP(CLK=>CLK,RST=>RST,D=>fitnessCro,Q=>output_PIPE_04);

	-- generate random numbers for the crossover component
	genCrossOverVector : generate_crossover_vector
	GENERIC MAP(N => N, resolution => resolution)
	PORT MAP(random_number => random_number, output =>output_gen_crossover);
	-- selection component
	selection : anysotropic_selection 
	GENERIC MAP(N => N, M => M)
	PORT MAP(alpha => random_number(31 downto 0),north => north, south => south, west => west, east => east, chromosome_one => neighbour_chromose_one, chromosme_two => neighbour_chromose_two );

	-- component crossover connected to the selection component
	crossover_component : crossover
	GENERIC MAP(N => N)
	PORT MAP(operator => output_gen_crossover, chromosome_one => neighbour_chromose_one, chromosome_two => neighbour_chromose_two, 
				offspring_one => offspring_1, offspring_two => offspring_2);	

    -- mutation component connected to the crossover component
	-- the output is connected to a comparator for verifying the fitness function
	mutation_component : mutation
	GENERIC MAP(N => N, resolution => resolution)
	PORT MAP(chromosome_one =>offspring_1, chromosome_two =>offspring_2, random_number => random_number, NewChrom_1=> offspring_mutate_1, NewChrom_2=> offspring_mutate_2);

	evaluator_component : evaluator
	GENERIC MAP(N => N, M => M)
	PORT MAP(current_individual =>output_PIPE_03, current_fitness =>output_PIPE_04, offspring_1 => output_PIPE_01, 
				offspring_2 => output_PIPE_02, best_individual => output_chromosome, fitness => output_fitness);
	
	best_individual	<= output_chromosome;
	best_fitness <= output_fitness;	
	
end Behavioral;

