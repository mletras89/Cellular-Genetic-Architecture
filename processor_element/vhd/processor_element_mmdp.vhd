----------------------------------------------------------------------------------
-- Company: FAU 
-- Engineer: Martin Letras
-- 
-- Create Date:    17:01:35 09/08/2014 
-- Design Name: Processor Array for Implementing 2D/3D Cellular Genetic Algorithm
-- Module Name:    processorElement - Behavioral 
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

-- N is the chromosome size
-- M is the size bus for the fitness function, smaller than N
-- RESOLUTION stores the resoulition of the probability vector for the mutation
-- LDS  is the bus size for the input of the register bank of chromosomes adresses
-- LDF  is the bus size for the fitness values 
-- I J are indices I is the row and J the column
-- INDIVIDUALS is the number of individuals in the processor element
-- FIT receives the value of the ideal fitness
-- GEN receives the number of generations 
-- DIM is the dimension of the processor array DIM X DIM

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
USE work.datatypes_mmdp.ALL;

ENTITY processor_element_mmdp IS

  GENERIC(N  : POSITIVE:=64; M  : POSITIVE :=16; resolution : POSITIVE :=6; individuals: POSITIVE:=16; 
          LDS: POSITIVE:=4; LDF: POSITIVE :=4; i          : INTEGER :=0; j         : INTEGER:=0;
          FIT: POSITIVE:=9; GEN: POSITIVE :=400; DIM              : POSITIVE :=2;
          INC_ARRAY : POSITIVE :=4);

  PORT( 
        rst         : in  std_logic;
        clk         : in  std_logic;
        start_ev    : in  std_logic;
        in_sys      : IN  std_logic_vector(N-1 DOWNTO 0); 
        out_sys     : OUT std_logic_vector(N-1 DOWNTO 0);
         -- input signals for the closest neighbours
        north       : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);         
        south       : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);         
        west        : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);         
        east        : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);         

        Onorth      : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);         
        Osouth      : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);         
        Owest       : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);         
        Oeast       : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        current     : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)         
        );
END processor_element_mmdp;

ARCHITECTURE rtl OF processor_element_mmdp IS

  -- component register_bank_fitness
  component register_bank_fitness is
  generic(individuals: POSITIVE:=4;    M : POSITIVE:= 6;   LDS : POSITIVE:=4;
        i                       : integer :=7;  j : integer:=7;         DIM : POSITIVE:=9;
        INC_ARRAY : POSITIVE :=3);
  port (  clk  : IN  STD_LOGIC;
        we   : IN  STD_LOGIC;                           -- write enable
        en   : IN  STD_LOGIC;                           -- enable
        ep   : IN   STD_LOGIC;                          -- singnal that indicates to output the parallel data
        addr : IN  STD_LOGIC_VECTOR(LDS-1 DOWNTO 0);    -- writing address
        di   : IN  STD_LOGIC_VECTOR(M-1 DOWNTO 0);
        ip   : IN  ENTRADA_PAR_FIT;                     -- parallel input 
        da   : OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0));
  end component;

  -- component register_bank_temporal_fitness
  component register_bank_temporal_fitness is
  generic(individuals: POSITIVE:=4; M : POSITIVE:= 6; LDS : POSITIVE:=4);
  port (  clk  : IN  STD_LOGIC;
        we   : IN  STD_LOGIC;-- write enable
        en   : IN  STD_LOGIC;-- enable
        addr : IN  STD_LOGIC_VECTOR(LDS-1 DOWNTO 0); --writing address
        di   : IN  STD_LOGIC_VECTOR(M-1 DOWNTO 0);
        do   : OUT ENTRADA_PAR_FIT);
  end component;

  -- component register_bank
  component register_bank is
  generic(individuals: POSITIVE:=4;   N : POSITIVE:= 64;  LDS : POSITIVE:=4;
                i                       : integer :=7;  j : integer:=7;         DIM : POSITIVE:=9;
                INC_ARRAY : POSITIVE :=3);
  port (  clk  : IN  STD_LOGIC;
          we   : IN  STD_LOGIC;                           -- write enable
          en   : IN  STD_LOGIC;                           -- enable
          ep   : IN   STD_LOGIC;                      -- when this signal is activated all the data in the bank is sended to the outputs
          addr : IN  STD_LOGIC_VECTOR(LDS-1 DOWNTO 0);    -- writing address
          di   : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);      -- input data
          ip   : IN  ENTRADA_PAR;                         -- parallel input
          da   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
          dN   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
          dS   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
          dE   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
          dW   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
          dB   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
          dF   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
  end component;

  -- component register_bank_temporal
  component register_bank_temporal is
  generic(individuals: POSITIVE:=4; N : POSITIVE:= 9; LDS : POSITIVE:=4);
  port (  clk  : IN  STD_LOGIC;
          we   : IN  STD_LOGIC;       -- write enable
          en   : IN  STD_LOGIC;       -- enable
          addr : IN  STD_LOGIC_VECTOR(LDS-1 DOWNTO 0); --write address
          di   : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
          do   : OUT ENTRADA_PAR);
  end component;

    component genetic_operators is
    GENERIC(N  : POSITIVE:=32; M  : POSITIVE :=16; resolution : POSITIVE :=5 );
         PORT(
                        CLK                     : IN  STD_LOGIC;
                        RST                     : IN  STD_LOGIC;

                        DONE                    : OUT  STD_LOGIC;
                        VALID                   : IN  STD_LOGIC;

                        north                   : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
                        south                   : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
                        west                    : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
                        east                    : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
                        front                   : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
                        back                    : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);

                        c                       : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);

                        random_number           : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);

                        best_individual : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
                        best_fitness    : OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0));
    end component;



