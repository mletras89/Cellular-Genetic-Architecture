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

-- resolution must be 5 for the 32 bits chromosome
-- resolution must be 6 for the 64 bits chromosome


entity genetic_operators_cont is
GENERIC(N  : POSITIVE:=32; M  : POSITIVE :=16; resolution : POSITIVE :=5 );
			
	 PORT(
			CLK	 		: IN  STD_LOGIC;
			RST 		        : IN  STD_LOGIC;

			DONE 		        : OUT  STD_LOGIC;
			VALID 		        : IN  STD_LOGIC;

                        north    		: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);	
			south    		: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);	
			west     		: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);	
			east     		: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);	
                        front                   : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);   
                        back                    : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);   
			
			c  		        : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			
			random_number           : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			
			best_individual	: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			best_fitness	: OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0));
end genetic_operators_cont;

architecture Behavioral of genetic_operators_cont is
	    
    component basic_register is
    generic (N: integer := 8);
    Port ( 
          CLK	 	    : IN  STD_LOGIC;
          RST 		    : IN  STD_LOGIC;
          D 	 	    : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
          Q 	 	    : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0):=(OTHERS => '0'));
        end component;

     component crossover is
     generic(N                : POSITIVE := 4);
     port(
          chromosome_one    : in  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
          chromosome_two    : in  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
          offspring_one     : out STD_LOGIC_VECTOR(N-1 DOWNTO 0):=(OTHERS=>'0');
          offspring_two     : out STD_LOGIC_VECTOR(N-1 DOWNTO 0):=(OTHERS=>'0'));
     end component;

     component anisotropic_selection is
     generic (N: POSITIVE := 64);
     port(
          random_number    : in  STD_LOGIC_VECTOR(N-1 downto 0);  
          north            : in  STD_LOGIC_VECTOR(N-1 downto 0);
          south            : in  STD_LOGIC_VECTOR(N-1 downto 0);  
          east             : in  STD_LOGIC_VECTOR(N-1 downto 0);
          back             : in  STD_LOGIC_VECTOR(N-1 downto 0);
          front            : in  STD_LOGIC_VECTOR(N-1 downto 0);
          west             : in  STD_LOGIC_VECTOR(N-1 downto 0);
          sel_chromosome   : out STD_LOGIC_VECTOR(N-1 downto 0));
     end component;

     component mutation is
     generic (N: POSITIVE := 64; resolution:POSITIVE := 6);
     port (
           chromosome_one  : in  STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0');
           chromosome_two  : in  STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0');
	   random_number   : in  STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0');
	   NewChrom_1      : out STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0');
	   NewChrom_2      : out STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0') 	);
     end component;


     component evaluator is
     port (
	      chromosome	: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	      fitness		: OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0));
     end component;

--  signals for definyng the finite state machine
TYPE state IS (read_inputs, state_selection, state_crossover, state_mutation, evaluation_one,evaluation_two,compare,finished); 
SIGNAL current_state, next_state : state;

-- signals for reading values
signal ev_ind			: STD_LOGIC;
signal sig_north    		: STD_LOGIC_VECTOR(N-1 DOWNTO 0);	
signal sig_south    		: STD_LOGIC_VECTOR(N-1 DOWNTO 0);	
signal sig_west     		: STD_LOGIC_VECTOR(N-1 DOWNTO 0);	
signal sig_east     		: STD_LOGIC_VECTOR(N-1 DOWNTO 0);	
signal sig_front                : STD_LOGIC_VECTOR(N-1 DOWNTO 0);   
signal sig_back                 : STD_LOGIC_VECTOR(N-1 DOWNTO 0);   
signal sig_c  		        : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
signal sig_fitness_c 		: STD_LOGIC_VECTOR(M-1 DOWNTO 0);
signal sig_random_number        : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
signal sig_sel_chromosome 	: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
signal sig_cross_ind_one    	: STD_LOGIC_VECTOR(N-1 DOWNTO 0); 
signal sig_cross_ind_two    	: STD_LOGIC_VECTOR(N-1 DOWNTO 0); 
signal sig_mut_ind_one    	: STD_LOGIC_VECTOR(N-1 DOWNTO 0); 
signal sig_mut_ind_two    	: STD_LOGIC_VECTOR(N-1 DOWNTO 0); 
signal ev_chromosome    	: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
signal ev_chromosome_fitness   	: STD_LOGIC_VECTOR(M-1 DOWNTO 0); 
signal fitness_one   		: STD_LOGIC_VECTOR(M-1 DOWNTO 0); 
signal fitness_two   		: STD_LOGIC_VECTOR(M-1 DOWNTO 0);
signal new_fitness   		: STD_LOGIC_VECTOR(M-1 DOWNTO 0);
signal new_chromosome    	: STD_LOGIC_VECTOR(N-1 DOWNTO 0);

