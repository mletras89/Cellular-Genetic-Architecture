LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY systolic_array_pe IS
  GENERIC(N  : POSITIVE:=32);
  PORT( 
        rst         : in  std_logic;
        clk         : in  std_logic;
        in_sys      : IN  std_logic_vector(N-1 DOWNTO 0); 
        out_sys     : OUT std_logic_vector(N-1 DOWNTO 0)  
        );
END systolic_array_pe;

ARCHITECTURE rtl OF systolic_array_pe IS

--component basic_register is
--    generic (N: integer := 8);
--    Port (
--          CLK             : IN  STD_LOGIC;
--          RST             : IN  STD_LOGIC;
--          D               : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
--          Q               : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0):=(OTHERS => '0'));
--end component;


signal systolic_stored_value : std_logic_vector(N-1 DOWNTO 0);

TYPE state IS (read_input, propagate_output);
SIGNAL current_state, next_state : state;
BEGIN
--        register_sys : basic_register
--        GENERIC MAP(N=>N)
--        PORT MAP(CLK=>CLK,RST=>RST,D=>in_sys,Q=>out_sys);


 -- sequencial block that control the states switching
        PROCESS(clk,rst)
        BEGIN
                IF rst = '1' THEN
                        current_state  <= read_input;
                ELSIF(clk'event AND clk = '1') THEN
                        current_state <= next_state;
                END IF;
        END PROCESS;

                -- process that controls the change of states
        PROCESS(current_state)
        BEGIN
          CASE current_state IS
            WHEN read_input=>
                next_state      <= propagate_output;

            WHEN propagate_output =>
                next_state  <= read_input;
          END CASE;
        END PROCESS;

        PROCESS(current_state,clk)
        BEGIN
          IF(clk'event AND clk = '1') THEN
            CASE current_state IS
              WHEN read_input=>
                systolic_stored_value <= in_sys; 
              WHEN propagate_output=>
                out_sys <= systolic_stored_value;
            END CASE;
          END IF;
        END PROCESS;

END;
