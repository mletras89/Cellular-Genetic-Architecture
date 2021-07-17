----------------------------------------------------------------------------------
-- Company: INAOE
-- Engineer: Marty Letras
-- 
-- Create Date:  11:40:07 10/14/2014 
-- Design Name:  Processor Array for Implementing 2D/3D Cellular Genetic Algorithm
-- Module Name:  top_module - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_module is
	generic(N  : POSITIVE:=64;  M  : POSITIVE :=7; resolucion : POSITIVE :=6; individuos: POSITIVE:=4; 
			  LDS: POSITIVE:=4; LDF: POSITIVE :=4; FIT: POSITIVE:=9;          GEN: POSITIVE :=400; 
			  DIM		  : POSITIVE :=4;          TAM_RNG: POSITIVE:=48; NUM_RNG: POSITIVE:=8; INC_ARRAY : POSITIVE:=4 );
	
	port(
					clk      			: in  std_logic;   -- reloj general
					reset    			: in  std_logic;  -- reset general
					salida1    			: OUT  STD_LOGIC_VECTOR(N-1 DOWNTO 0)		-- SEAL ENTRADA PARA EL MODULO SELECCION
					--salida2    			: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- SEAL ENTRADA PARA EL MODULO SELECCION
					--salida3  	  		: OUT  STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- SEAL ENTRADA PARA EL MODULO SELECCION
					--salida4	    		: OUT  STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- SEAL ENTRADA PARA EL MODULO SELECCION
					--salida5    			: OUT  STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- SEAL ENTRADA PARA EL MODULO SELECCION
					--salida6    			: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- SEAL ENTRADA PARA EL MODULO SELECCION
					--salida7  	  		: OUT  STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- SEAL ENTRADA PARA EL MODULO SELECCION
					--salida8	    		: OUT  STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- SEAL ENTRADA PARA EL MODULO SELECCION
					--salida9    			: OUT  STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- SEAL ENTRADA PARA EL MODULO SELECCION
					--salida10   			: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- SEAL ENTRADA PARA EL MODULO SELECCION
					--salida11  	  		: OUT  STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- SEAL ENTRADA PARA EL MODULO SELECCION
					--salida12	    		: OUT  STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- SEAL ENTRADA PARA EL MODULO SELECCION
					--salida13   			: OUT  STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- SEAL ENTRADA PARA EL MODULO SELECCION
					--salida14   			: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- SEAL ENTRADA PARA EL MODULO SELECCION
					--salida15  	  		: OUT  STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- SEAL ENTRADA PARA EL MODULO SELECCION
					--salida16	    		: OUT  STD_LOGIC_VECTOR(N-1 DOWNTO 0)		-- SEAL ENTRADA PARA EL MODULO SELECCION
--					salida00				: out std_logic_vector(TAM_RNG*NUM_RNG-1 downto 0);
--					salida10				: out std_logic_vector(TAM_RNG*NUM_RNG-1 downto 0);
--					
--					sem2 					: IN  STD_LOGIC_VECTOR(TAM_RNG*NUM_RNG-1 DOWNTO 0);		-- SEAL ENTRADA PARA EL MODULO SELECCION
--					sem1 					: IN  STD_LOGIC_VECTOR(TAM_RNG*NUM_RNG-1 DOWNTO 0)
					
		   );
end top_module;

architecture Behavioral of top_module is

component processorElement is