-- signals of stored values
signal sig_north_stored    		: STD_LOGIC_VECTOR(N-1 DOWNTO 0);	
signal sig_south_stored    		: STD_LOGIC_VECTOR(N-1 DOWNTO 0);	
signal sig_west_stored     		: STD_LOGIC_VECTOR(N-1 DOWNTO 0);	
signal sig_east_stored     		: STD_LOGIC_VECTOR(N-1 DOWNTO 0);	
signal sig_front_stored                 : STD_LOGIC_VECTOR(N-1 DOWNTO 0);   
signal sig_back_stored                  : STD_LOGIC_VECTOR(N-1 DOWNTO 0);   
signal sig_c_stored  		        : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
signal sig_fitness_c_stored		: STD_LOGIC_VECTOR(M-1 DOWNTO 0);
signal sig_random_number_stored         : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
signal sig_sel_chromosome_stored  	: STD_LOGIC_VECTOR(N-1 DOWNTO 0); 
signal sig_cross_ind_one_stored    	: STD_LOGIC_VECTOR(N-1 DOWNTO 0); 
signal sig_cross_ind_two_stored    	: STD_LOGIC_VECTOR(N-1 DOWNTO 0); 
signal sig_mut_ind_one_stored    	: STD_LOGIC_VECTOR(N-1 DOWNTO 0); 
signal sig_mut_ind_two_stored    	: STD_LOGIC_VECTOR(N-1 DOWNTO 0); 