signal systolic_stored_value : std_logic_vector(N-1 DOWNTO 0);

TYPE state_systolic IS (read_input, propagate_output);
SIGNAL current_state_systolic, next_state_systolic : state_systolic;

TYPE state IS (start,init_pop,operators,finished,start_operators,store_results,update_banks,stop_condition);
SIGNAL current_state, next_state : state;

-- signals for connecting the memory to the individuals
SIGNAL we1                                                      : STD_LOGIC:= '0';
SIGNAL en1                                                      : STD_LOGIC:= '0';
SIGNAL we2                                                      : STD_LOGIC:= '0';
SIGNAL en2                                                      : STD_LOGIC:= '0';
SIGNAL ep                                                       : STD_LOGIC:= '0';

-- signal for the systolic array
SIGNAL counter                                          : INTEGER:=0;
-- signal used to connect the processed individuals
SIGNAL individuals_counter                          	: INTEGER:=0;
SIGNAL interations_counter                      	: INTEGER:=0;

-- signals for the counters
SIGNAL output_counter_n                         : STD_LOGIC_VECTOR(LDS-1 DOWNTO 0);
SIGNAL output_counter_m                         : STD_LOGIC_VECTOR(LDS-1 DOWNTO 0);

-- signals for the parallel outputs
SIGNAL parallel_bus                         : ENTRADA_PAR;
SIGNAL parallel_bus_fitness                 : ENTRADA_PAR_FIT;

SIGNAL output_current_chromosome  : STD_LOGIC_VECTOR(N-1 downto 0);
SIGNAL output_current_fitness     : STD_LOGIC_VECTOR(M-1 downto 0);
SIGNAL output_ff                  : STD_LOGIC_VECTOR(M-1 DOWNTO 0);
-- remove when operators
signal best_individual     : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL best_fitness        : STD_LOGIC_VECTOR(M-1 DOWNTO 0);

signal out_best_ind_ops     : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL output_best_fit_ops        : STD_LOGIC_VECTOR(M-1 DOWNTO 0);

signal DONE_OPS   : std_logic;
signal VALID_OPS : std_logic;

