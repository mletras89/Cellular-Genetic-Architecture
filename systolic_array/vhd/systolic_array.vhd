LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY systolic_array IS
  GENERIC(N  : POSITIVE:=32);
  PORT( 
        rst         : in  std_logic;
        clk         : in  std_logic;
        in_sys      : IN  std_logic_vector(N-1 DOWNTO 0); 
        out_sys     : OUT std_logic_vector(N-1 DOWNTO 0)  
        );
END systolic_array;

ARCHITECTURE rtl OF systolic_array IS

COMPONENT systolic_array_pe IS
  GENERIC(N  : POSITIVE:=32);
  PORT( 
        rst         : in  std_logic;
        clk         : in  std_logic;
        in_sys      : IN  std_logic_vector(N-1 DOWNTO 0); 
        out_sys     : OUT std_logic_vector(N-1 DOWNTO 0)  
        );
END COMPONENT;

SIGNAL int_one : std_logic_vector(N-1 DOWNTO 0);  
SIGNAL int_two : std_logic_vector(N-1 DOWNTO 0);  

BEGIN

p1 : systolic_array_pe
        GENERIC MAP(N=>N)
  	PORT MAP( 
        	rst         => rst, 
        	clk         => clk, 
        	in_sys      => in_sys, 
        	out_sys     => int_one);

p2 : systolic_array_pe
        GENERIC MAP(N=>N)
  	PORT MAP( 
        	rst         => rst, 
        	clk         => clk, 
        	in_sys      => int_one, 
        	out_sys     => int_two);

p3 : systolic_array_pe
        GENERIC MAP(N=>N)
  	PORT MAP( 
        	rst         => rst, 
        	clk         => clk, 
        	in_sys      => int_two, 
        	out_sys     => out_sys);

END;