generic(N  : POSITIVE:=64; M  : POSITIVE :=7; resolution : POSITIVE :=6; individuals: POSITIVE:=16; 
		  LDS: POSITIVE:=4; LDF: POSITIVE :=4; i          : INTEGER :=0; j         : INTEGER:=0;
		  FIT: POSITIVE:=9; GEN: POSITIVE :=400; DIM		  : POSITIVE :=2;
		  TAM_RNG: POSITIVE:=48; NUM_RNG: POSITIVE:=8; INC_ARRAY : POSITIVE :=4);
	
	port (
			-- control signals
			clk      		: IN  STD_LOGIC;   -- general clock
			reset    		: IN  STD_LOGIC;   -- general reset
			
			-- signals for each seed of each component

			-- input signals for the closest neighbours
			north    		: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- signal for the selection entity
			south    		: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- signal for the selection entity
			west     		: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- signal for the selection entity
			east     		: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- signal for the selection entity
			
			Onorth    		: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- signal for the selection entity
			--OfitnessN 		: OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0);		-- signal for the selection entity
			Osouth    		: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- signal for the selection entity
			--OfitnessS 		: OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0);		-- signal for the selection entity
			Owest     		: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- signal for the selection entity
			--OfitnessW 		: OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0);		-- signal for the selection entity
			Oeast     		: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- signal for the selection entity
			--OfitnessE 		: OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0);		-- signal for the selection entity
			
			-- in this implementation 
			-- the data are injected for each row, then it is necessary to add 
			-- two input ports for the inpit that is sis_izq and sis_der
			current    		: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);		-- output signal for the selection
			seed_01			: IN	STD_LOGIC_VECTOR(TAM_RNG*NUM_RNG-1 DOWNTO 0);
			seed_02			: IN	STD_LOGIC_VECTOR(TAM_RNG*NUM_RNG-1 DOWNTO 0)
			);

end component;

--	COMPONENT RNG_compuesto is
--	-- N * COUNT NOS DA EL TAMAO DEL RNG
--	generic(N  : POSITIVE:=52;count : POSITIVE);
--	port 	(	clock				: IN  STD_LOGIC;
--			reset  			: IN  STD_LOGIC;	-- active low reset
--			seed				: IN  STD_LOGIC_VECTOR(N*COUNT-1 downto 0);	-- parallel seed input
--	 		parallel_out	: OUT STD_LOGIC_VECTOR(N*COUNT-1 downto 0) -- parallel data out
--		);
--	END COMPONENT;

	-- seales para LOS BUSES DE LOS CROMOSOMAS
	type indices is array (DIM-1 downto 0, DIM-1 downto 0) of std_logic_vector (N-1 downto 0);
	signal seales_A  : indices;
	signal seales_B  : indices;
	signal seales_C  : indices;
	signal seales_D  : indices;
	
	-- SEALES PARA LOS BUSES DE LOS FITNESS
	type   fitness  is array (DIM-1 downto 0, DIM-1 downto 0) of std_logic_vector (M-1 downto 0);
	signal fitness_A  : fitness;
	signal fitness_B  : fitness;
	signal fitness_C  : fitness;
	signal fitness_D  : fitness;
	
	
	-- SELAES PARA LA CONEXION DE LOS BUSES DEL ARREGLO SISTOLICO
	type seal_sist is array (DIM-1 downto 0,DIM-1 downto 0) of std_logic_vector (TAM_RNG*NUM_RNG-1 downto 0);
	signal sist_A : seal_sist; -- para EN_IZQ Y SAL_DER
	--signal sist_B : seal_sist; -- para EN_DER Y SAL_IZQ
--
	type salidas_crom is array (DIM-1 downto 0,DIM-1 downto 0) of std_logic_vector (N-1 Downto 0);
	signal cromos : salidas_crom;
	
	-- DECLARACION DE LAS SEALES DE SALIDA DE LOS RNG
	--type salidas_RNG  is array (DIM-1 downto 0) of std_logic_vector (TAM_RNG*NUM_RNG-1 downto 0);
	--signal RNG_sal	 : salidas_RNG;
	
	
	
begin
	
