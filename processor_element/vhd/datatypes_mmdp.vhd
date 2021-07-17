--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package datatypes_mmdp is

	-- antes de sintetizar se tiene que modificar los datos aqui en el paquete
	-- para las entradas/ salidas de los bancos de registros XD
	constant individuosI			: integer := 16;
	constant NI						: integer := 64;  -- ES EL TAMAÑO DEL VECTOR DEL CROMOSOMA
	constant MI						: integer := 16;
	
	
	
	TYPE ENTRADA_PAR IS ARRAY(individuosI-1 DOWNTO 0) OF STD_LOGIC_VECTOR(NI-1 DOWNTO 0);
	
	TYPE ENTRADA_PAR_FIT IS ARRAY(individuosI-1 DOWNTO 0) OF STD_LOGIC_VECTOR(MI-1 DOWNTO 0);
	
-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

end package datatypes_mmdp;

