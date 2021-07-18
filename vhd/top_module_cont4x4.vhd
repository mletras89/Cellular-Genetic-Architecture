----------------------------------------------------------------------------------
-- Company: FAU
-- Engineer: Martin Letras
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

entity top_module_cont4x4 is
	generic(N  : POSITIVE:=32;  M  : POSITIVE :=16;     resolucion : POSITIVE :=5; individuos: POSITIVE:=4; 
	        LDS: POSITIVE:=4;   LDF: POSITIVE :=4;     FIT: POSITIVE:=9;           GEN: POSITIVE :=400; 
		DIM: POSITIVE :=4;  INC_ARRAY : POSITIVE:=4);
	port(
	      clk       			: in  std_logic;   -- reloj general
	      start_ev       			: in  std_logic;   -- reloj general
	      rst      			: in  std_logic;  -- reset general
	      salida1    			: OUT  STD_LOGIC_VECTOR(N-1 DOWNTO 0));
end top_module_cont4x4;

architecture Behavioral of top_module_cont4x4 is

component processor_element_cont IS

  GENERIC(N  : POSITIVE:=32; M  : POSITIVE :=16; resolution : POSITIVE :=5; individuals: POSITIVE:=16;
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
END component;

    component rng_xoshiro128plusplus_64bits is
    generic (
        -- Default seed values.
        init_seed1:  std_logic_vector(127 downto 0);
        init_seed2:  std_logic_vector(127 downto 0));
    port (
        clk:        in  std_logic;
        rst:        in  std_logic;
        out_ready:  in  std_logic;
        out_valid:  out std_logic;
        out_data:   out std_logic_vector(63 downto 0) );
    end component;

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
	type seal_sist is array (DIM downto 0,DIM-1 downto 0) of std_logic_vector (N-1 downto 0);
	signal sist_A : seal_sist; -- para EN_IZQ Y SAL_DER

	type salidas_crom is array (DIM-1 downto 0,DIM-1 downto 0) of std_logic_vector (N-1 Downto 0);
	signal cromos : salidas_crom;

    signal out_rng_01 : std_logic_vector(63 downto 0);
    signal out_rng_02 : std_logic_vector(63 downto 0);
    signal out_rng_03 : std_logic_vector(63 downto 0);
    signal out_rng_04 : std_logic_vector(63 downto 0);
begin
        inst_rng_01 : rng_xoshiro128plusplus_64bits
    	generic map(
            init_seed1 => x"0123456789abcdef3141592653589793",
            init_seed2 => x"0123456789abcdef3141592653589793")
    	port map(
        	clk       => clk, 
        	rst       => rst,
        	out_ready => start_ev,
        	out_valid => open,
        	out_data  => out_rng_01);
        
        sist_A(0,0) <= out_rng_01(N-1 downto 0);
        
        inst_rng_2: rng_xoshiro128plusplus_64bits
    	generic map (
            init_seed1 => x"0ff3456789abcdef3141592653589793",
            init_seed2 => x"0233456789abcdef3141592653589793")
    	port map(
        	clk       => clk, 
        	rst       => rst,
        	out_ready => start_ev,
        	out_valid => open,
        	out_data  => out_rng_02);
        
        sist_A(0,1) <= out_rng_02(N-1 downto 0);

        inst_rng_3 : rng_xoshiro128plusplus_64bits
        generic map(
            init_seed1 => x"0123456789abcdef3141592653589792",
            init_seed2 => x"0123456789abcdef3141592653589792")
        port map(
                clk       => clk, 
                rst       => rst,
                out_ready => start_ev,
                out_valid => open,
                out_data  => out_rng_03);
        
        sist_A(0,2) <= out_rng_03(N-1 downto 0);
        
        inst_rng_4: rng_xoshiro128plusplus_64bits
        generic map (
            init_seed1 => x"0ff3456789abcdef3141592653589794",
            init_seed2 => x"0233456789abcdef3141592653589794")
        port map(
                clk       => clk, 
                rst       => rst,
                out_ready => start_ev,
                out_valid => open,
                out_data  => out_rng_04);
        
        sist_A(0,3) <= out_rng_04(N-1 downto 0);              
        
	g1: for i in 0 to DIM-1 generate
	begin
		g2: for j in 0 to DIM-1 generate
		begin
			u0A: processor_element_cont
			generic map(N=>N, M => M, resolution =>resolucion, individuals => individuos, LDS => LDS, LDF => LDF, 
					i => i,  j => j, FIT => FIT, GEN => GEN , DIM => DIM,INC_ARRAY=>INC_ARRAY)
			port map(clk => clk, 
				     rst => rst, 
        			 start_ev => start_ev,
        			 in_sys => sist_A(i,j), 
        			 out_sys  =>sist_A(i+1,j),
			         north => seales_D(i,j), --fitnessN => fitness_D(i,j),
			     	 south => seales_C((i+1) mod DIM,j), --fitnessS => fitness_C((i+1) mod DIM,j),
			         west  => seales_A(i,j), --fitnessW => fitness_A(i,j),
			         east  => seales_B(i,(j+1) mod DIM), -- fitnessE => fitness_B(i,(j+1) mod DIM), 
			         Onorth => seales_C(i,j), --OfitnessN => fitness_C(i,j),
			         Osouth => seales_D((i+1) mod DIM,j), --OfitnessS => fitness_D((i+1) mod DIM,j),
			         Owest  => seales_B(i,j), --OfitnessW => fitness_B(i,j),
			         Oeast  => seales_A(i,(j+1) mod DIM), --OfitnessE => fitness_A(i,(j+1) mod DIM),
			         current =>cromos(i,j) );
			
		end generate;
	end generate;
				
     
salida1 <= cromos(0,0) and cromos(0,1) and cromos(0,2) and cromos(0,3) and cromos(1,0) and cromos(1,1) and cromos(1,2) and cromos(1,3) and cromos(2,0) and cromos(2,1) and cromos(2,2) and cromos(2,3) and cromos(3,0) and cromos(3,1) and cromos(3,2) and cromos(3,3);

end Behavioral;