--	ua00  : 	RNG_compuesto
--	GENERIC MAP(N=>TAM_RNG,COUNT=>NUM_RNG)
--	PORT MAP(clock => clk, reset => reset, seed=>sem1, parallel_out => RNG_sal(0));
--	
--	
--	ua01	:	RNG_compuesto
--	GENERIC MAP(N=>TAM_RNG,COUNT=>NUM_RNG)
--	PORT MAP(clock => clk, reset => reset, seed=>sem2, parallel_out => RNG_sal(1));
	sist_A(0,0) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100100100010001010100100100100010010101001001001001";
	sist_A(0,1) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100100100010001010100100100100010010101001001001010";
	sist_A(0,2) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100100100010001010100100100100010010101001001001000";
	sist_A(0,3) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100100100010001010100100100100010010101001001001100";
	sist_A(1,0) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100100100010001010100100100100010010101001001001000";
	sist_A(1,1) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100100100010001010100100100100010010101001001011000";
	sist_A(1,2) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100100100010001010100100100100010010101001001101000";
	sist_A(1,3) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100100100010001010100100100100010010101001011001000";
	sist_A(2,0) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100100100010001010100100100100010010101001001101000";
	sist_A(2,1) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100100100010001010100100100100011010101001001001000";
	sist_A(2,2) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100100100010001010100100100111110010001001001001000";
	sist_A(2,3) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100100100010001010100100111100010010101001001001000";
	sist_A(3,0) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100100100010001010100111100100010010101001001001000";
	sist_A(3,1) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100100100011111010100100100100010010101001001001000";
	sist_A(3,2) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100111100010001010100100100100010010101001001001000";
	sist_A(3,3) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100100100010001010101100100100010010101001001001000";
	
	--sist_B(0,0) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100100100010001010100100100100010010101001001001000";
	--sist_B(0,1) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100100100010001010100100100100010010101001001001000";
	--sist_B(1,0) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100100100010001010100100100100010010101001001001000";
	--sist_B(1,1) <= "010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101101000100101010010010010001001010100100100100010010110100010010101001001001000100101010010010010001001011010001001010100100100100010010101001001001000100101110010101001001001000100101101001000100100001000100101010010010010001001010100100100100010001010100100100100010010101001001001000";
	
	g1: for i in 0 to DIM-1 generate
	begin
		g2: for j in 0 to DIM-1 generate
		begin
			u0A: processorElement
			generic map(N=>N, M => M, resolution =>resolucion, individuals => individuos, LDS => LDS, LDF => LDF, 
					i => i,  j => j, FIT => FIT, GEN => GEN , DIM => DIM, TAM_RNG => TAM_RNG, NUM_RNG => NUM_RNG,
					INC_ARRAY=>INC_ARRAY)
			port map(clk => clk, reset => reset, 
					north => seales_D(i,j), --fitnessN => fitness_D(i,j),
					south => seales_C((i+1) mod DIM,j), --fitnessS => fitness_C((i+1) mod DIM,j),
					west  => seales_A(i,j), --fitnessW => fitness_A(i,j),
					east  => seales_B(i,(j+1) mod DIM), -- fitnessE => fitness_B(i,(j+1) mod DIM), 
					Onorth => seales_C(i,j), --OfitnessN => fitness_C(i,j),
					Osouth => seales_D((i+1) mod DIM,j), --OfitnessS => fitness_D((i+1) mod DIM,j),
					Owest  => seales_B(i,j), --OfitnessW => fitness_B(i,j),
					Oeast  => seales_A(i,(j+1) mod DIM), --OfitnessE => fitness_A(i,(j+1) mod DIM),
					current =>cromos(i,j),
					seed_01=>sist_A(i,j),
					seed_02=>sist_A(i,j)
					
					);
		
			
		end generate;
	end generate;
				
     
salida1 <= cromos(0,0) and cromos(0,1) and cromos(0,2) and cromos(0,3) and cromos(1,0) and cromos(1,1) and cromos(1,2) and cromos(1,3) and cromos(2,0) and cromos(2,1) and cromos(2,2) and cromos(2,3) and cromos(3,0) and cromos(3,1) and cromos(3,2) and cromos(3,3);

--salida1<=cromos(0,0);
--salida2<=cromos(0,1);
--salida3<=cromos(0,2);
--salida4<=cromos(0,3);
--
--salida5<=cromos(1,0);
--salida6<=cromos(1,1);
--salida7<=cromos(1,2);
--salida8<=cromos(1,3);

--salida9<=cromos(2,0);
--salida10<=cromos(2,1);
--salida11<=cromos(2,2);
--salida12<=cromos(2,3);

--salida13<=cromos(3,0);
--salida14<=cromos(3,1);
--salida15<=cromos(3,2);
--salida16<=cromos(3,3);

end Behavioral;