signal dB   : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
signal dF   : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
BEGIN

        -- component register_bank_temporal 
        component_register_bank_temporal: register_bank_temporal
        GENERIC MAP(individuals => individuals, N => N, LDS => LDS)
        PORT MAP(clk => clk, we => we2, en=> en2, addr=> output_counter_n,
                                di => best_individual, do=> parallel_bus);

        -- component register_bank
        component_register_bank: register_bank
        GENERIC MAP(individuals=>individuals, N =>N, LDS => LDS, i      => i,   j => j, DIM => DIM,INC_ARRAY =>INC_ARRAY)
        PORT MAP(clk => clk, we => we1, en=> en1, ep => ep, addr=>output_counter_n,
                                di => systolic_stored_value,ip  => parallel_bus, da => output_current_chromosome, dN =>Onorth,
                                dS => Osouth, dE => OEast, dW => OWest, dB => dB, dF =>dF);

        -- component register_bank_temporal_fitness
        component_register_bank_temporal_fitness: register_bank_temporal_fitness
        GENERIC MAP(individuals => individuals, M => M, LDS => LDS)
        PORT MAP(clk => clk, we => we2, en=> en2, addr=> output_counter_m,
                                di => best_fitness, do=> parallel_bus_fitness);

        -- component_register_bank_fitness
        component_register_bank_fitness: register_bank_fitness
        GENERIC MAP(individuals=>individuals, M =>M, LDS => LDS, i      => i,   j => j, DIM => DIM,INC_ARRAY =>INC_ARRAY)
        PORT MAP(clk => clk, we => we1, en=> en1, ep => ep, addr => output_counter_m,
                                di => output_ff,ip  => parallel_bus_fitness, da => output_current_fitness);

        output_counter_n <= conv_std_logic_vector(individuals_counter-1,LDS);
        output_counter_m <= conv_std_logic_vector(individuals_counter-1,LDF);

        -- component genetic operators
        inst_gen_ops : genetic_operators
        GENERIC MAP(N => N, M => M, resolution => resolution)
        PORT MAP(
                 CLK => CLK, RST => RST, DONE => DONE_OPS, VALID => VALID_OPS, north => north, south => south,
                 west => west, east => east, front => dF, back => dB, c => output_current_chromosome,random_number => systolic_stored_value,
                 best_individual => best_individual,best_fitness => best_fitness);



 -- sequencial block that control the states switching
        PROCESS(clk,rst)
        BEGIN
                IF rst = '1' THEN
                        current_state_systolic  <= read_input;
                        current_state           <= start;
                ELSIF(clk'event AND clk = '1') THEN
                        current_state_systolic <= next_state_systolic;
                        current_state          <= next_state;
                END IF;
        END PROCESS;

        -- process that controls the change of states
        PROCESS(current_state_systolic)
        BEGIN
          CASE current_state_systolic IS
            WHEN read_input=>
                next_state_systolic      <= propagate_output;

            WHEN propagate_output =>
                next_state_systolic  <= read_input;
          END CASE;
        END PROCESS;

        PROCESS(current_state_systolic,clk)
        BEGIN
          IF(clk'event AND clk = '1') THEN
            CASE current_state_systolic IS
              WHEN read_input=>
                systolic_stored_value <= in_sys; 
              WHEN propagate_output=>
                out_sys <= systolic_stored_value;
            END CASE;
          END IF;
        END PROCESS;


	-- process that controls the change of states
	PROCESS(current_state,start_ev,counter,individuals_counter,interations_counter,DONE_OPS)
	BEGIN
	  CASE current_state IS
	    WHEN start=>
	        if start_ev = '1' then
	           next_state      <= init_pop;
	        else
	           next_state      <= start;
	        end if;
	                         
	    WHEN init_pop =>
                IF individuals  = individuals_counter THEN
                	next_state      <= start_operators;
                END IF;
        WHEN start_operators =>
                IF individuals = individuals_counter THEN
                    next_state      <= update_banks;
                else
                    next_state      <= operators;
                END IF;
             
        WHEN operators =>
            if DONE_OPS = '1' then
	           next_state  <= store_results;
	        end if;
	    
	    WHEN store_results =>
            next_state  <= start_operators;


        WHEN update_banks =>
		       next_state <= stop_condition;
		
		WHEN stop_condition =>
		      IF interations_counter = GEN THEN
                next_state      <= finished;
              else
                next_state      <= start_operators;
              END IF;
	    WHEN finished =>
		next_state <= finished;

	  END CASE;
	END PROCESS;

        PROCESS(current_state,clk)
        BEGIN
          IF(clk'event AND clk = '1') THEN
            CASE current_state IS
              WHEN start =>
			counter      		<= 0;
                        individuals_counter     <= 0;
                        interations_counter     <= 0;
                        counter     		    <= 0;
                        
                        en2     <= '1';
                        we2     <= '0';
                        en1     <= '1';
                        we1     <= '1';
                        ep      <= '0';
                        VALID_OPS <= '0';
                        
                        output_ff <= std_logic_vector(to_signed(0, output_ff'length)); --x"0000";
              WHEN init_pop =>
                        
                        IF individuals_counter = individuals THEN
                                counter     		    <= 0;
                                individuals_counter     <= 0;
                                interations_counter     <= 0;

                                en2     <= '1';
                                we2     <= '0';
                                en1     <= '1';
                                we1     <= '0';
                                ep      <= '0';
                        ELSE
                                individuals_counter <= individuals_counter + 1;
                                en2     <= '1';
                                we2     <= '0';
                                en1     <= '1';
                                we1     <= '1';
                                ep      <= '0';
                        END IF;
                        
                        VALID_OPS <= '0';
                        output_ff <= std_logic_vector(to_signed(0, output_ff'length));
                        
                        
              WHEN start_operators =>
                        IF individuals_counter = individuals THEN
                            counter                 <= 0;
                            individuals_counter     <= 0;
                            --interations_counter     <= 0;
              
                            en2     <= '1';
                            we2     <= '0';
                            en1     <= '1';
                            we1     <= '0';
                            ep      <= '0';
                         ELSE
                            individuals_counter <= individuals_counter + 1;
                            en2     <= '1';
                            we2     <= '0';
                            en1     <= '1';
                            we1     <= '1';
                            ep      <= '0';
                            VALID_OPS <= '1';
                         END IF;
              

              WHEN operators =>
                                VALID_OPS <= '0';
                                en2     <= '1';
                                we2     <= '0';
                                en1     <= '1';
                                we1     <= '0';
                                ep      <= '0';
                                
              WHEN store_results =>
                                VALID_OPS <= '0';
                                en2     <= '1';
                                we2     <= '1';
                                en1     <= '1';
                                we1     <= '0';
                                ep      <= '0';
              
              WHEN update_banks =>
                                VALID_OPS <= '0';
                                en2     <= '1';
                                we2     <= '0';
                                en1     <= '1';
                                we1     <= '0';
                                ep      <= '1';
                
            WHEN stop_condition =>
                                VALID_OPS <= '0';
                                IF interations_counter = GEN THEN
                                    en2     <= '1';
                                    we2     <= '0';
                                    en1     <= '1';
                                    we1     <= '0';
                                    ep      <= '0';
                                else
                                    interations_counter     <= interations_counter +1;
                                    en2     <= '1';
                                    we2     <= '0';
                                    en1     <= '1';
                                    we1     <= '0';
                                    ep      <= '0';
                                END IF;

              WHEN finished =>
                                VALID_OPS <= '0';
                                en2     <= '1';
                                we2     <= '0';
                                en1     <= '1';
                                we1     <= '0';
                                ep      <= '0';
	    
            END CASE;
          END IF;
        END PROCESS;

current <= output_current_chromosome;

END;