begin
    -- register that stores the north
	register_north : basic_register
	GENERIC MAP(N=>N)
	PORT MAP(CLK=>CLK,RST=>RST,D=>sig_north,Q=>sig_north_stored);
	
	--register that stores the south
	register_south : basic_register
	GENERIC MAP(N=>N)
	PORT MAP(CLK=>CLK,RST=>RST,D=>sig_south,Q=>sig_south_stored);
	
	--register that stores the west
	register_west : basic_register
	GENERIC MAP(N=>N)
	PORT MAP(CLK=>CLK,RST=>RST,D=>sig_west,Q=>sig_west_stored);
	  		
	--register that stores the east
	register_east : basic_register
	GENERIC MAP(N=>N)
	PORT MAP(CLK=>CLK,RST=>RST,D=>sig_east,Q=>sig_east_stored);

	--register that stores the front
	register_front : basic_register
	GENERIC MAP(N=>N)
	PORT MAP(CLK=>CLK,RST=>RST,D=>sig_front,Q=>sig_front_stored);

	--register that stores the back
	register_back : basic_register
	GENERIC MAP(N=>N)
	PORT MAP(CLK=>CLK,RST=>RST,D=>sig_back,Q=>sig_back_stored);

        --register that stores the back
        register_sig_c : basic_register
        GENERIC MAP(N=>N)
        PORT MAP(CLK=>CLK,RST=>RST,D=>sig_c,Q=>sig_c_stored);

	--register that stores the random number
	register_sig_random_number : basic_register
	GENERIC MAP(N=>N)
	PORT MAP(CLK=>CLK,RST=>RST,D=>sig_random_number,Q=>sig_random_number_stored);

     	-- port map of the anisotropic selection
	selection_inst: anisotropic_selection
     	generic MAP(N => N)
    	PORT MAP(
	    random_number   =>  sig_random_number_stored, 
	    north           =>  sig_north_stored, 
	    south           =>  sig_south_stored, 
	    east            =>  sig_east_stored, 
	    back            =>  sig_back_stored, 
	    front           =>  sig_front_stored, 
	    west            =>  sig_west_stored, 
	    sel_chromosome  =>  sig_sel_chromosome); 
	
	--register that stores the sel chromosome
	register_sel_chromosome : basic_register
	GENERIC MAP(N=>N)
	PORT MAP(CLK=>CLK,RST=>RST,D=>sig_sel_chromosome,Q=>sig_sel_chromosome_stored);
	
	-- crossover component
	crossover_inst : crossover
    	generic MAP(N =>N)
     	port MAP(
          chromosome_one   => sig_sel_chromosome, 
          chromosome_two   => sig_c_stored,
          offspring_one    => sig_cross_ind_one,
          offspring_two    => sig_cross_ind_two);

	--register that stores the cross chromosome one
	register_cross_chromosome_one : basic_register
	GENERIC MAP(N=>N)
	PORT MAP(CLK=>CLK,RST=>RST,D=>sig_cross_ind_one,Q=>sig_cross_ind_one_stored);
	--register that stores the cross chromosome two
	register_cross_chromosome_two : basic_register
	GENERIC MAP(N=>N)
	PORT MAP(CLK=>CLK,RST=>RST,D=>sig_cross_ind_two,Q=>sig_cross_ind_two_stored);

	-- mutation component
     	mutation_inst :  mutation
     	generic MAP(N =>N, resolution => resolution )
     	port MAP(
           chromosome_one => sig_cross_ind_one_stored,   
           chromosome_two => sig_cross_ind_one_stored,
	   random_number  => sig_random_number_stored,
	   NewChrom_1     => sig_mut_ind_one,
	   NewChrom_2     => sig_mut_ind_two);

	--register that stores the mutated chromosome one
	register_mut_chromosome_one : basic_register
	GENERIC MAP(N=>N)
	PORT MAP(CLK=>CLK,RST=>RST,D=>sig_mut_ind_one ,Q=>sig_mut_ind_one_stored);
	--register that stores the mutated chromosome two
	register_mut_chromosome_two : basic_register
	GENERIC MAP(N=>N)
	PORT MAP(CLK=>CLK,RST=>RST,D=>sig_mut_ind_two ,Q=>sig_mut_ind_two_stored);

	evaluator_inst : evaluator
     	port map (
	      chromosome  =>  ev_chromosome,
	      fitness	  => ev_chromosome_fitness);


 -- sequencial block that control the states switching
        PROCESS(clk,rst)
        BEGIN
                IF rst = '1' THEN
                        current_state  <= read_inputs;
                ELSIF(clk'event AND clk = '1') THEN
                        current_state <= next_state;
                END IF;
        END PROCESS;


        -- process that controls the change of states
        PROCESS(current_state,valid)
        BEGIN
                CASE current_state IS
			             WHEN read_inputs=>
                        --estado_siguiente         <= inicializar_semilla;
				            if valid = '1' then
                        		next_state      <= state_selection;
				            else
					           next_state	<= read_inputs;
					        end if;
                        
                         WHEN state_selection =>
                            next_state	<= state_crossover;

                        WHEN state_crossover =>
				            next_state	<= state_mutation;

                        WHEN state_mutation =>
				            next_state	<= evaluation_one;
		
			            when evaluation_one =>
				            next_state	<= evaluation_two;

			            when evaluation_two =>
				            next_state	<= compare;

                        when compare        =>
                              next_state      <= finished;
                        WHEN OTHERS =>
				            next_state	<= read_inputs;
                    END CASE;
        END PROCESS;

-- part that describes the combinatonal logic
	PROCESS(current_state,clk)
        BEGIN
		IF(clk'event AND clk = '1') THEN
                	CASE current_state IS
 				WHEN read_inputs=>
					sig_north    	     <= north; 	
					sig_south    	     <= south;  
					sig_west     	     <= west; 
					sig_east     	     <= east;
					sig_front            <= front;
					sig_back             <= back;
					sig_c  		     <= c;
					sig_random_number    <= random_number;

					DONE 	<= '0';
        			ev_ind 	<= '0';	
                WHEN state_selection =>
					DONE 	<= '0';
        		    ev_ind 	<= '0';	

              	WHEN state_crossover =>
					DONE 	<= '0';
        			ev_ind 	<= '0';	

                WHEN state_mutation =>
					DONE 	<= '0';
        			ev_ind 	<= '0';	
		
				when evaluation_one =>
					DONE 	<= '0';
        			ev_ind 	<= '1';	
					fitness_one <= ev_chromosome_fitness;
					
				when evaluation_two =>
					DONE 	<= '0';
        			ev_ind 	<= '1';	
					fitness_two <= ev_chromosome_fitness;
								
				when compare =>                        	
					if fitness_one>fitness_two then
					   new_chromosome <= sig_mut_ind_one_stored;
					else
                       new_chromosome <= sig_mut_ind_two_stored;
                    end if;				
                    
                    if fitness_one>fitness_two then
                        new_fitness <= fitness_one;
                    else
                        new_fitness <= fitness_two;
                    end if;
                    
					DONE <= '0';
					ev_ind <= '0';
				WHEN finished =>
					DONE 	<= '1';
        			ev_ind 	<= '0';
        			   
        	end case;	
		END IF;
	END PROCESS;

ev_chromosome <= sig_mut_ind_one_stored  when ev_ind = '0' else
                 sig_mut_ind_two_stored;

best_individual  <= new_chromosome;	
best_fitness	 <= new_fitness;

end Behavioral;

